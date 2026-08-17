# Task pendenti

Aggiornato: 2026-08-16. Priorità dichiarate: finire vvf → gestionale ASD → app tempo libero → basso + inglese.

## 0. ⚠️ Sicurezza — da fare appena possibile, precede il resto
- [x] **Revocare il token GitHub esposto in chiaro** — fatto 16/08: token revocato (verificato con chiamata API → 401), the-raven passato a SSH (chiave ed25519 nuova su ~/.ssh, aggiunta su GitHub)
- [x] Mettere **The Crew su GitHub** — fatto 16/08: repo privato `genolele22/the-crew-gym`, push via SSH di 141 commit (branch master), tracking impostato
- [ ] **The Crew — richiudere il libro soci** (`configurazione.libro_soci_modificabile` da `'si'` a `'no'`, verificato ancora `'si'` il 14/08): primo passo obbligato di `docs/PRIMA_DI_ANDARE_IN_PRODUZIONE.md`, prima del primo socio vero

## 1. vvf — da finire (bot + gestionale) — scheda: ~/cervello/progetti/vvf.md
- [x] Caricamento assenze da admin (missione/permesso/malattia/infortunio) — FATTO 17/08, chiudeva logbook #142
- [ ] Logbook: 2 voci di riparametrizzazione grosse rimaste (pagina admin parametri bot, credenziali fureria da admin) + una decina di voci foglio/anagrafica non affrontate
- [ ] ODT — ordine nomi a volte disallineato tra gestionale e file: serve un foglio concreto dove è successo per riprodurlo (17/08)
- [ ] ODT — oltre 5 malati spariscono dalla lista: soluzione proposta scartata da Lele il 17/08, da ripensare
- [ ] Push su GitHub dei commit (per ora solo locali)
- [ ] Anagrafica turno C (l'unico turno senza dati completi)
- [ ] Diagnosi Volpara/Zollo/Pedemonte sempre nei Disponibili (turno A) — SOSPESA su richiesta, analisi pronta, tre fix proposti, in attesa di ok
- [ ] Rimuovere le 15 funzioni morte del bot (lista pronta, serve ok)
- [ ] Guardare nel pannello TiDB Cloud la retention dei backup automatici serverless (livello extra oltre al nostro)
- [ ] Bonifica drift salti sui fogli di luglio pregressi (si sta sanando da sola col passare dei giorni)

## Gioco mobile «Last Pact» (scheda: ~/cervello/progetti/gioco-mobile.md — sezione era ferma a luglio, aggiornata 14/08)
LIVE su https://last-pact.vercel.app. Molto più avanti di quanto dicesse questa lista: combattimento a intenti (poker) in produzione, "il round si racconta" (VS/telecamera/faro) LIVE dal 02/08. Aperto:
- [ ] **Playtest di Lele** sul pacchetto 02/08 — sblocca la taratura di 3 valori 🧪 (quanto sbiadisce il token attenuato, durata del VS, opacità della griglia)
- [ ] Supabase mai collegato (serve azione di Lele: creare progetto + dare le chiavi) — blocca F3 (multiplayer/persistenza vera, oggi tutto locale su un telefono)
- [ ] Cron di risoluzione da rimettere quando si accende F3 (Hobby Vercel blocca cron sub-giornalieri)
- [ ] [LELE] Nomi (Diversivo, giocatori), tono testi, restyling arte, statistiche per personaggio — non bloccanti

## 2. Gestionale ASD Fight in Progress — "The Crew" (scheda: ~/cervello/progetti/fight-in-progress.md)
LIVE su thecrewgym.com (Next.js + Supabase + Stripe + Vercel). **16/08**: logbook del superadmin (13 note) triage e chiuso — consuntivo entrate risistemato (era a zero), verbali con storico, rateizzazione Kalèido, logo+colore Kalèido, bug date rate corretto, chiavi Stripe passate a live. Aperto:
- [ ] Libro soci ancora sbloccabile — vedi punto 0
- [x] STRIPE_WEBHOOK_SECRET impostato su Vercel — fatto 16/08 (chiavi live caricate: pk_live/sk_live/whsec)
- [ ] **Test pagamento reale da 1€** per aprire Stripe al pubblico (chiavi live pronte, manca solo il test di Lele)
- [ ] **Bot Telegram per le notifiche** — deciso 16/08 al posto di WhatsApp (scartato per burocrazia Meta + costo), non ancora costruito
- [ ] 4 casi anagrafici dubbi da un vecchio import
- [ ] Pulizia dati di collaudo dal DB reale (corso "TEST — Danza", account socio.prova), quando dai l'ok per l'uso vero (prevista inizio settembre)
- [ ] Import storico pagamenti — FATTO 15/08 (531 incassi + 97 iscrizioni), resta: diagnostica stato socio, guida utente in PDF — dettagli in memoria (`project_the_crew_audit_vvf`)
- [ ] **Confermare le 21 bozze di verbale settimanale** generate il 14/08 per i 51 nuovi soci reali mai verbalizzati (maggio 2025 → aprile 2026) — una alla volta da `/gestionale/verbali`, mai automatico
- [ ] Chiarire i 3 nomi multipli mai risolti prima di poterli mettere a libro soci: "Federico/Iris Bodo/Caprarulo", "Sole/nino di Rubba", "Maria sole Katia Massa Mastroeni"
- [x] Verbale-fiume improprio del 13/08: 116/135 persone ricollegate al loro vero verbale storico (14/08) — dettagli in memoria
- [ ] **19 persone non trovate in nessun verbale storico** (Bettini, Bogdan, Cannizzo, Della Pietra, di Bella, Genovesi Claudio [è il presidente, caso a parte], Giannone, Greppi Chiara, Lai Massimiliano, Lebchara, Maggiolo, Marinaro, Menna, Pera, Rampino, Sabbab, Zanello, Zanero, Zucconelli) — restano sul placeholder, controllare se sono refusi o casi mai verbalizzati nemmeno prima del 2025
- [ ] **Problema strutturale scoperto**: quasi nessun socio ha mai avuto un evento `rinnovo_quota` (solo 2 in tutto il sistema) → scadenza quota non calcolabile per quasi tutti, il cruscotto mostra sempre "In regola" senza data. Non affrontato, da valutare come lavoro a parte

## 3. App tempo libero
- [ ] Definire spec: turni vvf + impegni + obiettivi → proposta giornaliera (scheda: ~/cervello/progetti/tempo-libero.md)

## 4. Basso + inglese
- [ ] Basso: decidere routine minima settimanale e materiale di partenza
- [ ] Inglese: decidere metodo e routine minima settimanale

## In pausa
- The Raven: mergiare tema-carta-globale (pushato 06/07); ruotare le 4 chiavi esposte (GitHub PAT, Supabase service_role, Mistral, Gemini)
- [ ] Modello di business per The Raven — aperto dal 05/05/2026
