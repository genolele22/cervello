# Progetto — ASD Fight in Progress

**Tipo:** Associazione Sportiva Dilettantistica
**Sport:** combattimento e functional training, danza (corsi Kalèido Project)
**Stato:** attiva ma gira poco

## Stato

Stato: in corso — LIVE. Logbook chiuso (7 note) e controllo incrociato su tutti i
  dati. Tre bug veri, corretti e bonificati: l'incasso di un abbonamento non
  creava l'iscrizione (24 persone avevano pagato e risultavano scadute), 41 soci
  su 82 con l'invito di accesso scaduto e nessuna strada per rientrare, sei quote
  di agosto mai finite nel libro soci (Rago risultava decaduta pur avendo pagato).
Deciso: 04/09/2026 — le scadenze prima di agosto non si ricostruiscono, salvo
  quelle ancora in corso: da agosto i conti devono tornare, prima è storia
  importata. Il tutore sceglie da sé se gestire la pagina del figlio.
Prossimo passo: (Lele) Massa Mastroeni e Lione Sara da regolarizzare nel libro
  soci; Gallo e Sejdic senza certificato (Sejdic anche senza assicurazione).

---

## Stato al 03/09/2026

Giornata lunga sul sito pubblico e sul gestionale.
  VETRINA: ricognizione su 10 siti di palestre/ASD (7 italiane, 3 USA) — in
  Italia sbagliano tutti le stesse tre cose (zero testimonianze, istruttori
  invisibili, prova mai dichiarata), e due di quelle noi le avevamo già senza
  dirle. Ora "Vieni a provare" è prima voce di menu e primo tasto, ci sono i
  tre passi per cominciare, le tre rassicurazioni per chi non ha mai fatto
  sport da combattimento, gli orari dentro ogni scheda corso, i filtri per
  famiglia ed età con barra appiccicata, Staff a ritratti grandi con bio al
  click. Tutte le 29 frasi della home sono modificabili da
  /gestionale/testi-sito (erano 6). Il sito si aggiorna da solo quando entra
  un istruttore (mancava la rivalidazione della cache: era un difetto, non
  una funzione mancante). NIENTE CIFRE sul sito: una ASD non pubblicizza
  tariffe, e niente numero di lezioni di prova.
  GESTIONALE: logbook di 17+2 note lavorato a 4 gruppi paralleli, 16 chiuse.
Deciso: 03/09/2026 — il "muro rosso" si risolve col silenzio, non nascondendo:
  chi è fuori tempo da oltre 5 mesi (28/02 + 5) diventa "silente", esce dagli
  avvisi ma resta in elenco, nei filtri e fra i candidati a decadenza. Effetto
  reale: da 151 segnalazioni a 26 su 206 soci. Le foto staff sempre dentro
  l'Ensō, grandi, bio al click, e in homepage NESSUNA anteprima di istruttori
  (mostrarne 4 metteva 4 persone davanti alle altre senza motivo). Nessun
  conteggio di istruttori sul sito: non sono ancora tutti e cambiano.
Verificato a fine giornata (03/09, gestionale ormai in uso vero): audit
  contabile completo — nessun incasso o ricevuta con data futura, nessuna
  ricevuta orfana, importi incasso/ricevuta sempre uguali, numerazione delle
  12 ricevute emesse dal sistema perfettamente consecutiva (i 22 buchi del
  2026 stanno tutti nelle 394 importate dal vecchio gestionale: da chiarire
  con il vecchio sistema se erano annullate o se l'import ne ha perse 22).
  Corretti: contatore 2025 fermo a 3 mentre l'anno arriva a 1024 (una
  ricevuta retrodatata sarebbe stata respinta), 60 € di dati finti ancora
  vivi nei conti (stress test "ZZSTRESS Regolare" + socio di prova), stornati.
  Codice: 272 file, 0 errori di lint, 0 `any`, 0 @ts-ignore, 0 TODO; corretto
  un render a cascata nella select categoria spesa e rimosso un componente
  morto. ATTENZIONE PER IL FUTURO: il contatore ricevute non torna indietro
  quando si cancella — vedi memoria reference_crew_numerazione_ricevute.
Prossimo passo: (Lele) 4 voci dei soci per la homepage — le frasi devono
  essere loro, è l'ultima casella scoperta rispetto ai concorrenti; decidere
  se pubblicare Mirko Bolla e dare 2 righe di presentazione a D'Onofrio;
  mandare il prospetto mensile per il consuntivo; verificare con il vecchio
  gestionale i 22 numeri di ricevuta mancanti del 2026.
  (Macchina) consuntivo mensile nella forma del suo foglio; proposta per i
  verbali (29 su 29 sono adesioni settimanali, gli altri 6 tipi mai usati) e
  per colore/logo dei gruppi.


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

**04/09/2026 — logbook (7 note) e poi un controllo incrociato su tutti i dati.** Il giro è partito da una segnalazione che sembrava minima ("Reale e Zeffiri non risultano negli iscritti": in realtà corretto, non avevano pagato la quota) e ha scoperchiato tre difetti veri, tutti nel punto dove i soldi entrano e lo stato non si muove.

**Un abbonamento pagato non estendeva niente.** Registrando un incasso, il modulo scriveva "l'abbonamento ripartirà dal…" ma era solo un testo: l'iscrizione la creava soltanto "Iscrivi e incassa" dalla scheda socio. Chi passava dalla via più rapida — quasi metà degli incassi veri — pagava e restava scaduto a sistema. **24 persone**, fra cui Carbone (€115 il 01/08, risultava scaduto da giugno). Ora l'incasso crea o estende davvero l'iscrizione, con **data di inizio modificabile** (serviva a Lele proprio per chi è rimasto fermo un periodo) e la nuova scadenza confermata a video e su Telegram. "Iscrivi e incassa" non scrive più nulla di suo: porta tipologia e data al modulo di incasso, che è l'unico posto che scrive — niente più doppia scrittura fra i due percorsi.

**41 soci su 82 erano murati fuori dall'accesso.** La scadenza di 14 giorni sugli inviti (introdotta il 02/09) era stata applicata anche a quelli già spediti, e da lì il sistema si era chiuso da solo: il codice riusava l'invito scaduto (rimandando un link morto), l'indice anti-doppione bloccava anche la mail, e la pagina Accessi mostra solo i "mai invitati" — chi un invito l'aveva ricevuto non compariva più da nessuna parte. Nessuna strada, né automatica né manuale. Ora un invito scaduto viene annullato e rifatto, e in Accessi c'è la sezione **"Invito scaduto"** con il pulsante *Rimanda*, **uno alla volta**: 41 mail insieme sono esattamente la valanga che il tetto di invio esiste per fermare, e sono persone che quel link l'avevano già ignorato una volta.

**Sei quote di agosto non erano mai finite nel libro soci** (residuo del difetto corretto il 02/09): Aliati, Bolla, D'Onofrio, La Rocca Giulia, Rago, Errico. Rago risultava **decaduta pur avendo pagato il 28/08**. Ricostruiti i sei versamenti dagli incassi già registrati.

**Regola nuova, di Lele:** le scadenze anteriori ad agosto non si ricostruiscono, *a meno che non siano ancora in corso*. Da agosto in poi è il gestionale nuovo e i conti devono tornare; prima è storia importata e si lascia com'è. Applicata subito: delle 18 iscrizioni ricostruite il giorno prima ne sono rimaste 7 (quelle in corso o di agosto), le altre 11 tolte.

**Il tutore ora sceglie.** Il meccanismo per cui un genitore vede e gestisce le pagine dei figli esisteva già, ma scattava da solo appena il superadmin scriveva il collegamento. Ora c'è un interruttore per figlio in "Il mio profilo", spento di default: acceso, il figlio ricompare ovunque (abbonamenti, certificati, pagamenti, ricevute); spento, sparisce. Chi rappresenta chi resta scritto solo dal superadmin. Al momento della modifica nessuno dei 5 genitori collegati aveva ancora attivato l'accesso, quindi nessun impatto su chi stava già usando il sistema.

**Altro dal giro:** la tendina del menu si apriva verso sinistra e usciva dallo schermo (ora sempre verso destra); le domande "in attesa di delibera" hanno il link alla scheda, che mancava solo lì (senza, non c'era modo di registrare un pagamento a chi non ha ancora l'accesso); la pagina Verbali mette in cima le bozze **con i nomi già in vista** e retrocede i due moduli manuali, ormai una rete di sicurezza dato il cron settimanale; un job notturno chiude le iscrizioni scadute, che nessuno chiudeva.

**Cosa è risultato pulito nel controllo incrociato:** ricevute (numerazione, importi, collegamento con gli incassi), rate e contratti, spese, entrate extra, estratto conto e saldi, categorie del consuntivo, notifiche ed email, sale e orari, presenze, codici fiscali doppi, omonimie. I dati di collaudo ancora in anagrafica ("Socio Prova", "ZZSTRESS Regolare") hanno gli incassi già stornati: contabilmente non sporcano, restano da togliere alla pulizia di settembre.

**Rimasto aperto, di Lele:** Massa Mastroeni — il libro soci dice che è socia dal 09/09/2025 (numero 252, quota 2025 versata), l'anagrafica dice "richiedente" e la domanda è ferma su "presentata": residuo di un vecchio import, caso unico, e il trigger di protezione impedisce giustamente di forzarlo via SQL (serve il verbale di ricognizione, o l'ingresso in bozza quando versa la quota 2026). Lione Sara risulta socia senza nulla nel libro soci. Gallo e Sejdic si allenano senza certificato medico, Sejdic anche senza assicurazione. La Rocca Giovanni è decaduto dal 28/02/2026. Preiscrizioni ferme: Gaietta Giulia (19/08) e Paravati Roberto. Genovesi Claudio e Valentini Massimo sono collaboratori attivi senza regola di compenso, quindi il loro compenso non si calcola.

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
