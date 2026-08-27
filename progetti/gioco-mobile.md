# Gioco mobile — Last Pact (ex "br-turni", nome in codice iniziale)

Avviato: 19/07/2026. Obiettivo dichiarato: **fruttare su app store** (revenue-first, non hobby).

## Stato

Stato: bloccato — su Lele, non sul codice. LIVE su https://last-pact.vercel.app,
  produzione ferma al deploy del 02/08. Dieci sessioni notturne di fila
  (02→27/08) hanno prodotto solo commit di report: il backlog non ha più task
  eseguibili dalla macchina.
Deciso: direzione del combattimento = **poker** (29/07). Dal 19/08 consigliato
  ripetutamente di sospendere il cron notturno fino al prossimo input di Lele.
Prossimo passo: due azioni tue, in alternativa o insieme — (1) un playtest reale
  del pacchetto "Il round si racconta", che sblocca la taratura dei 3 valori 🧪;
  (2) creare il progetto Supabase e passarmi le chiavi, unico gate di F3
  (multiplayer e persistenza: oggi tutto è locale su un telefono solo).

---

## Cos'è
Battle royale a turni **asincrono**: 24 giocatori, mappa esagonale, fog of war,
tutti giocano la mossa entro una finestra (3-4 turni/giorno) e il server risolve
tutto SIMULTANEAMENTE. Partita = 5-6 giorni, sessione = 2 minuti. Il gioco è
leggere gli avversari, alla Diplomacy. Nessun concorrente diretto sugli store.

## Perché lento e asincrono (deciso, con motivazione di mercato)
- Liquidità: bastano 24 giocatori AL GIORNO, non 24 online insieme → l'unico
  multiplayer riempibile senza budget marketing.
- Retention: notifica "è il tuo turno" = 3-4 riaperture app/giorno gratis
  (modello Wordfeud). Blitz veloce solo DOPO la massa critica (modello chess.com).

## Decisioni congelate
Combat quasi deterministico · tema dark/survival (testi di Lele) · Next.js +
Supabase · monetizzazione: rewarded ads + remove-ads, poi cosmetici/pass ·
niente pay-to-win · bot di riempimento dichiarati al lancio.

## Dove sta cosa
- Repo: `~/progetti/br-turni` — DESIGN.md (regole v0 con ❓ aperte),
  BACKLOG.md (task per le sessioni autonome), CLAUDE.md (regole macchina).
- Piano completo con fasi e gate: discusso in sessione 19/07.

## Fasi e gate
F0 design (❓ da congelare con Lele) → F1 motore TS + simulatore bot-vs-bot
(gate: vincono le scelte, non lo spawn) → F2 prototipo vs bot (gate: voglia
dell'11ª partita) → F3 multiplayer Supabase + beta caserma (gate: retention
2 settimane) → F4 store (Capacitor, AdMob, Apple 99€/anno + Google 25€).

## Il PC always-on
Sessioni notturne schedulate: implementa dal backlog, simula migliaia di
partite, scrive report in reports/. Lele decide e playtesta al mattino.
Da configurare quando il PC arriva.

## Prossimo passo (19/07/2026 — storico, superato)
F0 CHIUSA 19/07: regole v1.0 congelate in DESIGN.md (orari fissi 8/14/20,
3 HP, spettri con cap anti-abuso, imboscata, indizi, kill feed parziale,
casse a posizioni note, zaino 3 slot, max 3 partite). Manca solo il naming
([LELE], non bloccante). Ora: F1 — motore TS + simulatore, task in BACKLOG.md.


## Aggiornamento 20/07/2026
- Nome scelto: **«Tide of Bones»** (nautico maledetto, fra 20 proposte di 4 AI).
- **Gate F2 PASSATO**: prototipo web giocabile e comprensibile; il figlio di
  Lele (9 anni) si è divertito. Provato su mobile via tunnel pubblico.
- Ora **F3 = multiplayer vero** (Supabase, account, risoluzione 8/14/20,
  notifiche, bot di riempimento). Modalità corta (12 giocatori) decisa come
  seconda modalità.
- Restano da scrivere solo a Lele: tono dei testi, nome del diversivo, nomi
  dei giocatori.
- Sessioni notturne autonome funzionanti (cron 2:37, Sonnet, 6h). Collo di
  bottiglia = limite d'uso del credito, non il PC.


## Aggiornamento 25/07/2026 — svolta grafica + combattimento posizionale
- **Nome definitivo: «Last Pact»** (grimdark fantasy). "Tide of Bones" scartato
  già il 20/07.
- **Svolta grafica** (Lele genera i disegni con Gemini, Claude Code li integra —
  nessun tool immagini lato Claude): il gioco è passato da griglia esagonale
  piatta ("sembra scacchi") ad **arena come campo di battaglia** — un esagono-
  arena dipinto in prospettiva 3D con dentro i **personaggi piatti stile
  fumetto** (contrasto 2D-su-3D voluto). Riferimento: Darkest Dungeon/Slay the
  Spire, non pixel art, non 3D vero. Interfaccia **a schermo pieno stile Mob
  Control**: HUD che galleggia, comandi in un dock sulla grafica, cassetto per
  i dettagli.
- **Personaggi**: 5 varianti disegnate dal figlio/da Lele (flame, hood, camo,
  xray, skeleton), **4 pose ciascuna** (stand/corsa/attacco/**colpito**),
  ritagliate dallo sfondo verde via chroma-key. Scelta del personaggio sul
  Profilo (resta lo stesso su più partite). Idea futura: stat diverse per
  personaggio.
- **Combattimento POSIZIONALE** (24/07, terzo brainstorming con 5 AI, consenso
  unanime): tolto l'attacco "dichiarato" — con la risoluzione simultanea era
  una previsione che falliva quasi sempre ("attacca non funziona"). Ora **ti
  scontri muovendoti verso/addosso** a un nemico (chi si avvicina colpisce
  primo; adiacenza casuale = niente danno). Dock 8→7 azioni. **Bilanciamento
  saltato nei bot** (finisher 53%): da tarare DOPO un playtest umano vero, non
  alla cieca.
- **Juice del replay** (visioni di 5 AR + ricerca design a fumetti): il replay
  gira sulla stessa arena in tempo reale — "battito" della risoluzione (schermo
  che si oscura + boom), flash rosso sull'esagono colpito, scossa, **morto =
  statua di pietra** che resta sul campo, ombra che "respira".
- **Ancora prototipo locale**: si prova via tunnel cloudflared effimero (link
  che cambia a ogni riavvio), NON è un deploy. Supabase mai collegato a un
  progetto vero → tutto F3 (auth, cron, matchmaking) scritto ma non testato
  contro un DB reale. Motore: 207 test verdi.
- **Prossimi bivi aperti** (per la ripresa): (1) bilanciare il posizionale dopo
  playtest; (2) profondità del posizionale — Zona di Controllo/disingaggio,
  fianco/schiena, coperture (parcheggiate); (3) idee interfaccia dalle visioni
  non fatte — menu radiale a dito, nebbia su tutta la mappa a mezza risoluzione;
  (4) deploy vero (Vercel + progetto Supabase).


## Aggiornamento 28/07/2026 — touch, DEPLOY LIVE, vista MAPPA, combattimento a intenti

### Il gioco è ONLINE e giocabile da mobile
- **https://last-pact.vercel.app** — pubblico, apribile dal telefono. Deploy su
  Vercel (progetto `last-pact`, account genolele22, piano Hobby), non più il
  tunnel effimero. Il prototipo vs-bot gira tutto lato client → Supabase non
  serve per giocare.
- Nodo tecnico risolto: monorepo (motore in root, app in `web/`). Il deploy
  isolava `web/` e il motore `../dist` spariva → ora **vendorizzato** in
  `web/lib/engine-dist/` (copia committata, ri-sincronizzata da
  `web/sync-engine.mjs`). Deploy via CLI prebuilt. Tolto il cron `*/10` dal
  `vercel.json` (Hobby blocca cron sub-giornalieri; va rimesso con Pro/scheduler
  quando si accende F3).

### Svolta interfaccia "meno tasti / più touch" (richiesta di Lele)
- Menu radiale a dito, movimento (poi sostituito, vedi sotto), ricompensa di
  fine partita animata (monete + barra "grado", segnaposto solo locale in
  `lib/reward.ts`), pulviscolo d'ambiente, tasto risolvi rinominato **«⚔️ Vai! ▶»**,
  bersaglio rosso sui nemici, etichette azioni funzionali
  (Imboscata/Nasconditi/Difenditi/Saccheggia/Curati/Trappola/Diversivo).

### Svolta grossa: via l'arena come vista di gioco, torna la MAPPA
- Verdetto di Lele dal playtest: "molto confusionario", non si capiva di essere
  su una mappa, non si vedeva dove muoversi né il cerchio; il drag non partiva
  (lo rubava il menu contestuale di Chrome — risolto con `preventDefault`).
- Decisione condivisa: **la MAPPA è lo schermo di navigazione, l'arena resta
  solo per il combattimento (replay)**. Nuovo `components/MapView.tsx`: mappa
  esagonale con **nebbia**, velo rosso fuori dal cerchio, esagoni verdi
  raggiungibili, token tuo/nemici, casse. **Ci si muove TOCCANDO** un esagono
  (niente drag). **Telecamera ravvicinata** (raggio 2): con la nebbia non serve
  tutta la mappa e su mobile il personaggio dev'essere grande. Tasto **«Azioni»**
  esplicito nel dock (aprire il menu toccando il token era scomodo).
- **Sfondo dipinto** della mappa (Gemini): arena grimdark dall'alto con abisso
  centrale, ancorata al centro mappa così scorre col mondo. In
  `web/public/textures/map/board.webp`.

### Nuova direzione del COMBATTIMENTO — morra a 3 intenti (decisa 28/07)
- Problema di Lele: "combattere non ha gusto" (danno fisso −1, nessuna
  decisione), sistema poco chiaro. Ricerca web su design turn-based →
  principi: decisioni che contano, semplicità, **informazione perfetta/telegrafo
  (Into the Breach)**, morra + risoluzione simultanea (che il gioco ha già).
- **Scelta di Lele: morra a 3 intenti.** Lo scontro (innescato dal movimento,
  layer posizione) si risolve con **Affondo/Guardia/Finta** scelti in segreto:
  Affondo batte Finta, Guardia batte Affondo, Finta batte Guardia. Danno 0/1/2.
  Chi non sceglie è **«esposto»** (subisce l'Affondo in pieno → iniziativa e
  nebbia contano, sostituisce l'imboscata). La UI **telegrafa** le 3 conseguenze
  prima di premere. Azioni semplificate: fortifica→Guardia, imboscata→esposto.
  Default confermato da Lele = **esposto** (aggressivo, premia l'iniziativa).
- **Stato**: branch `combat-intenti-morra`. **Increment 1 FATTO**: matrice
  `clashOutcome` in `src/combat.ts` + 16 test (212 test verdi). **DA FARE**:
  innesto in `resolve.ts` (via fase 5 posizionale), bot che scelgono intenti,
  simulazioni di bilanciamento (`npm run sim`), UI dei 3 tasti + tabella
  telegrafata, deploy, playtest per tarare i danni.

### Da fare / aperti
- Supabase mai collegato (notifiche/matchmaking/progressione persistente):
  serve che Lele crei il progetto e dia le chiavi (`.env`).
- Cron risoluzione da rimettere quando si accende F3.


## Aggiornamento 29/07/2026 — combattimento a intenti IN PRODUZIONE (epica chiusa)

- Sessione notturna: increment 2-5 dell'epica "morra a 3 intenti" fatti e
  chiusi (motore, bot, bilanciamento, UI), branch `combat-intenti-morra`
  mergiato in `master` e **deployato su https://last-pact.vercel.app**
  (verificato 200). 202 test verdi, typecheck verde in root e `web/`.
- **La UI ora ha 3 tasti Affondo/Guardia/Finta** + tabellina delle
  conseguenze prima di confermare la mossa (stile Into the Breach), quando
  la destinazione scelta porta a uno scontro. Le vecchie azioni "imboscata"
  e "fortifica" sono sparite: sono diventate scelte d'intento (Affondo da
  fermo = ex imboscata, Guardia = ex fortifica).
- **Bilanciamento**: la prima misura bot-vs-bot ha mostrato aggressione
  QUASI MORTA (hunter ~2-4% win, contro shadow/ambusher fino al 30-48%) —
  causa non la matrice ma un buco nell'AI (i bot che si muovono verso una
  preda non dichiaravano un intento e arrivavano "esposto" per
  disattenzione). Corretto con un default vicino all'equilibrio di Nash
  della matrice (40/40/20 Affondo/Guardia/Finta) invece di una regola
  fissa. Risultato finale: forbice ~8-30% (long) / ~12-27% (short), pareggi
  sotto il 4%. Non è la forbice storica di ~5 punti del vecchio motore
  posizionale (paragone poco significativo, sistemi diversi), ma nessuna
  strategia è più rotta. Report completo:
  `~/progetti/br-turni/reports/2026-07-29.md`.
- **Prossimo passo reale**: playtest UMANO di Lele sul nuovo combattimento
  — i numeri bot-vs-bot dicono "non è rotto", non "si capisce e diverte".
  Se la forbice si sente ancora sbilanciata dal vivo, i pesi di
  `chooseIntento` in `src/bots.ts` sono il punto da ritoccare per primo.
- Resta aperto (invariato): Supabase mai collegato, cron di risoluzione
  spento (F3).

### Chiarezza esiti — LIVE 29/07 (sessione diurna dopo il playtest)
Verdetto di Lele sul combattimento nuovo: "va messo a posto, troppi movimenti
inutili, di difficile comprensione; mi sposto su un nemico e non succede nulla;
mi sposto e muoio senza capire". Il motore va bene, mancava il FEEDBACK.
Fatto e deployato (last-pact.vercel.app):
- **C1** causa di morte in chiaro su EndScreen (`describeDeath`): scontro con
  intenti ("ti ha colpito con Affondo mentre eri Esposto"), trappola, fuori dal
  cerchio, AFK.
- **C2** card "Questo round" auto-mostrata dopo il replay (non più nel cassetto).
- **C3** riga "il nemico si è spostato: nessuno scontro" quando volevi ingaggiare.
File: `web/lib/eventText.ts`, `components/EndScreen.tsx`, `components/GameBoard.tsx`.
Epica CHIAREZZA nel backlog (C1-C3 spuntati). **Se dopo questo resta opaco**, il
nodo è il modello simultaneo+nebbia → decisione [LELE] (mostrare più info /
telegrafare posizioni nemiche).

### Corpo / juice — LIVE 29/07
Lele: "sensazione di incompiuto, sembra non finito; renderlo più entusiasmante;
schermate di passaggio stile tendina/saracinesca; animazioni di base per dare
corpo". Fatto: `components/SceneTransition.tsx` — transizione a **saracinesca**
(due pannelli con listelli, colore per evento: round/morte/vittoria/apertura)
su risolvi/morte/vittoria/nuova partita; entrata dal basso della card recap.
Prossima area di polish se serve: micro-animazioni su HUD, token, tasti;
suoni; schermata di vittoria più ricca.

### Presentazione + pulizia grafica — LIVE 29/07 (delegata a Sonnet)
Lele: "voglio una presentazione, più impegno grafico; i personaggi si
accavallano, sembra un guazzabuglio non un gioco". Direzione combattimento
confermata: **poker** (tengo la cieca simultanea, rinforzerò la "lettura" —
prossimo giro, NON fatto qui). Piano deciso da Opus, implementato da un agente
**Sonnet** in background (delega esplicita di Lele "lo facciamo fare a sonnet").
Verificato da Opus: /, /play, /profile → 200; branch master, nessun push;
nessun testo creativo inventato nella schermata titolo.
- **Fix accavallamento personaggi** (causa vera): sprite troppo grandi
  (1.4-1.5×HEX) ancorati ~44px sopra il centro cella + zero scostamento per chi
  condivide l'esagono + ordine di disegno casuale. In `MapView.tsx` (mappa viva)
  i token nemici si disegnavano a coordinate grezze SENZA `clusterOffsets` (la
  usava solo il replay). Ora: impronta 1.15×HEX, piedi ancorati alla cella,
  nemici+umano in una lista sola ordinata per (r,q), ventaglio per stesso
  esagono, ombra a terra, bersaglio rosso più sottile e dietro lo sprite. Stesso
  bug (più grave: offset zero) risolto in `ArenaStage.tsx`. Verificato solo PER
  COSTRUZIONE — niente browser headless, il test vero è il telefono di Lele.
- **Schermata di titolo** (prima entravi dritto in partita): nuovo
  `app/play/page.tsx` = partita; `app/page.tsx` = `TitleScreen.tsx` (sfondo
  board.webp scurito, vignette, pulviscolo, saracinesca "open", titolo
  **LAST PACT** senza tagline, personaggio-eroe con ombra e idle-bob, bottoni
  Gioca→/play · Personaggio→/profile · Come si gioca=pannello col testo tutorial
  esistente). Navigazione ripuntata (NavBar, redirect post-login → /play).
- **Coerenza**: pannello recap ora usa `PANEL` condiviso; ombre a terra ovunque.
- Stato: typecheck root+web verde, 202/202 test, build pulita, 4 commit locali.
  Report `reports/2026-07-29.md`, sezione in cima a `BACKLOG.md`.
- **Aside segnalato da Sonnet** (non toccato, fuori scopo): `MovePreview.tsx`,
  `CluesLayer.tsx`, `HexMap.tsx` sono codice morto (zero import). Nota: gli
  indizi nebbia (tracce/rumore/fumo) restano solo TESTO nel cassetto "Cosa so" —
  il layer visivo sulla mappa (`CluesLayer`) non è agganciato da nessuna parte.
- **Prossimo giro deciso**: combattimento POKER — triangolo Affondo/Guardia/Finta
  visivo, "lettura" della postura nemica da stato visibile (non la mossa esatta),
  scontro come momento inquadrato. Poi: meno vuoto (Diversivo che fa davvero
  qualcosa, "scia" verso il nemico più vicino) e corpo/audio.

### Combattimento POKER — LIVE 29/07 (delegato a Sonnet, verificato da Opus)
Lele: "se hai il piano pronto per il poker, fallo fare a Sonnet". Solo UI, `src/`
INTATTO (regola d'oro nel brief: mai toccare motore/matrice/pesi bot). 3 componenti
nuovi in `web/`:
- **Triangolo RPS visivo** (`IntentoTriangle.tsx`) al posto della tabella di testo:
  ciclo Affondo→Finta→Guardia→Affondo con frecce "batte", icone esistenti, si
  illumina sull'intento scelto → insegna la regola a colpo d'occhio. Numeri esito
  compattati in una riga di chip (`ClashOdds.tsx`).
- **Lettura del nemico** (`enemyRead.ts`): rispecchia ONESTAMENTE le soglie vere
  di `bots.ts::chooseIntento` — il bot sceglie in base ai SUOI HP vs i tuoi (già
  entrambi visibili): enemyHp>tuoi = aggressivo (50% Affondo), enemyHp<tuoi =
  difensivo (55% Guardia), pari = imprevedibile (40/40/20). Badge sul token
  nemico (MapView) + riga nel dock. Sempre etichettato "lettura/sospetto, non
  certezza": resta il 20% Finta + bluff. Nessun dato non-visibile usato (niente
  inventario nemico). → è poker onesto, non decorazione, e non tocca il
  bilanciamento.
- **Momento dello scontro** (`ClashReveal.tsx`): nel replay, quando lo scontro ti
  coinvolge, card che rivela i due intenti + mini-triangolo con l'arco giocato
  acceso + esito a parole. `useRoundReplay.ts` espone `humanClash`.
Verificato da Opus: 202/202 test verdi (motore intatto), typecheck root+web ok,
/, /play → 200, e il bundle LIVE contiene davvero il codice nuovo (grep su chunk
servito). Commit `f6d97d8` su master, nessun push. NB: due notifiche in conflitto
(prima "failed" per limite sessione, poi "completed") — l'agente aveva già
committato e poi ha ripreso; deploy reale confermato a mano.
- **Limiti onesti**: verificato per costruzione/bundle, NON con browser reale (mai
  disponibile in queste sessioni). Test vero = telefono di Lele. Rischio da
  controllare dal vivo: il dock dello scontro ora ha più roba (lettura + 3 tasti +
  triangolo + chip); Sonnet ha messo `overflow-y:auto` di sicurezza su schermi
  piccoli, ma va guardato che non sia affollato.
- **Dopo il playtest poker** (idee decise, non fatte): rendere il Diversivo un vero
  depistaggio, una "scia" caldo/freddo verso lo scontro più vicino (meno turni
  vuoti), corpo/audio.

**Nota sessione**: il 29/07 sera si è toccato il limite d'uso del credito (reset
~23:40 Europe/Rome) — motivo dell'errore intermedio dell'agente.

### Anelli "anima": POTENZIAMENTI + FANTASMA — LIVE 29/07 (Sonnet, chiuso da Opus)
Lele: "renderlo pieno e gustoso, tenere accesa la voglia di giocare; iniziare a
far funzionare il sistema fantasma e i potenziamenti = la vera anima". Diagnosi
chiave (Opus, prima di delegare): **le meccaniche esistono già nel motore e sono
testate**, ma erano SPENTE nella UI web — potenziamenti su un Profilo di sola
lettura agganciato a un Supabase inesistente; fantasma mai passato a
`resolveRound` (3° arg). Mancava il collegamento al gioco, non le meccaniche.
Confine forzato dalle regole di fase (F3/Supabase non prima del gate F2, e serve
l'azione di Lele per crearlo): fatto tutto in **locale/localStorage**, come già
`reward.ts`. Delegato a Sonnet; src/ INTATTO (202 test), niente Supabase/.env/
testo creativo. Due anelli committati:
- **Anello A — potenziamenti** (commit `bfebcfc`): store locale
  `web/lib/profileStore.ts` (punti-discesa + 5 stat allocati). Fine partita →
  punti in base al piazzamento (modello `DESCENT_POINTS` del motore). **Profilo
  ora allocabile** (spendi budget su HP/Forza/Velocità/Intelligenza/Resistenza,
  curva `costToRaiseStat`, staccato da Supabase → Client Component locale). Le
  stat entrano in partita (mutazione client-side del Player umano dopo
  `createInitialState`, il motore le legge via `stats.ts`; movimento raggiungibile
  usa `effectiveMaxMove`). Ciclo gioca→cresci→senti-la-crescita chiuso.
- **Anello B — fantasma/Legati** (commit `efe9377`): morte disaccoppiata dalla
  fine partita — se muori ma restano ≥2 vivi entri in **modalità Legato**
  (`web/components/FantasmaPanel.tsx`, "Sei un Legato"): ogni round **doni** un
  oggetto della dote a un vivo (SpettroAction come 3° arg di `resolveRound`,
  i cap li applica il motore). Fine vera solo a ≤1 vivo; **raccolto** via
  `computePayouts` se il tuo protetto si piazza bene, convertito in ricompensa
  locale, mostrato su EndScreen (`SpettroRaccolto`).
Verificato da OPUS (Sonnet è morto sull'ultimo housekeeping per **limite di
SPESA MENSILE** — muro di fatturazione, non la sessione — ma aveva già committato
entrambi gli anelli): `npm test` 202/202, typecheck root+web verdi, build ok,
deploy prod fatto **da Opus a mano**, `/ /play /profile` → 200, e la stringa
"Sei un Legato" è nel bundle LIVE servito da /play. Commit su master, nessun push.
- **Da tarare (🧪, dopo playtest)**: pesi punti-discesa/budget/costo stat, valore
  del raccolto spettri, equilibrio delle 5 stat in partita reale.
- **Limiti onesti**: locale = progressione e legami vivono su QUESTO telefono,
  si azzerano cambiando dispositivo; il fantasma aiuta un BOT (solo-vs-bot), non
  un umano. La versione VERA (persistente + multiplayer asincrono) richiede
  **Supabase collegato = azione di Lele** (creare progetto + chiavi), prossimo
  gate. Verificato per costruzione/bundle, non con browser reale: test = telefono.
- **Muro spesa mensile 29/07**: rilanciare agenti Sonnet resta bloccato finché
  Lele non alza il limite (claude.ai/settings/usage). I comandi shell (test/
  build/deploy) di Opus funzionano ancora.

### Chiarezza esiti C1-C4 — CHIUSA e LIVE 31/07 (sessione notturna)
Epica in cima al backlog dal 29/07 (verdetto playtest: "muoio senza capire
cosa"). C1-C3 (causa di morte, recap del round, "il nemico si è spostato")
erano già fatti il 29/07. C4 ("anti muoio dal nulla": avviso col danno certo
prima di confermare la mossa, spiegazione per trappola/imboscata dal buio)
risultava non spuntato in quella sezione ma era già stato implementato il
30/07 sotto lo stesso nome dentro un'altra epica (ACCATTIVANTE GIRO 3) — la
sessione di stanotte l'ha verificato leggendo il codice (non rifatto) e
chiuso il backlog. Nessuna modifica a `src/` o al bilanciamento.
- **Deploy prod fatto stanotte**: porta in produzione anche tutto il lavoro
  locale accumulato dal 30/07 e mai deployato (Duello in primo piano — primo
  piano dello scontro con scelta d'attacco; Crescita per profondità —
  contrappeso bot + trama a strati + colonna discesa; ordine sul Profilo).
  `curl -sI https://last-pact.vercel.app`, `/play`, `/profile` → 200.
- Test 202/202 verdi, typecheck root+web verdi, `next build` pulito.
- Dettagli in `reports/2026-07-31.md`.

### 01/08 — backlog svuotato, deploy del lavoro 30-31/07 fermo in locale
Sessione notturna: l'epica "CHIAREZZA DEGLI ESITI" era già chiusa e
deployata da prima. Controllato l'intero `BACKLOG.md` dall'alto: **ogni
sezione risultava chiusa**, tranne task `[LELE]` (nomi/ambientazione,
restyling arte, statistiche per personaggio) o esplicitamente rimandati
(tuning non urgente, asset non pronti) — nessun task eseguibile dalla
macchina rimasto. Trovate però sei epiche di fine luglio (duello in primo
piano, crescita per profondità, abbellimenti grafici, obiettivi di
partita, postura di riserva/esagono conteso, impostazioni/musica/haptics)
già verdi (test/typecheck) ma **mai deployate**, ferme in locale su
`master`. Deploy fatto stanotte (`vercel build --prod` +
`vercel deploy --prebuilt --prod`), verificato 200 su `/`, `/play`,
`/profile`. 237/237 test verdi, typecheck root+web verdi. Nessun `git
push`. Dettagli in `reports/2026-08-01.md`.
**Prossimo passo reale**: serve un playtest di Lele sul pacchetto ora live
per tarare i valori 🧪 lasciati aperti nei report 30-31/07 (danni, timing
animazioni, monete obiettivi, haptics/musica) — il backlog non ha più
lavoro macchina in coda senza una nuova decisione/priorità di Lele.

### 02/08 — "Il round si racconta" (VS, movimento, faro, telecamera) — LIVE
Verdetto di Lele dopo il playtest del pacchetto 01/08: *"è ancora molto
confuso il combattimento e soprattutto tutto quello che succede... voglio un
vs con schermata di presentazione... voglio capire meglio dove ci siamo
spostati e dove si sono spostati gli altri... c'è troppo affollamento
confusionario"*, più *"gli esagoni devono risultare appena percettibili, non
si vede lo sfondo"*.

**La diagnosi che conta** (vale anche per il futuro): non erano tre difetti
separati. Il replay era una **sequenza di fotografie, non un racconto** —
ogni fase ridisegnava lo stato (`replay.ts::applyPhase`) e il giocatore
doveva confrontare due fotogrammi fissi per dedurre cosa fosse successo.
Senza un movimento nel punto che cambia, il cambiamento non viene percepito;
e l'affollamento pesa perché costringe a scandagliare tutta la scena per
trovare cosa è cambiato. I tre strumenti che tutti i giochi a risoluzione
simultanea usano (e che mancavano): il movimento **viaggia**; **una cosa per
volta con un faro sopra**; **ancore fisse prima del colpo** (la schermata VS
è esattamente la "battle forecast" di Fire Emblem — non decorazione, è la
cornice che rende leggibile l'animazione dopo).

Fatto e deployato lo stesso giorno:
- movimento animato da `from` a `to` (il motore emetteva già entrambi:
  era l'interfaccia a buttarli via — `src/` non toccato);
- **faro**: chi non c'entra con la fase corrente si attenua, il proprio
  token mai (è l'ancora dopo uno stacco);
- **telecamera che stacca e rientra**, solo su scontri/morti già visibili
  (mai una scorciatoia sulla nebbia di guerra) e mai sul semplice
  movimento — riusando il prop `cameraHex` aggiunto il 01/08 per il Legato;
- **schermata VS** (chi, contro chi, la vita di entrambi, il terreno) —
  il WIN/LOSE esisteva già dal 01/08 e non è stato rifatto;
- **indizi disegnati dove sono**: `src/clues.ts` calcolava già gli esagoni
  esatti di tracce/rumore/fumo e l'interfaccia li riduceva a tre frasi
  vaghe in un cassetto;
- **griglia esagonale quasi invisibile** (opacità 0,5→0,14, via il velo
  scuro): gli esagoni che *dicono* qualcosa restano com'erano.

Nuovo `web/lib/replayFocus.ts` (logica pura + 17 test): decide telecamera e
faro fuori da React, quindi verificabile da solo. 254 test verdi (237 del
motore invariati). Deploy prod verificato (200 su `/`, `/play`, `/profile`).
Dettagli in `reports/2026-08-02.md`.

**Due difetti trovati SOLO guardando gli screenshot veri**, non deducendoli:
nel VS nome e vita comparivano due volte (card + etichette sopra la testa) e
"TERRENO DIFENSIVO" era grigio su pietra grigia. Conferma la regola: i
verdetti di Lele sono visivi, si verificano guardando.

**Prossimo passo**: playtest di Lele. Tre valori 🧪 da tarare a occhio
(quanto sbiadisce il token attenuato, durata del VS, opacità della griglia),
una riga ciascuno. Se lo stacco di telecamera disorienta, il ripiego
"inquadratura ferma + faro" è già possibile senza buttare niente. Supabase
(F3) resta l'unico gate che richiede un'azione di Lele.

## Aggiornamento 19/08/2026 — sette notti ferme, in attesa di Lele
Dal deploy del 02/08 il backlog non ha più task eseguibili dalla macchina:
ogni checkbox aperta è `[LELE]`/idea da valutare, bilanciamento combattimento
congelato (richiede partite umane vere, non altre simulazioni bot-vs-bot), o
restyling grafico bloccato in assenza di asset/tool immagini. Sette sessioni
notturne di fila (02, 07, 13, 14, 15, 16, 19/08) hanno verificato lo stesso
stato e prodotto solo un commit di report, zero codice. Produzione ferma al
deploy del 02/08, invariata.
**Serve per sbloccare**: un playtest reale del pacchetto "Il round si
racconta" (per giudicare se lo stacco di telecamera + faro rende leggibile
il combattimento, e tarare i tre valori 🧪 lasciati aperti), oppure nuovi
asset grafici, oppure una decisione di design esplicita. Finché non arriva
uno di questi, le notti restano no-op — valutare se sospendere il cron fino
al prossimo input.

## Aggiornamento 24/08/2026 — ancora fermo, cron di fatto già in pausa
Dopo il consiglio del 19/08 il cron non ha più prodotto commit per 20-23/08
(solo marcatori vuoti senza report), segno che la sospensione è stata di
fatto applicata. Stanotte la sessione è ripartita su incarico esplicito:
stesso stato di sempre, backlog invariato dal 02/08, 254/254 test verdi,
nessun deploy (niente da chiudere). Nessuna novità reale da riportare finché
Lele non gioca il pacchetto deployato il 02/08 o non porta asset/decisioni
nuove.

## Aggiornamento 27/08/2026 — decima notte identica, stesso stallo
Sessione rilanciata su incarico esplicito ("epica CHIAREZZA DEGLI ESITI in
cima, deploy automatico a chiusura"): quell'epica risulta chiusa e deployata
dal 29/07, backlog invariato dal 02/08 (verificato via git log), 254/254
test verdi, nessun deploy fatto (niente da chiudere). Decima sessione
notturna di fila con lo stesso esito da inizio agosto. Lo stallo non è
tecnico: serve uno di (1) playtest reale di Lele sul pacchetto "Il round si
racconta" del 02/08, mai ancora giocato; (2) nuovi asset grafici; (3) una
decisione di design nuova. Finché non arriva, ha poco senso continuare a
far girare il cron notturno.
