# Task pendenti

Aggiornato: 2026-08-19. Priorità dichiarate: finire vvf → gestionale ASD → app tempo libero → basso + inglese.

## 0. ⚠️ Sicurezza — da fare appena possibile, precede il resto
- [x] **Revocare il token GitHub esposto in chiaro** — fatto 16/08: token revocato (verificato con chiamata API → 401), the-raven passato a SSH (chiave ed25519 nuova su ~/.ssh, aggiunta su GitHub)
- [x] Mettere **The Crew su GitHub** — fatto 16/08: repo privato `genolele22/the-crew-gym`, push via SSH di 141 commit (branch master), tracking impostato
- [ ] **vvf-gestionale — nessun backup remoto**: confermato 19/08, zero `git remote`, mai pushato una volta. **Bloccato su Lele**: crea un repo vuoto su GitHub (privato, `vvf-gestionale`, niente README/licenza) dal computer — poi io collego il remote via SSH e pusho logbook+master+scambio-salto in un minuto
- [x] **vvf-ferie-bot — 20 commit locali indietro** — FATTO 19/08: pushati su `origin/main` via SSH (il vecchio token HTTPS nel credential store era morto — probabilmente lo stesso revocato il 16/08 e mai ripulito — sostituito con la chiave SSH già usata per the-raven/the-crew, e il token morto è stato rimosso dal credential store)
- [ ] **The Crew — richiudere il libro soci** (`configurazione.libro_soci_modificabile` da `'si'` a `'no'`, verificato ancora `'si'` il 14/08): primo passo obbligato di `docs/PRIMA_DI_ANDARE_IN_PRODUZIONE.md`, prima del primo socio vero. Ferma da 5 giorni — **non è un flip diretto**, ha 3 code da chiudere prima (viste dal briefing del 19/08, dettagli nella sezione The Crew più sotto): Sara Lione senza riga nel libro soci, i 3 nomi multipli (serve una decisione di Lele, non indovinabile), le 19 persone senza verbale storico (decidere in blocco: refusi da unire o placeholder da lasciare)

## 1. vvf — da finire (bot + gestionale) — scheda: ~/cervello/progetti/vvf.md
- [x] Caricamento assenze da admin (missione/permesso/malattia/infortunio) — FATTO 17/08, chiudeva logbook #142
- [ ] Logbook: 2 voci di riparametrizzazione grosse rimaste (pagina admin parametri bot, credenziali fureria da admin) + una decina di voci foglio/anagrafica non affrontate
- [ ] ODT — ordine nomi a volte disallineato tra gestionale e file: serve un foglio concreto dove è successo per riprodurlo (17/08)
- [ ] ODT — oltre 5 malati spariscono dalla lista: soluzione proposta scartata da Lele il 17/08, da ripensare
- [ ] Anagrafica turno C (l'unico turno senza dati completi)
- [ ] Rimuovere le 15 funzioni morte del bot (lista pronta, serve ok)
- [ ] Guardare nel pannello TiDB Cloud la retention dei backup automatici serverless (livello extra oltre al nostro)
- [ ] Bonifica drift salti sui fogli di luglio pregressi (si sta sanando da sola col passare dei giorni)
- [ ] **Fondere vvf-ferie-bot + vvf-gestionale in un monorepo** — deciso 19/08: non urgente, farla con calma (non ora). Tecnicamente pulita: nessun branch secondario di nessuno dei due ha commit non già mergiati nel branch principale, quindi `git subtree` fonde le history senza perdite. Comporta spostare le cartelle locali (`~/vvf-ferie-bot` + `~/vvf-gestionale` → sottocartelle di `~/vvf/`) e aggiornare i riferimenti nel vault (CLAUDE.md li nomina come due path separati). Il deploy Fly.io non cambia, resta un `fly deploy` per sottocartella

## Gioco mobile «Last Pact» (scheda: ~/cervello/progetti/gioco-mobile.md — sezione era ferma a luglio, aggiornata 14/08)
LIVE su https://last-pact.vercel.app. Molto più avanti di quanto dicesse questa lista: combattimento a intenti (poker) in produzione, "il round si racconta" (VS/telecamera/faro) LIVE dal 02/08. Aperto:
- [ ] **Playtest di Lele** sul pacchetto 02/08 — sblocca la taratura di 3 valori 🧪 (quanto sbiadisce il token attenuato, durata del VS, opacità della griglia)
- [ ] Supabase mai collegato (serve azione di Lele: creare progetto + dare le chiavi) — blocca F3 (multiplayer/persistenza vera, oggi tutto locale su un telefono)
- [ ] Cron di risoluzione da rimettere quando si accende F3 (Hobby Vercel blocca cron sub-giornalieri)
- [ ] [LELE] Nomi (Diversivo, giocatori), tono testi, restyling arte, statistiche per personaggio — non bloccanti

### 🆕 19/08 sera — archivio ASD su Drive ricostruito, dossier pronto (nessuna azione presa)
Dossier: https://claude.ai/code/artifact/f2d4c7e1-e8e6-44c0-8e01-b1cc33193305
- [x] Confermato: i 281 verbali storici 2017-2025 erano già stati recuperati e incrociati il 14/08, non rifatto
- [ ] **⚠️ Da controllare fisicamente, priorità sulle altre**: certificato prevenzione incendi (ultimo rinnovo indicato feb 2023) e contratto di comodato della sede
- [ ] **CASELLARIO GIUDIZIALE.pdf ancora in `~/asd fight in progress/`**, mai spostato nel bucket protetto nonostante segnalato l'1/08
- [ ] Trovato l'indice master che Lele aveva scritto a marzo (`CATALOGO_ASD_Fight_in_Progress.xlsx` su Drive) — checklist in gran parte ancora aperta
- [ ] `BONIFICA_LIBRO_SOCI.xlsx` (76 decadenze, 67 CF mancanti) introvabile — da ricostruire da zero sui dati di oggi (0 decadenze mai registrate nel gestionale)
- [ ] Aspetta ok di Lele sul piano proposto nel dossier

## 2. Gestionale ASD Fight in Progress — "The Crew" (scheda: ~/cervello/progetti/fight-in-progress.md)

### 🆕 19/08 notte — archivio Drive ASD ricostruito (personale + istituzionale) + consuntivi storici caricati
Dossier aggiornato: https://claude.ai/code/artifact/f2d4c7e1-e8e6-44c0-8e01-b1cc33193305 — memoria: `project_asd_archivio_drive.md`.
- [x] **Consuntivi 2015-2022 caricati nel gestionale reale** come storico entrate/uscite (170 righe in `entrata_extra`/`spesa`, categorie esistenti riusate, nessuna nuova). Tornano al centesimo tranne due scostamenti nei *documenti originali stessi* (non miei): 2020 uscite 55 centesimi di refuso PDF, **2022 uscite: le 16 voci elencate non sommano al totale dichiarato dal documento, mancano quasi 3.926€ — da controllare a occhio**, non ho inventato nulla, ho inserito esattamente quello scritto
- [x] Accesso condiviso al Drive istituzionale `fightinprogress@gmail.com` esplorato: esiste già una cartella 2024-2026 ordinata (Amministrazione, Collaboratori, Statuto, Contratti, Verbali, Prime Note) — il materiale da smistare è quasi tutto storico 2019-2022, non nel presente
- [x] **CPI trovato**: `rinnovo cpi_febbraio 2023.docx`, riferito a SCIA 01/02/2018, campi data/firma vuoti nel testo estratto — **resta da verificare fisicamente/al Comando VVF Vercelli se è stato protocollato**, punto più urgente di tutto il dossier
- [ ] Trovato per caso: materiale personale di Lele (cartella "casa", "og crypto", richiesta mutuo) mescolato nell'archivio storico ASD — da separare prima di condividere quel Drive con altri
- [ ] Piano di assorbimento proposto nel dossier (sezione 11): cartella Drive unica, ramo corrente + ramo "Archivio storico 2019-2023" ripulito — **in attesa di ok di Lele**, nessun file spostato/cancellato finora
- [ ] Libro soci: confermare quale versione è quella buona (`LIBRO SOCI DEFINITIVO.xlsx`, sincronizzato locale+Drive, sembra la fonte attuale)

### 🆕 19/08 — il gestionale diventa un prodotto vendibile: **CREW**
Nome del prodotto deciso da Lele il 19/08: **Crew** (senza "The" — "The Crew" resta il marchio della palestra). Da applicare: `NEXT_PUBLIC_MARCHIO` è già parametrico, serve un logo neutro (oggi è ancora quello della palestra) e la registrazione del nome.
**Canale di vendita già esistente**: un commercialista che segue ASD lo propone ai propri clienti e non solo, come prodotto finito, nella stessa forma in cui lo usa Lele. Quindi niente rete commerciale da costruire e niente assistenza di primo livello a carico di Lele.
Tre documenti prodotti (artifact + PDF in `~/Downloads/gestionale-asd/`):
- **Presentazione prodotto** (per le associazioni, la usa il commercialista) — https://claude.ai/code/artifact/1033c088-37c9-4827-a594-f751743e76f6
- **Studio polisportiva** (sezioni con conti propri che confluiscono in un bilancio unico) — https://claude.ai/code/artifact/e206b6ad-f940-4117-b6ac-682626132627
- **Dossier commerciale** (canale, conti, responsabilità, continuità) — https://claude.ai/code/artifact/4827db9b-d7be-4b26-a08a-97c6442cc94c
- [ ] **Ambiente dimostrativo LIVE**: https://the-crew-demo.vercel.app — `demo@the-crew-demo.test` / `Demo-Trave-Anfora-77!Kite` (sola lettura vera, imposta dal DB su tutte le 49 tabelle; progetto Supabase `ddsjqadvumetomwjgtdg` separato dal reale)
- [ ] **Prossimo passo deciso**: mostrare la demo al commercialista e farsi correggere da lui la sezione conformità — la sua firma su quel contenuto è ciò che rende il prodotto credibile
- [ ] Prima di un cliente esterno (bloccanti): revisione di sicurezza indipendente, posta transazionale con dominio proprio (oggi parte da Gmail personale), monitoraggio errori, prova di ripristino cronometrata, documenti di continuità
- [ ] Manca ancora: onboarding autonomo, import assistito, manuale utente, esportazione completa dati

### ✅ 19/08 — le 8 note del logbook reale, chiuse ed eseguite. LIVE
Piano in `~/.claude/plans/async-sprouting-lake.md`, eseguito lo stesso giorno, deploy su thecrewgym.com verificato (200, RASD comparso in pagina pubblica). Riepilogo:
1. [x] **Bug** form nuovo corso: mostrava tutti i 192 soci come "responsabile" invece dei soli istruttori — allineato alla query già corretta del form di modifica
2. [x] Gruppo sportivo (Kaleido ecc.) aggiunto a entrambi i form corso, nuovo componente `SelezionaGruppoESala`. Scegliendo Kaleido la sala si preseleziona su "Sala corsi", resta modificabile
3. [x] Orario corso: ora si possono selezionare più giorni in un solo inserimento (checkbox), una riga per giorno, sovrapposizione controllata su ciascuno prima di scrivere qualunque riga
4. [x] Elenco corsi raggruppato per gruppo/istruttore, due tab + sottomenu ad ancore, ordine alfabetico
5. [x] **Il pezzo che valeva di più**: `form-con-esito.tsx` (~24 punti di tutto il gestionale) ora dice sempre se un salvataggio precedente è ancora valido — nasconde l'esito durante un nuovo invio, mostra "Modifiche non salvate" (giallo) se tocchi un campo dopo aver visto "Salvato"
6. [x] Erogazioni liberali: numero RASD ora sulla ricevuta (`NUMERO_RASD` spostato in `ente.ts`, unico punto di verità), indirizzo del donante reso obbligatorio prima di registrare l'incasso come già il CF
7. [x] Pre-iscrizioni: nota chiusa nel DB reale senza scrivere codice — il bollino "già socio" esisteva già dal 13/08

**⚠️ Il deploy automatico non era mai partito**: il progetto Vercel `the-crew` (reale) non era collegato a GitHub da quando esisteva (02/08) — zero webhook, zero deploy da nessun push, incluso tutto il lavoro precedente di oggi (tasti con ombra). Scoperto perché Lele ha guardato il sito e visto tutto invariato: il mio controllo HTTP 200 non bastava, torna uguale su una build vecchia. Fix: `vercel git connect` ha ricollegato GitHub, e ho deployato manualmente (`vercel --prod`) tutto il lavoro accumulato di oggi in un colpo — verificato online (RASD in pagina pubblica, deployment di 56s). Da qui in avanti i push dovrebbero auto-deployare come previsto — **da riverificare al prossimo push**, non darlo per scontato.

- [x] **19/08 — il cliccabile si vede**: ombra leggera sui tasti (si abbassa alla pressione), link sottolineati sempre e non solo al passaggio del mouse, 4 azioni travestite da testo diventate tasti veri (Prova invio, Conferma liquidazione, Approva rimborso, Esci). Richiesta di Lele: chi è poco pratico non preme una scritta che sembra testo normale. LIVE
- [x] **19/08 — pulizia**: 29 funzioni in file `"use server"` erano esportate pur essendo usate solo dal proprio wrapper `ConEsito`. In Next.js ogni export di un modulo "use server" è un endpoint richiamabile dal browser: erano 29 endpoint paralleli inutili, ora interni al modulo

LIVE su thecrewgym.com (Next.js + Supabase + Stripe + Vercel). **17/08**: erogazioni liberali (ricevuta con dicitura fiscale, blocco contanti/CF donante — nota logbook lasciata aperta di proposito, la controlla Lele), branding Kalèido esteso fuori dal gestionale (corsi/palinsesto pubblici, socio, istruttore), ~28 tasti Salva del gestionale ora mostrano se hanno funzionato, collaboratori possono registrare da soli un rimborso spese con foto scontrino. **16/08**: logbook del superadmin (13 note) triage e chiuso — consuntivo entrate risistemato (era a zero), verbali con storico, rateizzazione Kalèido, logo+colore Kalèido, bug date rate corretto, chiavi Stripe passate a live. Aperto:
- [ ] Libro soci ancora sbloccabile — vedi punto 0
- [x] STRIPE_WEBHOOK_SECRET impostato su Vercel — fatto 16/08 (chiavi live caricate: pk_live/sk_live/whsec)
- [x] **Test pagamento reale da 1€** — FATTO 18/08: trovato e corretto un bug vero (l'endpoint Stripe non era sottoscritto a `checkout.session.completed`, il gestionale non vedeva i pagamenti pur avendo preso i soldi), ora funziona da solo. Testato anche il nuovo tasto Rimborsa nel gestionale con un rimborso vero riuscito. Stripe pronto per il pubblico
- [ ] **Bot Telegram per le notifiche** — deciso 16/08 al posto di WhatsApp (scartato per burocrazia Meta + costo), non ancora costruito
- [ ] 4 casi anagrafici dubbi da un vecchio import
- [ ] Pulizia dati di collaudo dal DB reale (corso "TEST — Danza", account socio.prova), quando dai l'ok per l'uso vero (prevista inizio settembre)
- [ ] Import storico pagamenti — FATTO 15/08 (531 incassi + 97 iscrizioni), resta: diagnostica stato socio, guida utente in PDF — dettagli in memoria (`project_the_crew_audit_vvf`)
- [x] **21 bozze di verbale settimanale** — FATTO (verificato sul DB il 18/08: 0 bozze rimaste, 23 verbali confermati)
- [ ] Chiarire i 3 nomi multipli mai risolti prima di poterli mettere a libro soci: "Federico/Iris Bodo/Caprarulo", "Sole/nino di Rubba", "Maria sole Katia Massa Mastroeni"
- [x] Verbale-fiume improprio del 13/08: 116/135 persone ricollegate al loro vero verbale storico (14/08) — dettagli in memoria
- [ ] **19 persone non trovate in nessun verbale storico** (Bettini, Bogdan, Cannizzo, Della Pietra, di Bella, Genovesi Claudio [è il presidente, caso a parte], Giannone, Greppi Chiara, Lai Massimiliano, Lebchara, Maggiolo, Marinaro, Menna, Pera, Rampino, Sabbab, Zanello, Zanero, Zucconelli) — restano sul placeholder, controllare se sono refusi o casi mai verbalizzati nemmeno prima del 2025
- [x] **Rinnovi quota mancanti** — SUPERATO: ricostruiti il 14/08, verificati il 18/08 (179 eventi `rinnovo_quota`, non 2). Restano 9 soci senza, per tua scelta esplicita
- [x] **PIANO MIGLIORIE 18/08 — 4 lavori LIVE** (omaggio, tipologie attiva/disattiva, pre-iscrizione a campi obbligatori + aggiorna-scheda-1-clic, tabelle a schede su telefono) + fix sicurezza registrazione collaboratore (verifica token, migrazione 0084) + fix pre-iscrizione (refuso CF non svuota il modulo). Collaudati in browser nei 3 ruoli (nuovo iscritto/vecchio socio/tesserato/istruttore), deployati su thecrewgym.com. Piano in `the-crew/docs/PIANO_MIGLIORIE_20260818.md`
- [x] **FALLA DI SICUREZZA trovata e chiusa 18/08**: tutte le pagine `/socio/*` mostravano l'anagrafica intera (certificati medici compresi) a chi accedeva come superadmin — colpa mia, appena collegata "la mia area socio" al menu del gestionale. Corretto filtrando esplicitamente su `persone_gestite()`, verificato con l'identità reale di Lele: prima 189 righe, dopo 1
- [x] **Due pagamenti test da 1€ registrati a mano** (ricevute 412/413/2026) perché fatti prima della correzione del webhook — hanno ricevuta ma non l'id Stripe, quindi il tasto Rimborsa non li vede: se Lele li vuole indietro, va fatto dalla dashboard Stripe
- [ ] **Da settembre — 2 code aperte dal collaudo 18/08**: (a) Sara Lione è socia ma senza riga nel libro soci → vede "nessuna posizione, scrivi alla segreteria" (+ senza email + sospetto doppione 06/08); (b) 2 PDF finti orfani nel bucket `certificati-medici` (cartella 8c41eb18-...) da cancellare dalla dashboard Supabase Storage (service key non scaricabile da qui)
- [ ] **Bug diagnosticato (non ancora corretto)**: "Oggi in palestra" dell'istruttore nasconde gli allievi se la tipologia del corso è non-attiva, anche con iscrizione valida (attesi-oggi.ts)

## 3. App tempo libero
- [ ] Definire spec: turni vvf + impegni + obiettivi → proposta giornaliera (scheda: ~/cervello/progetti/tempo-libero.md)

## 4. Basso + inglese
- [ ] Basso: decidere routine minima settimanale e materiale di partenza
- [ ] Inglese: decidere metodo e routine minima settimanale

## In pausa
- The Raven: mergiare tema-carta-globale (pushato 06/07); ruotare le **3** chiavi ancora esposte (Supabase service_role, Mistral, Gemini — il GitHub PAT è stato revocato il 16/08). Aperto dal 06/07: **44 giorni**, la pausa del progetto non mette in pausa il rischio delle chiavi
- [ ] Modello di business per The Raven — aperto dal 05/05/2026 (3,5 mesi)
