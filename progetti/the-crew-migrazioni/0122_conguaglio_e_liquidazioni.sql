-- 0122_conguaglio_e_liquidazioni.sql
--
-- Due difetti trovati nel controllo di conformità, entrambi su soldi veri.
--
-- C2 — il conguaglio si riproponeva ogni mese, per sempre. `calcolaConguagli`
-- (src/lib/collaboratori/mesi.ts) confronta la base ricalcolata OGGI di un
-- mese già `pagato` con `importo_incassato_base` congelato al momento del
-- pagamento (vincolo 1 della 0116). `salda_mesi_compenso` (0117) applicava
-- la differenza come conguaglio ma scriveva SOLO sul mese che la RICEVE
-- (`p_conguaglio_mese_id`, di solito il più vecchio del lotto che si sta
-- saldando ora): il mese da cui la differenza NASCE — un mese diverso,
-- pagato in passato — restava congelato al valore vecchio. Al ricalcolo
-- successivo la stessa differenza tornava a galla e lo stesso conguaglio
-- veniva riproposto (e pagabile una seconda volta) da capo, ogni mese.
-- Corretto qui aggiungendo `p_conguaglio_origini`: TypeScript (`saldaMesi`)
-- ricalcola fresco, con `calcolaConguagli`, i mesi di origine e i loro
-- valori aggiornati, e li passa alla RPC perché il riallineamento avvenga
-- nella STESSA transazione che paga il conguaglio — mai un pagamento
-- registrato senza il congelamento che gli corrisponde.
--
-- C3 — due strade indipendenti sullo stesso denaro. `calcolaLiquidazione`
-- (periodo libero, via `registra_liquidazione`, 0050) e `saldaMesi` (per
-- mese, via `salda_mesi_compenso`, 0117) scrivevano entrambe in
-- `liquidazione` senza sapere l'una dell'altra: chi liquidava "1/8-31/8" a
-- mano e poi saldava anche il mese di agosto pagava due volte, senza un
-- avviso. In più, `registra_liquidazione` non aveva nessun vincolo di non
-- sovrapposizione: premere "Calcola" due volte creava due liquidazioni
-- identiche. Corretto mettendo il controllo di sovrapposizione nel punto di
-- scrittura di `liquidazione` (`registra_liquidazione`) e facendo sì che
-- `salda_mesi_compenso` passi ORA da lì per la propria riga di liquidazione
-- (prima faceva un insert diretto, duplicato) — così la difesa vale per
-- entrambe le strade, non solo per una che scopre l'altra dopo il fatto.

-- ---------------------------------------------------------------------------
-- C3: registra_liquidazione — stessa firma della 0089 (create or replace,
-- nessun parametro aggiunto: il testo di partenza è quello integrale della
-- 0050/0089, con solo il controllo di sovrapposizione inserito prima
-- dell'insert).
-- ---------------------------------------------------------------------------

create or replace function public.registra_liquidazione(
  p_collaboratore_id uuid,
  p_periodo_da date,
  p_periodo_a date,
  p_importo_incassato_base numeric,
  p_percentuale_applicata numeric,
  p_base_calcolo_applicata public.base_calcolo_compenso,
  p_importo_compenso numeric,
  p_importo_detrazioni numeric,
  p_lezioni_svolte integer,
  p_lezioni_registro integer,
  p_importo_rimborsi numeric,
  p_rimborso_ids uuid[],
  p_ore_lavorate numeric default null
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_liquidazione_id uuid;
  v_conflitto record;
begin
  if not public.e_superadmin() then
    raise exception 'non autorizzato a registrare una liquidazione';
  end if;

  -- C3: nessuna liquidazione non annullata di questo collaboratore (la
  -- tabella non ha uno stato "annullata": ogni riga qui è un pagamento
  -- valido) può coprire un periodo che si sovrappone a quello richiesto.
  -- Senza questo controllo, "Calcola" premuto due volte — o questa stessa
  -- funzione richiamata da `salda_mesi_compenso` mentre esisteva già una
  -- liquidazione manuale sullo stesso mese — pagava due volte lo stesso
  -- incasso senza un avviso.
  select id, periodo_da, periodo_a, importo_compenso, stato
    into v_conflitto
    from public.liquidazione
   where collaboratore_id = p_collaboratore_id
     and periodo_da <= p_periodo_a
     and periodo_a >= p_periodo_da
   limit 1;

  if found then
    raise exception 'Esiste già una liquidazione di questo collaboratore dal % al % (stato %, compenso € %) che si sovrappone al periodo indicato: verifica se è un doppione o correggi le date prima di registrarne una nuova.',
      to_char(v_conflitto.periodo_da, 'DD/MM/YYYY'),
      to_char(v_conflitto.periodo_a, 'DD/MM/YYYY'),
      v_conflitto.stato,
      to_char(round(v_conflitto.importo_compenso, 2), 'FM999999990.00');
  end if;

  insert into public.liquidazione (
    collaboratore_id, periodo_da, periodo_a, importo_incassato_base,
    percentuale_applicata, base_calcolo_applicata, importo_compenso,
    importo_detrazioni, lezioni_svolte, lezioni_registro, importo_rimborsi,
    ore_lavorate
  ) values (
    p_collaboratore_id, p_periodo_da, p_periodo_a, p_importo_incassato_base,
    p_percentuale_applicata, p_base_calcolo_applicata, p_importo_compenso,
    p_importo_detrazioni, p_lezioni_svolte, p_lezioni_registro, p_importo_rimborsi,
    p_ore_lavorate
  )
  returning id into v_liquidazione_id;

  -- Stessa condizione già applicata in TypeScript per scegliere QUALI
  -- rimborsi agganciare (stato approvato, non ancora agganciati, dentro il
  -- periodo): qui ripetuta come difesa in profondità, non come filtro nuovo.
  if p_rimborso_ids is not null and array_length(p_rimborso_ids, 1) > 0 then
    update public.documento_rimborso_spese
    set liquidazione_id = v_liquidazione_id
    where id = any(p_rimborso_ids)
      and collaboratore_id = p_collaboratore_id
      and liquidazione_id is null;
  end if;

  return v_liquidazione_id;
end;
$$;

comment on function public.registra_liquidazione(uuid, date, date, numeric, numeric, public.base_calcolo_compenso, numeric, numeric, integer, integer, numeric, uuid[], numeric) is
  'Liquidazione + aggancio dei rimborsi spese del periodo in un''unica transazione: mai più una liquidazione creata con i rimborsi rimasti sganciati. Il calcolo resta in TypeScript. p_ore_lavorate (0089) valorizzato solo per compenso_orario. Dalla 0122: blocca la sovrapposizione di periodo con una liquidazione già esistente dello stesso collaboratore (C3) — punto di scrittura obbligato anche per salda_mesi_compenso, che ora richiama questa funzione invece di inserire per conto suo.';

-- ---------------------------------------------------------------------------
-- C2 + C3: salda_mesi_compenso — firma cambiata (nuovo parametro
-- `p_conguaglio_origini`), quindi drop+create come già fatto dalla 0089 per
-- registra_liquidazione: CREATE OR REPLACE non permette di aggiungere un
-- parametro, anche con default, senza cambiare la lista dei tipi.
-- ---------------------------------------------------------------------------

drop function if exists public.salda_mesi_compenso(
  uuid, uuid[], date, date, numeric, numeric, public.base_calcolo_compenso,
  numeric, numeric, integer, integer, numeric, uuid[], numeric, uuid, numeric, text
);

create function public.salda_mesi_compenso(
  p_collaboratore_id uuid,
  p_mese_ids uuid[],
  p_periodo_da date,
  p_periodo_a date,
  p_importo_incassato_base numeric,
  p_percentuale_applicata numeric,
  p_base_calcolo_applicata public.base_calcolo_compenso,
  p_importo_compenso numeric,
  p_importo_detrazioni numeric,
  p_lezioni_svolte integer,
  p_lezioni_registro integer,
  p_importo_rimborsi numeric,
  p_rimborso_ids uuid[],
  p_ore_lavorate numeric,
  p_conguaglio_mese_id uuid default null,
  p_conguaglio_importo numeric default null,
  p_conguaglio_motivo text default null,
  -- C2: mesi già `pagato` da cui nasce la differenza (individuati da
  -- `calcolaConguagli`, ricalcolati fresco da `saldaMesi` appena prima di
  -- chiamare questa RPC) coi valori aggiornati da congelare al posto dei
  -- vecchi. Non da confondere con `p_conguaglio_mese_id`: quello è il mese
  -- che RICEVE il conguaglio in QUESTA liquidazione (di solito tra
  -- `p_mese_ids`), questi sono i mesi la cui base va riallineata perché la
  -- differenza non si ripresenti al prossimo ricalcolo. Forma:
  -- [{"mese_id": uuid, "nuova_base": numeric, "nuovo_compenso": numeric}, ...]
  p_conguaglio_origini jsonb default null
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_liquidazione_id uuid;
  v_bloccati uuid[];
begin
  if not public.e_superadmin() then
    raise exception 'non autorizzato a saldare mesi di compenso';
  end if;

  if p_mese_ids is null or array_length(p_mese_ids, 1) is null then
    raise exception 'Indica almeno un mese da saldare.';
  end if;

  -- Lock + verifica in un solo colpo: solo mesi di QUESTO collaboratore,
  -- ancora `aperto`. Se qualcuno li ha già saldati (o non sono suoi) nel
  -- frattempo, il conteggio non torna e si blocca tutto — mai saldare "gli
  -- altri" e saltare in silenzio quello già pagato. `for update` non si può
  -- mettere sulla stessa query di un `count(*)` (Postgres lo rifiuta con le
  -- funzioni di aggregazione): si lockano le righe in una subquery, si
  -- contano fuori.
  select array_agg(id) into v_bloccati
  from (
    select id
    from public.mese_compenso
    where id = any(p_mese_ids)
      and collaboratore_id = p_collaboratore_id
      and stato = 'aperto'
    for update
  ) righe_bloccate;

  if v_bloccati is null or array_length(v_bloccati, 1) <> array_length(p_mese_ids, 1) then
    raise exception 'Uno o più mesi indicati non sono più aperti o non appartengono a questo collaboratore: ricarica la pagina e riprova.';
  end if;

  if p_conguaglio_mese_id is not null and not (p_conguaglio_mese_id = any(p_mese_ids)) then
    raise exception 'Il mese scelto per il conguaglio deve far parte dei mesi che si stanno saldando.';
  end if;

  -- C3: la riga di `liquidazione` non si inserisce più qui direttamente (era
  -- una copia dell'insert di `registra_liquidazione`, duplicata) — si passa
  -- da quella funzione, che dalla 0122 controlla anche la sovrapposizione di
  -- periodo: così una liquidazione manuale sullo stesso mese blocca anche
  -- questa strada, e viceversa, invece di ignorarsi a vicenda.
  v_liquidazione_id := public.registra_liquidazione(
    p_collaboratore_id, p_periodo_da, p_periodo_a, p_importo_incassato_base,
    p_percentuale_applicata, p_base_calcolo_applicata, p_importo_compenso,
    p_importo_detrazioni, p_lezioni_svolte, p_lezioni_registro, p_importo_rimborsi,
    p_rimborso_ids, p_ore_lavorate
  );

  -- Il conguaglio (se c'è) si scrive sul mese scelto da chi salda —
  -- normalmente il più vecchio del lotto, "il primo mese ancora aperto"
  -- della migrazione 0116, non su tutti: è un aggiustamento puntuale, non
  -- un extra spalmato.
  update public.mese_compenso
  set stato = 'pagato',
      liquidazione_id = v_liquidazione_id,
      pagato_il = now(),
      importo_conguaglio = case
        when id = p_conguaglio_mese_id then coalesce(p_conguaglio_importo, 0)
        else importo_conguaglio
      end,
      motivo_conguaglio = case
        when id = p_conguaglio_mese_id then p_conguaglio_motivo
        else motivo_conguaglio
      end
  where id = any(p_mese_ids);

  -- C2: riallinea la base congelata dei mesi DI ORIGINE del conguaglio —
  -- mesi già `pagato` in passato, tipicamente NON tra `p_mese_ids` — ai
  -- valori appena riconosciuti. Nella stessa transazione che paga il
  -- conguaglio: se questo update non avvenisse, il conguaglio risulterebbe
  -- pagato ma il mese di origine ricalcolato al prossimo giro troverebbe di
  -- nuovo la vecchia base congelata e riproporrebbe la stessa differenza,
  -- all'infinito (il difetto C2 di partenza). Filtro su `stato = 'pagato'`:
  -- un mese di origine, per definizione di `calcolaConguagli`, è sempre già
  -- pagato; il controllo è difesa in profondità, non un filtro nuovo.
  if p_conguaglio_origini is not null then
    update public.mese_compenso m
    set importo_incassato_base = (o ->> 'nuova_base')::numeric,
        importo_compenso = (o ->> 'nuovo_compenso')::numeric
    from jsonb_array_elements(p_conguaglio_origini) as o
    where m.id = (o ->> 'mese_id')::uuid
      and m.collaboratore_id = p_collaboratore_id
      and m.stato = 'pagato';
  end if;

  if p_rimborso_ids is not null and array_length(p_rimborso_ids, 1) > 0 then
    update public.documento_rimborso_spese
    set liquidazione_id = v_liquidazione_id
    where id = any(p_rimborso_ids)
      and collaboratore_id = p_collaboratore_id
      and liquidazione_id is null;
  end if;

  return v_liquidazione_id;
end;
$$;

comment on function public.salda_mesi_compenso(
  uuid, uuid[], date, date, numeric, numeric, public.base_calcolo_compenso,
  numeric, numeric, integer, integer, numeric, uuid[], numeric, uuid, numeric, text, jsonb
) is
  'Salda uno o più mesi_compenso aperti in un''unica transazione (0117): crea la liquidazione (ora via registra_liquidazione, C3), marca i mesi pagati, aggancia i rimborsi e scrive l''eventuale conguaglio proposto da calcolaConguagli() sul mese indicato. Dalla 0122: p_conguaglio_origini riallinea nella stessa transazione la base congelata dei mesi di origine del conguaglio (C2), perché la stessa differenza non venga riproposta e ripagata ogni mese. Lock esplicito (for update) + verifica del conteggio: mai saldare mesi già pagati o di un altro collaboratore.';

-- NB: `registra_liquidazione` è ora chiamata da dentro `salda_mesi_compenso`
-- (entrambe security definer, stesso proprietario): non serve grant a
-- `authenticated` per la chiamata interna, solo per l'uso diretto via RPC
-- (calcolaLiquidazione in azioni.ts), già concesso dalla 0050/0089.
revoke execute on function public.salda_mesi_compenso(
  uuid, uuid[], date, date, numeric, numeric, public.base_calcolo_compenso,
  numeric, numeric, integer, integer, numeric, uuid[], numeric, uuid, numeric, text, jsonb
) from public;
grant execute on function public.salda_mesi_compenso(
  uuid, uuid[], date, date, numeric, numeric, public.base_calcolo_compenso,
  numeric, numeric, integer, integer, numeric, uuid[], numeric, uuid, numeric, text, jsonb
) to authenticated;
