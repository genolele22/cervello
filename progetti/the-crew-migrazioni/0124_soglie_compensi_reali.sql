-- 0124_soglie_compensi_reali.sql — 02/09/2026
--
-- Le soglie di 5.000 e 15.000 € sono DELLA PERSONA, non dell'associazione:
-- valgono sull'anno solare sommando tutti gli enti sportivi che l'hanno
-- pagata, e la somma si conta per **data di erogazione** (il bonifico), non
-- per periodo lavorato. Un compenso di dicembre pagato a gennaio è reddito
-- dell'anno nuovo.
--
-- Il gestionale finora sbagliava su entrambi i fronti:
--
--   1. non esisteva nessuna data di pagamento su `liquidazione` — il
--      progressivo annuo ripiegava sul periodo liquidato, che è un'altra
--      cosa;
--   2. sommava solo ciò che paga The Crew, e lo presentava come se fosse il
--      totale della persona. Un numero incompleto che sembra completo è
--      peggio di nessun numero: è su quello che il collaboratore decide se
--      è sotto o sopra soglia.
--
-- Qui si aggiungono le due cose che mancano: la data del bonifico, e un
-- posto dove il collaboratore dichiara da sé quanto ha incassato altrove.

-- =============================================================================
-- 1. LA DATA DEL BONIFICO
-- =============================================================================

alter table public.liquidazione
  add column if not exists pagato_il      date,
  add column if not exists metodo_pagamento text
    check (metodo_pagamento is null or metodo_pagamento in ('bonifico', 'contanti', 'altro'));

comment on column public.liquidazione.pagato_il is
  'Data in cui il compenso è stato effettivamente erogato (di norma la valuta del bonifico). È questa — non il periodo liquidato — a stabilire l''anno di competenza per le soglie 5.000/15.000. Finché è nulla, il compenso è maturato ma non pagato e NON entra nel progressivo annuo.';

comment on column public.liquidazione.metodo_pagamento is
  'Come è stato erogato il compenso. Nullo finché non è pagato.';

create index if not exists idx_liquidazione_pagato_il
  on public.liquidazione (collaboratore_id, pagato_il);

-- `stato` esisteva già (0009) e `avanzaStatoLiquidazione` lo fa avanzare
-- bozza → confermata → pagata. Ma lo stato dice CHE è stata pagata, non
-- QUANDO, e l'anno di competenza dipende esattamente da quello: due
-- informazioni diverse, non una ridondante. Il trigger qui sotto tiene
-- allineate le due cose nel verso ovvio — registrare la data di erogazione
-- implica che la liquidazione è pagata — senza toccare il percorso
-- esistente, che resta valido per chi conferma prima di pagare.
create or replace function public.allinea_stato_liquidazione()
returns trigger
language plpgsql
as $$
begin
  if new.pagato_il is not null and new.stato <> 'pagata' then
    new.stato := 'pagata';
  end if;
  return new;
end;
$$;

drop trigger if exists trg_liquidazione_stato on public.liquidazione;

create trigger trg_liquidazione_stato
  before insert or update on public.liquidazione
  for each row execute function public.allinea_stato_liquidazione();

-- =============================================================================
-- 2. I COMPENSI DA ALTRI ENTI (autocertificazione del collaboratore)
-- =============================================================================
--
-- Li scrive il collaboratore, non la segreteria: sono fatti che The Crew non
-- può conoscere né verificare. Restano quindi marcati per quello che sono —
-- una dichiarazione, con la data in cui è stata fatta — e non entrano in
-- nessun calcolo automatico di ciò che l'associazione paga. Servono a dare
-- alla persona il proprio quadro completo, e a chi gestisce l'ente il numero
-- dichiarato su cui ragionare con il consulente.

create table if not exists public.compenso_altro_ente (
  id             uuid primary key default gen_random_uuid(),
  persona_id     uuid not null references public.persona (id) on delete cascade,
  ente           text not null check (char_length(trim(ente)) between 2 and 200),
  importo        numeric(10, 2) not null check (importo > 0),
  -- La data del bonifico ricevuto da quell'ente: è l'anno di questa data a
  -- decidere in quale anno il compenso pesa sulle soglie.
  data_pagamento date not null,
  note           text,
  dichiarato_il  timestamptz not null default now(),
  creato_il      timestamptz not null default now(),
  aggiornato_il  timestamptz not null default now()
);

comment on table public.compenso_altro_ente is
  'Compensi sportivi che la persona dichiara di aver ricevuto da ALTRE associazioni nello stesso anno solare. Autocertificazione del collaboratore, mai scritta dalla segreteria: le soglie 5.000/15.000 sono personali e cumulano su tutti gli enti, quindi senza questi importi il progressivo mostrato sarebbe una frazione spacciata per totale. Non entra in nessun calcolo di ciò che l''associazione eroga.';

comment on column public.compenso_altro_ente.dichiarato_il is
  'Quando la persona ha inserito o modificato la dichiarazione: serve a datare l''autocertificazione, non è un timestamp tecnico.';

alter table public.compenso_altro_ente enable row level security;

-- Il collaboratore gestisce le proprie righe, e solo quelle.
create policy compenso_altro_ente_proprio on public.compenso_altro_ente
  for all
  using (persona_id = persona_corrente())
  with check (persona_id = persona_corrente());

-- Il superadmin legge, ma NON scrive: è una dichiarazione altrui, e
-- poterla ritoccare le toglierebbe il valore che ha. Se un dato è sbagliato
-- lo corregge chi l'ha dichiarato.
create policy compenso_altro_ente_superadmin_legge on public.compenso_altro_ente
  for select
  using (e_superadmin());

create index if not exists idx_compenso_altro_ente_persona
  on public.compenso_altro_ente (persona_id, data_pagamento);

create trigger trg_compenso_altro_ente_aggiornato_il
  before update on public.compenso_altro_ente
  for each row execute function public.imposta_aggiornato_il();

-- `dichiarato_il` si rinfresca a ogni modifica: la dichiarazione che conta è
-- sempre l'ultima, e la sua data deve dirlo.
create or replace function public.aggiorna_dichiarato_il()
returns trigger
language plpgsql
as $$
begin
  new.dichiarato_il := now();
  return new;
end;
$$;

create trigger trg_compenso_altro_ente_dichiarato
  before update on public.compenso_altro_ente
  for each row execute function public.aggiorna_dichiarato_il();
