-- 0123_persona_campi_riservati.sql — revisione critica del 02/09/2026, rilievo A1
--
-- La policy `persona_socio_aggiorna_se_e_figli` (0004:196-199) dà al socio
-- UPDATE pieno sulla propria riga di `persona` e su quelle dei minori che
-- tutela. Su `persona`, a differenza di ogni altra tabella con auto-servizio,
-- non c'era né un grant per colonna né un trigger di blocco: l'unico
-- `before update` era quello che aggiorna il timestamp.
--
-- Conseguenza concreta: un socio autenticato può chiamare PostgREST
-- direttamente con la chiave pubblica e il proprio token —
--   PATCH /rest/v1/persona?id=eq.<proprio>
--   {"stato":"socio","tesserato_csen":true,"qualifica_socio":"consigliere"}
-- — e ottenere la qualifica di socio senza delibera e senza numero di libro
-- soci, scavalcando i controlli applicativi che leggono proprio `stato`
-- (iscrizioni/azioni.ts:43, pagamenti/azioni.ts:425, `richiede_socio`).
-- Può anche riscriversi codice fiscale e data di nascita, che finiscono nella
-- domanda di adesione e nel tesseramento CSEN.
--
-- Si chiude come è già stato chiuso altrove nel progetto — `collaboratore`
-- (0043), `corso` (0105), `impegno_extra_collaboratore` (0109), `utente`
-- (0032/0067) — cioè con un trigger che rifiuta la variazione dei campi
-- riservati a chi non è superadmin, invece di togliere l'update: il socio
-- deve continuare a poter correggere da solo indirizzo, telefono ed email.

create or replace function public.blocca_campi_riservati_persona()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if public.e_superadmin() then
    return new;
  end if;

  -- Stesso lasciapassare già usato da `blocca_autoescalation_utente` (0067):
  -- le funzioni SECURITY DEFINER vetted che devono scrivere questi campi lo
  -- dichiarano esplicitamente. Serve a `registrati_collaboratore()` e
  -- `attiva_accesso()`, che agiscono per conto di una persona non ancora
  -- autenticata come superadmin.
  if coalesce(current_setting('app.registrazione_collaboratore', true), '') = 'in_corso' then
    return new;
  end if;
  if coalesce(current_setting('app.autoregistrazione_utente', true), '') = 'in_corso' then
    return new;
  end if;

  -- `stato` è quello che vale di più: è il campo su cui il codice decide se
  -- una tipologia riservata ai soci è acquistabile. Gli altri sono dati che
  -- fanno fede verso terzi (CSEN, libro soci, domanda di adesione) e non
  -- possono essere autodichiarati dall'interessato.
  if new.stato is distinct from old.stato then
    raise exception 'Lo stato di socio non si modifica da qui: dipende dalle delibere del Consiglio (libro soci).';
  end if;

  if new.qualifica_socio is distinct from old.qualifica_socio then
    raise exception 'La qualifica sociale la assegna il Consiglio, non si modifica dalla propria scheda.';
  end if;

  if new.tesserato_csen is distinct from old.tesserato_csen
     or new.numero_tessera_csen is distinct from old.numero_tessera_csen then
    raise exception 'Il tesseramento CSEN lo registra la segreteria.';
  end if;

  -- Codice fiscale e data di nascita: si possono ancora VALORIZZARE se erano
  -- vuoti (l'import storico ne ha lasciati molti nulli, e chiedere al socio di
  -- completarli è previsto), ma non cambiare una volta scritti — cambiarli
  -- significherebbe diventare un'altra persona in tutti i documenti già
  -- emessi.
  if old.codice_fiscale is not null and new.codice_fiscale is distinct from old.codice_fiscale then
    raise exception 'Il codice fiscale risulta già registrato: per correggerlo scrivi alla segreteria.';
  end if;

  if old.data_nascita is not null and new.data_nascita is distinct from old.data_nascita then
    raise exception 'La data di nascita risulta già registrata: per correggerla scrivi alla segreteria.';
  end if;

  return new;
end;
$$;

comment on function public.blocca_campi_riservati_persona() is
  'A1 (02/09/2026): impedisce a chi non è superadmin di riscriversi stato, qualifica sociale, tesseramento CSEN, codice fiscale e data di nascita sulla propria riga di persona. Indirizzo, telefono ed email restano modificabili dall''interessato.';

drop trigger if exists trg_persona_campi_riservati on public.persona;

create trigger trg_persona_campi_riservati
  before update on public.persona
  for each row execute function public.blocca_campi_riservati_persona();
