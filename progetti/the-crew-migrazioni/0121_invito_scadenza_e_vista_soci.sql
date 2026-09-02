-- 0121_invito_scadenza_e_vista_soci.sql — revisione critica del 02/09/2026
--
-- Due rilievi distinti, ma entrambi sul confine fra "persona in anagrafica" e
-- "socio a registro", per questo stanno insieme:
--
--   C11  l'invito ad attivare l'accesso non scadeva mai e non era revocabile;
--   C5   la vista del libro soci nascondeva chiunque non fosse ancora
--        deliberato, soci storici importati compresi.
--
-- Nessuna delle due tocca dati contabili.

-- =============================================================================
-- 1. C11 — L'INVITO SCADE
-- =============================================================================
--
-- `invito_accesso` (0067) non aveva nessuna colonna di scadenza e
-- `attiva_accesso()` validava solo `stato = 'in_attesa'`: un link d'invito
-- restava valido per sempre finché la persona non lo usava. Chiunque entrasse
-- in possesso di una di quelle email — un inoltro, una casella condivisa, e
-- soprattutto le circa 3.000 copie partite nell'incidente del 26/08 — poteva
-- scegliere la password e diventare quell'utente: anagrafica, ricevute,
-- certificati medici.

alter table public.invito_accesso
  add column if not exists scade_il timestamptz;

-- Default a 14 giorni: abbastanza per chi apre la posta una volta a settimana,
-- abbastanza poco perché un invito dimenticato in una casella non resti una
-- chiave buona per sempre.
alter table public.invito_accesso
  alter column scade_il set default (now() + interval '14 days');

-- Gli inviti già in circolazione prendono la scadenza a partire dalla loro
-- data di creazione, non da oggi. CONSEGUENZA VOLUTA: tutti gli inviti in
-- attesa più vecchi di 14 giorni — quelli dell'incidente di agosto inclusi —
-- diventano da subito inutilizzabili. Chi ha ancora bisogno di attivare
-- l'accesso va reinvitato dal gestionale: è il verso giusto in cui sbagliare.
update public.invito_accesso
set scade_il = creato_il + interval '14 days'
where scade_il is null;

alter table public.invito_accesso
  alter column scade_il set not null;

comment on column public.invito_accesso.scade_il is
  'Oltre questo istante il token non attiva più niente (C11, 02/09/2026). Per riaprire un invito scaduto se ne crea uno nuovo dal gestionale: non si sposta la scadenza di quello vecchio.';

create index if not exists idx_invito_accesso_in_attesa
  on public.invito_accesso (persona_id, scade_il)
  where stato = 'in_attesa';

-- `attiva_accesso()` va riscritta per intero (create or replace non permette
-- di toccarne un pezzo): il corpo è quello in vigore dalla 0119 — creazione
-- dell'utente, ruolo, notifica in-app, avviso Telegram — identico, con la sola
-- aggiunta del controllo di scadenza in testa.
create or replace function public.attiva_accesso(token_in uuid, password_in text)
returns uuid
language plpgsql
security definer
set search_path = public, auth, extensions
as $$
declare
  invito_riga     public.invito_accesso;
  email_persona   citext;
  nome_persona    text;
  cognome_persona text;
  nuovo_utente_id uuid;
  ruolo_calcolato public.ruolo_utente;
begin
  if password_in is null or length(password_in) < 8 then
    raise exception 'La password deve avere almeno 8 caratteri.';
  end if;

  -- C11 (02/09/2026): si legge l'invito senza filtrare sullo stato, per poter
  -- distinguere i tre motivi di rifiuto. "Non esiste", "già usato" e "scaduto"
  -- richiedono tre azioni diverse da parte di chi legge il messaggio, e prima
  -- erano un unico "Invito non valido o già usato".
  select * into invito_riga
  from public.invito_accesso
  where token = token_in;

  if invito_riga.id is null then
    raise exception 'Invito non valido.';
  end if;

  if invito_riga.stato <> 'in_attesa' then
    raise exception 'Questo invito è già stato usato o annullato: contatta la segreteria.';
  end if;

  -- La difesa vera della scadenza sta qui, non nella pagina: è l'unico punto
  -- da cui un token può diventare un accesso.
  if invito_riga.scade_il <= now() then
    raise exception 'Questo invito è scaduto: chiedi alla segreteria di inviartene uno nuovo.';
  end if;

  select email, nome, cognome into email_persona, nome_persona, cognome_persona
  from public.persona where id = invito_riga.persona_id;
  if email_persona is null then
    raise exception 'Questa persona non ha un''email in anagrafica: contatta la segreteria.';
  end if;

  if exists (select 1 from public.utente where persona_id = invito_riga.persona_id) then
    raise exception 'Esiste già un accesso per questa persona: contatta la segreteria.';
  end if;
  if exists (select 1 from auth.users where email = email_persona::text) then
    raise exception 'Esiste già un account con questa email: contatta la segreteria.';
  end if;

  -- Stesso calcolo di crea_accesso (0031): chi ha già un collaboratore
  -- attivo (es. reso tale mentre l'invito era ancora in attesa) diventa
  -- istruttore da subito, non socio in attesa di una correzione a mano.
  ruolo_calcolato := case
    when exists (
      select 1 from public.collaboratore
      where persona_id = invito_riga.persona_id and attivo
    ) then 'istruttore'
    else 'socio'
  end::public.ruolo_utente;

  nuovo_utente_id := gen_random_uuid();

  insert into auth.users (
    id, instance_id, aud, role, email, encrypted_password,
    email_confirmed_at, confirmation_token, recovery_token,
    email_change_token_new, email_change,
    raw_app_meta_data, raw_user_meta_data,
    created_at, updated_at
  ) values (
    nuovo_utente_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
    email_persona::text, crypt(password_in, gen_salt('bf')),
    now(), '', '', '', '',
    '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb,
    now(), now()
  );

  insert into auth.identities (
    id, user_id, identity_data, provider, provider_id, last_sign_in_at, created_at, updated_at
  ) values (
    gen_random_uuid(), nuovo_utente_id,
    jsonb_build_object('sub', nuovo_utente_id::text, 'email', email_persona::text),
    'email', nuovo_utente_id::text, now(), now(), now()
  );

  perform set_config('app.autoregistrazione_utente', 'in_corso', true);
  update public.utente
  set persona_id = invito_riga.persona_id,
      ruolo = ruolo_calcolato,
      deve_cambiare_password = false
  where id = nuovo_utente_id;
  perform set_config('app.autoregistrazione_utente', '', true);

  update public.invito_accesso set stato = 'completato' where id = invito_riga.id;

  insert into public.notifica (persona_id, canale, tipo, contenuto, stato, inviata_il, riferimento_tabella, riferimento_id)
  select u.persona_id, 'in_app'::public.canale_notifica, 'accesso_attivato',
    format('%s %s ha attivato il proprio accesso (%s).', cognome_persona, nome_persona, email_persona::text),
    'inviata'::public.stato_notifica, now(),
    'invito_accesso', invito_riga.id
  from public.utente u
  where u.ruolo = 'superadmin' and u.persona_id is not null;

  perform net.http_post(
    url := 'https://thecrewgym.com/api/interno/accesso-attivato',
    headers := jsonb_build_object(
      'content-type', 'application/json',
      'x-cron-secret', (select decrypted_secret from vault.decrypted_secrets where name = 'cron_notifiche_secret')
    ),
    body := jsonb_build_object(
      'testo', format(E'🔑 Accesso attivato\n%s %s (%s)', cognome_persona, nome_persona, email_persona::text)
    )
  );

  return nuovo_utente_id;
end;
$$;

comment on function public.attiva_accesso(uuid, text) is
  'Attiva l''accesso a partire da un token d''invito valido e non scaduto (C11, 02/09/2026), crea l''utente col ruolo giusto e avvisa il gestore. Corpo invariato rispetto a 0119 salvo il controllo di scadenza.';

revoke execute on function public.attiva_accesso(uuid, text) from public;
grant execute on function public.attiva_accesso(uuid, text) to anon;

-- =============================================================================
-- 2. C5 — LA VISTA NON NASCONDE PIÙ CHI NON È ANCORA DELIBERATO
-- =============================================================================
--
-- `v_libro_soci_stato_attuale` (ultima forma in 0065) faceva un INNER join su
-- `libro_soci_numero`, e il numero progressivo lo assegna solo la conferma del
-- verbale. Conseguenza: chi aveva la domanda presentata ma non ancora
-- deliberata, e TUTTI i soci storici importati da CSV, non comparivano in
-- /gestionale/soci, nel libro soci, nell'export per il commercialista né fra
-- i candidati alla decadenza. Il chip "Tutti (N)" mostrava un numero che non
-- era il numero delle persone.
--
-- Il join diventa LEFT: `numero_progressivo` resta nullo per chi non è ancora
-- deliberato, ma la persona c'è. Chi deve mostrare il SOLO libro soci
-- ufficiale filtra esplicitamente `numero_progressivo is not null` dalla sua
-- query — la vista non è più il posto dove nascondere le persone.
--
-- Drop+create e non "or replace": cambia la nullabilità di una colonna,
-- stesso pattern di 0017/0055/0065.
drop view public.v_libro_soci_stato_attuale;

create view public.v_libro_soci_stato_attuale
with (security_invoker = true)
as
select
  p.id as persona_id,
  n.numero_progressivo,
  p.cognome,
  p.nome,
  p.codice_fiscale,
  p.qualifica_socio,
  ammissione.data_evento as data_domanda,
  ratifica.data_evento as data_ultima_ratifica,
  rinnovo.data_evento as data_ultimo_versamento,
  case
    when rinnovo.data_evento is not null then
      make_date(coalesce(rinnovo.anno_competenza, extract(year from rinnovo.data_evento)::int), 12, 31)
    else null
  end as scadenza_quota,
  case
    when rinnovo.data_evento is not null then
      make_date(coalesce(rinnovo.anno_competenza, extract(year from rinnovo.data_evento)::int) + 1, 2, 28)
    else null
  end as decadenza_quota,
  cessazione.data_evento as data_cessazione,
  cessazione.tipo_evento as tipo_cessazione,
  cessazione.motivo as motivo_cessazione,
  (cessazione.data_evento is not null and cessazione.data_evento > coalesce(rinnovo.data_evento, ammissione.data_evento)) as cessato,
  ammissione.estremi_delibera as estremi_ammissione
from public.persona p
left join public.libro_soci_numero n on n.persona_id = p.id
left join lateral (
  select data_evento, estremi_delibera
  from public.libro_soci_evento
  where persona_id = p.id and tipo_evento = any (array['domanda'::public.tipo_evento_libro_soci, 'ammissione'::public.tipo_evento_libro_soci])
  order by data_evento
  limit 1
) ammissione on true
left join lateral (
  select data_evento
  from public.libro_soci_evento
  where persona_id = p.id and tipo_evento = 'ratifica_delibera'::public.tipo_evento_libro_soci
  order by data_evento desc
  limit 1
) ratifica on true
left join lateral (
  select data_evento, anno_competenza
  from public.libro_soci_evento
  where persona_id = p.id and tipo_evento = 'rinnovo_quota'::public.tipo_evento_libro_soci
  order by data_evento desc
  limit 1
) rinnovo on true
left join lateral (
  select data_evento, tipo_evento, motivo
  from public.libro_soci_evento
  where persona_id = p.id and tipo_evento = any (array['decadenza'::public.tipo_evento_libro_soci, 'dimissioni'::public.tipo_evento_libro_soci, 'radiazione'::public.tipo_evento_libro_soci, 'decesso'::public.tipo_evento_libro_soci])
  order by data_evento desc
  limit 1
) cessazione on true
-- La vista resta il registro delle PERSONE che hanno a che fare col libro
-- soci, non di chiunque sia in anagrafica: restano fuori solo quelle senza
-- alcun evento e senza numero (es. un genitore che compare unicamente come
-- tutore, o un contatto di una pre-iscrizione mai lavorata).
where n.persona_id is not null
   or ammissione.data_evento is not null
   or rinnovo.data_evento is not null
   or cessazione.data_evento is not null
   or p.stato <> 'richiedente';

comment on view public.v_libro_soci_stato_attuale is
  'Stato corrente di ogni persona rispetto al libro soci. Dal 02/09/2026 il join sul numero progressivo è LEFT (C5): chi non è ancora deliberato ha numero_progressivo nullo ma compare. Per il libro soci ufficiale filtrare numero_progressivo is not null nella query chiamante.';
