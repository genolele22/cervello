# Progetto — ASD Fight in Progress

**Tipo:** Associazione Sportiva Dilettantistica
**Sport:** combattimento e functional training, danza (corsi Kalèido Project)
**Stato:** attiva ma gira poco

---

## Gestionale — "The Crew"

**Stato: LIVE** su https://thecrewgym.com (sito pubblico + area riservata).

**Stack**: Next.js 16 + Supabase (Postgres, RLS, Storage) + Stripe + Vercel. Deciso il 01/08/2026 — scartata l'idea iniziale di riusare la base PHP/Fly.io del gestionale vvf, niente di riusabile lì.
**Repo**: `/home/genolele22/progetti/the-crew`.

Copre: libro soci (append-only, a norma), rate/incassi/ricevute (numerazione progressiva), compensi collaboratori (percentuale o incassato-meno-detrazione-a-lezione), corsi/tipologie di ingresso, certificati medici, scadenze di legge istruttori, verbali, sito pubblico con corsi/staff/palinsesto.

**Collaboratori attivi**: Sara Lione, Giulia Rago, Aurora Denaro (istruttrici Kalèido — danza).

**14/08/2026 — sessione con Claude Code**: menu di ricerca per nome su 8 tendine socio/collaboratore (digiti le prime lettere, filtra); ricerca per nome anche nell'elenco Soci; barra di navigazione desktop rifatta a tendina per gruppo (era diventata più di metà schermo con 19 voci sempre aperte). Poi incrociato col gestionale vvf per trovare soluzioni da portare: **3 spedite e testate dal vivo** — copia delle email inviate in "Posta inviata" (IMAP APPEND), rifiuto di una domanda di adesione (mancava il tasto, lo stato esisteva già nello schema), backup notturno del DB via email (03:00 UTC, testato: 46 tabelle/3089 righe arrivate davvero). Backlog completo (import storico pagamenti, diagnostica stato socio, canale Telegram, guida PDF) in memoria, non ancora fatto.

**14/08/2026 — verbali soci 2026, trovato e corretto un problema serio**: un agente precedente aveva scritto nel libro soci un "verbale" già confermato che ammetteva 186 persone tutte insieme per 19 mesi di iscrizioni (01/01/2025→13/08/2026) — non un vero verbale del Direttivo. Recuperati da Drive i 281 verbali reali (2017-2025, pubblicati in un artifact cercabile): si fermano al 21/05/2025, 11 mesi di buco. Incrociati i pagamenti quota associativa reali → **51 persone davvero nuove mai verbalizzate**. Rimosso il placeholder improprio solo per queste 51 (le altre 135, che hanno un vero verbale storico, restano toccate solo dal verbale-fiume improprio, non da me) e generate **21 bozze settimanali vere** con le date reali di adesione — tutte ancora bozze, da confermare una alla volta da `/gestionale/verbali`. Dettagli completi in memoria (`project_the_crew`).

**15-16/08/2026 — sessione lunga, molti fix strutturali**:
- **Consensi socio resi obbligatori** (rapporto associativo + dati sanitari + comunicazione CSEN — prima solo il primo lo era) su tutti e tre i punti d'ingresso (pre-iscrizione pubblica, form interno, registrazione collaboratori), con nuova pagina `/informativa-privacy` collegata (art. 13 GDPR, riadatta il testo già scritto nei moduli cartacei di agosto)
- **Import storico pagamenti FATTO**: 531 incassi/ricevute + 97 iscrizioni dal vecchio gestionale (2025-2026), tipologie storiche marcate per non entrare nel motore compensi; 12 righe con nominativi multipli in un campo escluse, restano da chiarire
- **Regione Vercel corretta** (era negli USA, ora Francoforte come Supabase): tempi di risposta dimezzati
- **Bug vero trovato e corretto: le email non partivano mai** — busta SMTP vuota per un dettaglio della libreria di invio, ritentata invano ogni 5 minuti da mesi
- **Bug vero trovato e corretto: l'invito ad attivare l'accesso non partiva mai dopo il verbale** — 132 soci su 141 mai invitati; corretto e aggiunta rete di sicurezza in tre punti (verbale, domanda, aggiornamento anagrafica)
- **Causa vera del "tasto Salva confusionario" trovata**: Next.js in produzione cancella il testo di ogni errore e lo sostituisce con uno generico — corretto con un meccanismo riusabile, applicato ai primi 4-5 casi (altri da estendere)
- Quota associativa: tasto dedicato + metodo di pagamento a pulsanti (Contanti/Bancomat/Satispay/Online)
- Percorso "solo tesserato CSEN" in un passaggio solo invece di due
- Pulsante "Indietro" su ogni pagina, alcune conferme corrette per tornare al posto giusto
- **Logbook del superadmin**: tasto 📝 su ogni pagina per annotare "qui non va" al volo, con link alla pagina esatta
- Caricamento file (documenti, certificati, giustificativi): pulsante grande con fotocamera, non più il minuscolo input di sistema — ovunque, socio/istruttore/superadmin
- Pagina Accessi: ricerca invece di scorrere ~200 soci; email vera visibile anche per i due account superadmin (non collegati a una persona)
- **Emanuele Genovesi aggiunto in anagrafica e forzato a socio fondatore** (socio n. 210, come Claudio Genovesi, nessun verbale necessario), collegato all'account superadmin genolele22@gmail.com

**16/08/2026 — logbook del superadmin (13 note) triage e chiuso**: Opus ha pianificato a settori dopo aver letto il codice reale (non fidandosi del testo delle note), Sonnet ha eseguito in 6 lotti/aggiunte, tutto in produzione. Trovato e sistemato che il **consuntivo entrate era a zero** (40 tipologie senza categoria di bilancio — ora 40/40 collegate, ≈€15.045 tornati visibili); trovato che **il pagamento Stripe dalla pagina del socio era già pronto**, solo spento per chiavi mancanti; **WhatsApp scartato** (burocrazia Meta + costo per conversazione dal 01/10) **a favore di un bot Telegram gratuito**, ancora da costruire. Aggiunti: verbali modificabili con storico (mai l'elenco soci di un'ammissione), rateizzazione con anteprima attivata sulle 4 annuali Kalèido, logo+colore Kalèido (da una locandina reale, Play & Dance resta senza branding dedicato). **Bug vero trovato e corretto**: le rate di un piano rateale nascevano datate un giorno prima per il fuso orario italiano. **Chiavi Stripe passate a live** (caricate su Vercel), manca solo il test reale da 1€ che deve fare Lele. Dettagli completi in memoria (`project_the_crew`).

**18/08/2026 — piano migliorie eseguito + due falle di sicurezza reali trovate e chiuse + Stripe aperto per davvero**:
- **Piano di migliorie** scritto dopo ricognizione (audit_log, dati veri, schema) e 4 lavori delegati a Sonnet in parallelo, tutti verificati e LIVE: **omaggio** tra i metodi di pagamento (un abbonamento regalato non sporca più cassa/consuntivo/compensi), **attiva/disattiva tipologie** reso leggibile (badge + interruttore diretto — la nota di Lele era un falso allarme, il salvataggio funzionava già, mancava solo la conferma a schermo), **pre-iscrizione resa "porta unica"** — su correzione di Lele: non una pagina nuova, ma i campi del modulo pubblico (data nascita/CF/residenza) resi obbligatori, perché erano tutti facoltativi ed è per questo che 187 soci su 190 non avevano una data di nascita — più "Aggiorna la sua scheda" in un clic quando il CF coincide, **tabelle di rate/ricevute/libro soci leggibili sul telefono**.
- **FALLA DI SICUREZZA GRAVE trovata e chiusa in produzione**: appena collegato l'account superadmin di Lele alla propria area socio ("La mia area socio" nel menu, aggiunta nella stessa sessione), tutte e 6 le pagine `/socio/*` mostravano l'**intera anagrafica** — certificati medici (dato sanitario) e ricevute di tutti i 190 soci inclusi — perché si fidavano solo del permesso del database, e quel permesso lascia passare tutto al superadmin per necessità altrove nel gestionale. Corretto filtrando esplicitamente ogni pagina su `persone_gestite()`. Verificato con l'identità reale di Lele in una transazione annullata: prima 189 righe, dopo 1.
- **Seconda falla trovata per scrupolo** (non segnalata da nessuno, trovata rileggendo il codice): la registrazione di un nuovo collaboratore verificava l'invito solo per email, **ignorando il token del link** — chiunque conoscesse l'email di un invito in attesa poteva registrarsi come istruttore. Corretto: ora il token è obbligatorio e deve coincidere.
- **Test pagamento reale da 1€: FATTO, funziona da solo**. Il primo tentativo non scriveva nulla nel gestionale pur avendo preso i soldi: causa trovata nei log veri di Vercel (non ipotizzata) — l'endpoint Stripe non era sottoscritto all'evento `checkout.session.completed`, il solo che il codice sa leggere. Corretto da Lele sul pannello Stripe (Sviluppatori → quella destinazione → aggiunto l'evento). **Anche il nuovo tasto "Rimborsa" nel gestionale collaudato con un rimborso vero, riuscito.** Due dei tre pagamenti di prova (quelli fatti prima della correzione) sono stati registrati a mano nel gestionale — hanno ricevuta ma non l'id del pagamento Stripe, quindi il tasto Rimborsa non compare su quei due: se Lele li vuole indietro va fatto dalla dashboard Stripe.
- **Bot Telegram per le notifiche** — deciso il 16/08 al posto di WhatsApp, non ancora costruito
- 4 casi anagrafici dubbi da un vecchio import (nomi doppi/genitore-figlio poco chiari) — ancora aperti
- 12 righe di pagamenti storici con nominativi multipli in un campo, escluse dall'import — da chiarire
- Estendere il fix "Salva che dice se ha salvato" agli altri punti dell'app (il meccanismo esiste già, va solo applicato)
- Decidere se mandare in blocco l'invito ad attivare l'accesso ai ~130 soci storici mai invitati, o gestirli caso per caso
- Sara Lione risulta socia ma senza riga nel libro soci: la sua area socio dice "nessuna posizione trovata" — da sistemare, e ha anche un sospetto doppione già segnalato il 06/08
- Bug diagnosticato non ancora corretto: nella pagina "Oggi in palestra" di un istruttore, un allievo sparisce se la tipologia del suo corso è momentaneamente non attiva, anche con iscrizione valida

**Pulizia da fare a inizio settembre** (quando Lele dà l'ok per l'uso vero, non solo collaudo): corso "TEST — Danza" e account `socio.prova@thecrew.training`, più il nuovo corso/tipologia "TEST — Pagamento 1€" (già disattivati il 18/08, non cancellabili: usati da incassi veri) — tutti dati di collaudo ancora presenti, da tirar via dal DB reale.

Dettagli tecnici e cronologia sessioni: memoria auto-gestita del secondo cervello (progetto "the-crew" nell'indice memoria), non qui — questa scheda resta la vista d'insieme.

---

## Note

L'ASD non è la priorità creativa di Lele — è una responsabilità da gestire nel modo più efficiente possibile.
