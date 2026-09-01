# Progetto — ASD Fight in Progress

**Tipo:** Associazione Sportiva Dilettantistica
**Sport:** combattimento e functional training, danza (corsi Kalèido Project)
**Stato:** attiva ma gira poco

## Stato

Stato: in corso — LIVE. Sistema "a scomparsa" su tutte le schede principali,
  categoria spesa modificabile in riga/blocco, pagina nuova
  /gestionale/statistiche. Pagamento allo sportello verificato dal vivo oggi.
  Pagamento online (Stripe) NON riverificato dopo i deploy di oggi — ultimo
  successo reale nel DB è del 18/08.
Deciso: 01/09/2026 — il verbale delle adesioni ammette solo chi ha già pagato
  la quota associativa, non basta più la domanda (bug reale: un agente ha
  confermato un verbale vero con 10 persone, 9 senza pagamento — le 10
  ammissioni restano così, corretto il flusso per il futuro). Kalèido tiene
  per regolamento i propri colori/spazi, mai normalizzati sulla palette THE
  CREW — vincolo ora scritto in docs/MARCHIO.md.
Prossimo passo: (Lele) verificare il pagamento online dal vivo alla prima
  occasione reale. (Macchina) nessuno aperto da questo giro.

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
- ~~Estendere il fix "Salva che dice se ha salvato" agli altri punti dell'app~~ — **FATTO 22/08**: popup su 33 pagine + 12 moduli che cambiano pagina
- Decidere se mandare in blocco l'invito ad attivare l'accesso ai ~130 soci storici mai invitati, o gestirli caso per caso
- Sara Lione risulta socia ma senza riga nel libro soci: la sua area socio dice "nessuna posizione trovata" — da sistemare, e ha anche un sospetto doppione già segnalato il 06/08
- Bug diagnosticato non ancora corretto: nella pagina "Oggi in palestra" di un istruttore, un allievo sparisce se la tipologia del suo corso è momentaneamente non attiva, anche con iscrizione valida

**20/08/2026 — rateizzazione nell'acquisto online (nuova) + 2 bug distinti sul ruolo istruttore + lavoro 27 chiuso + logbook Lotto A/C**: **il socio può ora pagare a rate su `/socio/corsi`**, ma il piano non parte da solo — Lele ha l'ultima parola, approva ogni richiesta dalla scheda socio prima che scattino gli addebiti automatici delle rate successive. Il numero di rate **lo decide Lele per tipologia** (non il socio: un ripensamento fatto lo stesso giorno, dopo la prima versione con scelta libera) — va impostato in Gestionale → Tipologie → "In quante rate": oggi nessuna tipologia ce l'ha, quindi tutte vendono ancora solo a pagamento unico online finché non lo scrive lui su quelle Kalèido che vuole vendere a rate. Nello stesso giro, **trovato e corretto un bug probabilmente vecchio**: nessun pacchetto Kalèido era mai acquistabile online (il controllo richiedeva un corso collegato, che Kalèido non ha mai per progetto).
**Due bug distinti sul ruolo istruttore**, stesso sintomo (un socio reso collaboratore restava "socio" invece di diventare "istruttore"), cause opposte: Giulia La Rocca (il collaboratore è arrivato dopo l'accesso già esistente) e William Aliati, poche ore dopo (l'accesso è stato attivato dopo essere già diventato collaboratore). Entrambi corretti a mano e con fix strutturali, verificato che nessun altro fosse nella stessa situazione.
**Lavoro 27 chiuso**: variazione di un abbonamento Kalèido a metà anno — scelta l'opzione "chiudi il vecchio contratto, riaprine uno per il residuo", con la differenza di prezzo prorata sui mesi rimasti (Kalèido è anno accademico ottobre-giugno, non l'anno solare).
**Logbook, altre 9 note chiuse** (Lotto A: 5 bug piccoli — un campo "Rateizzabile" doppio e morto, pulsante Disattiva alleggerito, messaggio sbagliato su "Oggi in palestra", cancellazione spese aggiunta; Lotto C: 4 feature — sezione "Mai invitati" in Accessi per i ~130 soci storici mai invitati mai attivati [pulsante pronto, non ancora premuto], quota associativa a importo fisso, scelte rapide di pagamento sulla scheda socio, filtro pre-iscrizioni lavorate/da lavorare). **Lotto B sospeso su richiesta di Lele** (bug "Indietro serve doppio click": confermato Chrome, manca il dispositivo per riprenderlo). RID/SEPA per la rateizzazione online resta fuori, richiede un'attivazione sul pannello Stripe — proposta solo se richiesta. Consegnato anche un grafico a cascata (artifact + PDF) del percorso pre-iscrizione→socio/tesserato→primo accesso, per Claudio.

**Pulizia da fare a inizio settembre** (quando Lele dà l'ok per l'uso vero, non solo collaudo): corso "TEST — Danza" e account `socio.prova@thecrew.training`, più il nuovo corso/tipologia "TEST — Pagamento 1€" (già disattivati il 18/08, non cancellabili: usati da incassi veri) — tutti dati di collaudo ancora presenti, da tirar via dal DB reale.

Dettagli tecnici e cronologia sessioni: memoria auto-gestita del secondo cervello (progetto "the-crew" nell'indice memoria), non qui — questa scheda resta la vista d'insieme.

**22/08/2026 — giornata piena, tutto online.** Import dello storico (102 persone: certificati medici, quote 2026, abbonamenti), poi giro di logbook con **zero note aperte a fine giornata**.

**Il gestionale adesso ti dice le cose che sapeva e non diceva.** La pagina "Da fare" apre su **127 quote associative da rinnovare**, più i certificati medici in scadenza nei prossimi 30 giorni e gli abbonamenti che stanno per finire. Prima quei numeri erano nel database e non li vedeva nessuno.

**L'app sul telefono adesso è un'app.** Mancava del tutto il file che dice a Chrome come comportarsi: per questo si apriva con la schermata bianca. Ora ha icona, colori del marchio e si apre direttamente dove serve a seconda di chi entra. **Chi l'aveva già aggiunta alla schermata home deve toglierla e rimetterla.**

**Adesione dei minorenni a norma.** Era il buco più serio: il sistema sapeva che una domanda era per un minore ma **non registrava chi l'avesse firmata**. Ora il genitore entra in anagrafica come persona sua, collegata al figlio, e la domanda porta scritto chi ha firmato. Il genitore non diventa socio. Un genitore con due figli iscritti resta una persona sola.

**Ogni salvataggio adesso lo dice, con un avviso grande.** Richiesta di Lele pensando a Claudio: prima la conferma era una riga in fondo al modulo e su pagine lunghe finiva sotto il bordo dello schermo — si premeva Salva e non si vedeva niente. Ora compare in alto, si legge, e si chiude con "Ho capito". Vale su 33 pagine più i 12 moduli che dopo il salvataggio cambiano pagina.

Semplificate anche le etichette dello stato socio ("In tolleranza" → "Quota scaduta — ancora in tempo"). Gli altri termini tecnici Lele li tiene com'erano: li usa lui.

---

## Note

L'ASD non è la priorità creativa di Lele — è una responsabilità da gestire nel modo più efficiente possibile.

**29/08/2026 — il consuntivo diceva il falso, il bot Telegram, i compensi per mese**:

- **Il consuntivo mostrava 0 € di uscite.** Non era un errore di calcolo: l'estratto conto conteneva 20.304 € di addebiti (gennaio-luglio 2026) ma nessuno li registrava a mano come spese, e con 15-30 movimenti al mese quel passaggio non si sarebbe mai fatto. Ora **ogni addebito bancario diventa da solo una spesa** al caricamento dell'estratto conto (mig. 0112); le entrate restano invece dal gestionale, perché l'accredito aggregato di SumUp/Stripe non conosce la categoria del singolo pagamento del socio. Deciso da Lele: lui inserisce a mano solo le uscite in contanti.
- **Regole di categorizzazione** (0113): il testo di un movimento bancario insegna la categoria per i successivi. Da 135 voci in un cassetto unico a **2**. Metà delle 34 regole non sono state decise ora — erano già scritte da Lele in fondo al bilancio 2025 come nota per sé (*Prozis/Euronics=attrezzatura, OBI/Brico=manutenzione, Action/Provera=cancelleria*): trasformate in regole che lavorano da sole.
- **Caricato il consuntivo 2025 storico** dal Drive (`bilancio_consuntivo_2025.xlsx`): 12 mesi di entrate e uscite per categoria + saldo di apertura. Verificato che i totali coincidono al centesimo col file (60.912,98 entrate / 59.006,33 uscite).
- **Bot Telegram @The_crew_gym_bot**. Notifiche in diretta a Lele su incasso in cassa, pagamento online e pre-iscrizione (con il corso di interesse, quando indicato). Aperto agli istruttori con tastiera a tasti sul modello del bot VVF: ognuno vede solo i propri corsi, Lele vede tutto. **Scelta di sicurezza**: il riconoscimento passa da un codice monouso di 15 minuti generato da Lele, non da nome o codice fiscale come proposto inizialmente — nessuno dei due è una prova d'identità e dal bot si vedono le scadenze dei certificati medici degli allievi, minori compresi. Il webhook gira con la service role e scavalca la RLS: il filtro per corso è scritto a mano in `src/lib/telegram/permessi.ts` ed è l'unica difesa esistente.
- **Compensi: il mese sostituisce il periodo** (0116/0117). Prima si sceglievano a mano date di inizio e fine, e chi veniva pagato ogni due mesi rischiava periodi sovrapposti (pagati due volte) o buchi. Ora una riga per collaboratore per mese, `unique(collaboratore, anno, mese)`: pagare due volte lo stesso mese è impossibile a livello di database, non "improbabile se stai attento". Un mese pagato si congela come una ricevuta emessa; gli incassi arrivati in ritardo diventano un conguaglio scritto e motivato sul primo mese aperto, mai una correzione silenziosa del passato. Il vecchio percorso resta funzionante accanto al nuovo.
- **Bollette agganciate** alla spesa già nata dalla banca (per importo ±0,01 € e data ±5 giorni), **mai creandone una seconda**: una spesa in più farebbe contare l'importo due volte nel consuntivo e ce se ne accorgerebbe solo a fine anno. Se nessun movimento corrisponde, il sistema lo dice — è un campanello: pagata da un altro conto o importo che non torna.
- **Controllo da "direttore dei lavori"** richiesto da Lele: 7 difetti trovati, 6 chiusi. Fra questi, tre miei dello stesso giorno — il salvataggio che perdeva il filtro (135 spese da rifiltrare una a una), un form che in produzione mostrava "Qualcosa non ha funzionato" perdendo i dati compilati, e le regole che si creavano ma non si potevano né vedere né cancellare. **Resta aperto il punto 7**: nessuna paginazione su spese e pagamenti, oltre ~1000 righe i totali si troncherebbero senza avvisare (oggi 344 spese, ~20/mese in arrivo dalla banca).
- **Kalèido, un numero che mentiva**: 12 tipologie di abbonamento valgono sui corsi di più istruttori, quindi filtrando per istruttore l'incasso viene contato intero per ognuno. È **corretto per il compenso** (Denaro e Rago prendono il 30% a testa dello stesso monte, confermato da Lele) ma i due totali non si sommano. Non toccato il calcolo: aggiunto un filtro "Gruppo sportivo" che dà il monte reale senza duplicazioni, e un avviso a schermo. Creata anche la regola di compenso mancante per Giulia Rago (30%, da verificare).
- **Valentina Gobbato** è in P.IVA e non è registrata come collaboratrice; da settembre non collabora più. Le sue uscite restano in "Compensi collaboratori" come nel 2025: creare ora una categoria per i professionisti spezzerebbe il confronto con l'anno precedente su una persona che sta uscendo.
- Aperto: 2 pagamenti Poste Italiane (23,25 €) da identificare, auto-collegamento al bot (oggi Lele è collegato solo via database — se cambia telefono resta fuori), collaudo del bot con un istruttore vero.
