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

## 2. Gestionale ASD Fight in Progress — "The Crew" (scheda: ~/cervello/progetti/fight-in-progress.md)
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
