# Progetto — The Crew (gestionale ASD)

> **Rivedere entro:** 2026-12-12

**Cos'è:** gestionale completo per l'ASD Fight in Progress — libro soci a norma,
quote e iscrizioni, ricevute numerate, corsi e presenze, compensi collaboratori,
spese e contabilità, verbali del direttivo, notifiche, più il sito pubblico
della palestra. Quattro ruoli con aree separate: superadmin, istruttore, socio,
pubblico.
**Stato:** LIVE su **thecrewgym.com**, con soci veri dentro dal 24/08/2026.
**Priorità:** 1ª nella classifica del 22/08/2026 (gestionale ASD a norma).

**Stack:** Next.js 16 + React 19 + TypeScript + Tailwind 4 su Vercel (regione
`fra1`), database Supabase/PostgreSQL. Stripe per gli incassi, Nodemailer su
SMTP Gmail + imapflow per la copia in Inviati, webhook Telegram, `unpdf` per gli
estratti conto. PWA installabile con notifiche push.
**Repo:** `/home/genolele22/progetti/the-crew`, branch `master`, remote GitHub
privato via SSH (`genolele22/the-crew-gym`). 324 commit dal 01/08/2026.
**Mappa del repo:** `docs/MAPPA.md` — aree, tabelle e cosa lo rompe.
**Controlli:** `docs/coerenza.sql` — 7 query che devono restituire zero righe.

**Il peso sta nel database, non nell'interfaccia:** 66 tabelle, 161 policy RLS,
76 funzioni, 71 trigger, 135 migrazioni numerate. Numerazione ricevute,
conteggio ingressi e scadenze le calcola Postgres. Chi cambia una regola di
dominio cerca la migrazione, non il componente.

**Numeri veri al 06/09/2026:** 218 persone in anagrafica, 203 ammissioni a libro
soci, 123 iscrizioni attive, 9 collaboratori, 18 corsi, 417 ricevute emesse nel
2026, 17.215 € incassati nel 2026.

**Doppia natura, da tenere distinta:** oggi è il gestionale *della sua palestra*.
Diventare **prodotto vendibile** (canale ipotizzato: un commercialista che
rivende) è un'altra cosa e non è ancora deciso — vedi
`the-crew-brief-prodotto-b2b.md`. Da quella decisione dipende il lavoro più
costoso in assoluto: oggi un cliente = un progetto Supabase a sé, e il
multi-tenant significa riscrivere tutte e 161 le policy.

---

## Stato

Stato: in produzione — 14/09/2026 (sera). **Giornata su tre fronti: il bot che non collegava,
  l'export per il commercialista, e la valutazione sulle lezioni online.**
  **Bot.** D'Onofrio non riusciva a collegarsi: due codici bruciati, sei tentativi. Non era
  distrazione sua — lo screenshot ha mostrato `/start CREW 5BU3G2`, con lo **spazio al posto
  del trattino**: sulla tastiera del telefono il trattino sta sotto il tasto dei simboli e chi
  ricopia a mano mette uno spazio. Il bot prendeva la seconda parola, trovava "CREW" e
  rispondeva che non esisteva. Corretto in due modi: ora **perdona** (il codice viene ripulito
  di tutto ciò che non è lettera o cifra e ricomposto — sette forme diverse provate una per
  una) e soprattutto **elimina il problema**: la pagina non dà più un codice da ricopiare, dà
  un **link t.me** che apre il bot col codice già dentro. Codice valido un'ora invece di
  quindici minuti, e il registro ora distingue "ha premuto Avvia" da "ha provato con un
  codice" — prima scriveva `/start` in entrambi i casi, ed è il motivo per cui la diagnosi è
  rimasta a metà fino allo screenshot.
  **Export.** Nuovo bottone "Fascicolo dell'anno" nella pagina Consuntivo: un solo `.xlsx` con
  sei schede — consuntivo, incassi, ricevute, spese, compensi, libro soci. È la risposta alla
  domanda «e se tu sparisci?» che un commercialista fa sempre, e insieme una cosa utile ogni
  anno. Importi come numeri (le somme si fanno nel foglio), stornati e senza-documento come
  colonne e non come righe tolte, base di calcolo accanto al compenso.
Deciso: sull'export si parte dal **fascicolo** e non dal dump completo — il "cartone del
  trasloco" (tutte le tabelle + documenti) e la **copia automatica mensile** restano in
  programma e ora sono mezza giornata ciascuno, perché riusano la stessa macchina.
Aperto: **il fascicolo non l'ha ancora generato nessuno** — compila e la rotta risponde, ma
  serve una sessione superadmin per produrre il file davvero. Da premere e controllare.
  E la ricerca sulle lezioni online si chiude in TEST, non in GO: vedi la scheda qui sotto.

## Ricerca 14/09/2026 — Lezioni online: tesseramento e prezzo

DOMANDA — Chi segue le lezioni online deve essere tesserato sotto l'ASD, e come si fanno pagare.

RISPOSTA — Sì, devono essere tesserati: è l'unico modo perché l'incasso resti fuori dal
commerciale. Ma il tesseramento NON porta con sé la copertura assicurativa per chi si
allena da casa, e il rischio vero è lì, non nel fisco.

CONFIDENZA — Alta sul fiscale, media sull'assicurativo (fonte broker, non testo di polizza CSEN).

3 FATTI
1. Art. 148 c.3 TUIR: non commerciali i corrispettivi specifici da soci **e tesserati** per
   attività in diretta attuazione degli scopi istituzionali; Circ. 18/E/2018 §7.1 include i
   tesserati dell'ente affiliante (quindi basta il tesseramento CSEN, non serve socio pieno).
2. Chi non è né socio né tesserato paga un corrispettivo commerciale: IVA e reddito d'impresa.
3. Dal 1/1/2025 (D.Lgs. 180/2024, dir. UE 2022/542) i servizi B2C in streaming scontano l'IVA
   nel paese di chi guarda. Riguarda solo chi esce dal 148.
   Più il fatto scomodo: l'assicurazione obbligatoria copre attività e allenamenti
   **sorvegliati in impianti affiliati** — un salotto di casa non lo è.

TESI CONTRARIA — «L'attività sportiva presuppone presenza e sorveglianza, quindi a distanza
è servizio formativo, commerciale anche verso i tesserati.» Non ho trovato norma né prassi
che lo dica, ma nemmeno il contrario: sulla lezione sportiva a distanza non risulta una presa
di posizione specifica dell'Agenzia. Zona grigia reale.
Regge invece nettamente la distinzione **diretta vs registrata**: la diretta interattiva
somiglia all'attività istituzionale; una libreria di video venduta a chiunque è prodotto
digitale, commerciale, con l'IVA nel paese del cliente. Se si fa, si fa in diretta.

DECISIONE — **TEST.** Manca un dato decisivo che non si ricava da fuori.

PROSSIMA MOSSA — Lele: una mail a CSEN Vercelli — «la polizza copre un tesserato che segue
una lezione in diretta da casa? Se no, esiste un'estensione?». La risposta scritta vale più
di tutta la ricerca.

COSA LA RIBALTA — Se CSEN conferma la copertura da remoto, il rischio principale sparisce e
si può spingere. Se dice di no e non esiste estensione, l'online va fatto solo con liberatoria
e valutazione seria, o non va fatto.

MODELLO DI PREZZO (giudizio, non fatto) — tipologia "online" a sé a prezzo più basso,
difendibile perché non occupa sala né utenze; e online compreso per chi già paga in presenza,
che costa zero e trattiene chi per due mesi non può venire.

## Stato al 14/09/2026 (notte)

Stato: in produzione — 14/09/2026 (notte). **La demo diventa mostrabile, e il gestionale
  diventa un prodotto con tre porte da far vedere.** Il commercialista è il canale, e a
  esso si aggiunge ora l'ente di promozione sportiva. La demo era **morta**: progetto
  Supabase in pausa da fine agosto, pagine che rispondevano 200 ma vuote — il modo
  peggiore di accorgersene sarebbe stato aprirla davanti a qualcuno. Riattivata, e un job
  `ping-demo` in produzione la tiene sveglia ogni tre giorni chiamando il **database**,
  non il sito (un 200 dal sito è esattamente ciò che rispondeva mentre il database
  dormiva). Schema portato da 0086 a 0151, popolata con un'associazione finta credibile:
  94 soci, 7 corsi generici con orari su sei giorni, 279 iscrizioni, 290 incassi, 276
  ricevute senza buchi, tre collaboratori con regole di compenso diverse, consuntivo ed
  estratto conto — più i pasticci voluti (quota scaduta, certificato mancante, rata in
  ritardo, socio cessato). Marchio neutro: via logo, Ensò, palette e **le foto di Lele
  col figlio**, che stavano nel codice e non nel database.
Deciso: **niente sito pubblico nella demo** (Lele: lo presenta a voce, si paga a parte).
  **Una proposta di prezzo sola, non tre**, e la ripartizione del canone come modello:
  il commercialista non anticipa niente. **Non costruire il multi-cliente adesso** — 50
  tabelle e 125 regole di accesso prima di avere un cliente pagante è il modo classico
  di bruciare tre mesi; i primi si attivano a mano, detto come scelta di fase.
Trovato, e conta più della demo: **la migrazione 0129 si rompe su qualunque database
  nuovo** (aggiunge un valore a un enum e lo usa nella stessa transazione) — cioè il
  giorno in cui si attiva la prima associazione cliente. Va spezzata in due. E **la
  "sola lettura" della demo non è quella promessa dal dossier**: protegge chi passa
  dall'app, non chi ha le chiavi di servizio. La frase «non aggirabile nemmeno
  bypassando l'interfaccia» va corretta prima di dirla a un commercialista.
Aperto: i tre accessi alla demo **non sono mai stati provati dal vivo** (l'ambiente non
  può fare il login) — vanno provati prima dello studio, non davanti a lui. E manca
  ancora l'**export dei dati in un click**, che è la risposta alla domanda "e se tu
  sparisci?" e la trasforma da obiezione in argomento di vendita.

## Stato al 13/09/2026

Stato: in produzione — 13/09/2026. **Nasce il Radar Bandi, e prima di tutto il pezzo
  che serviva davvero: sapere quanto siamo pronti.** Lele porta una specifica in 30 punti
  (origine ChatGPT) per un sistema che trovi, verifichi e classifichi i bandi da solo.
  Leggendo per intero un avviso vero — **Circolo 65** di Sport e Salute, € 23.800, scadenza
  18/09 — è saltato fuori che quasi nessun requisito a pena di esclusione riguarda il
  progetto: RASD valido per l'anno in corso, DURC, SPID del legale rappresentante, e
  **almeno due partner che non siano ASD/SSD**. Riguardano l'ente, sono gli stessi quasi
  ovunque, e sono le sole cose che non si procurano nei cinque giorni prima di scadere.
  Circolo 65 **lasciato andare** (Lele: non c'è tempo).
  LIVE oggi: **Prontezza** (`/gestionale/prontezza`, 0149/0150) — profilo dell'ente,
  20 requisiti ricorrenti con link al documento sul Drive e semaforo calcolato dal
  database, rubrica partner. **Bandi** (`/gestionale/bandi`, 0151) — archivio a quattro
  colonne, scheda, e il semaforo che legge la prontezza invece di ricalcolarsela. Il
  vincolo del punto 18 è un CHECK, non un controllo di pagina: un bando non può diventare
  "candidabile" se la fonte non è verificata (provato a forzarlo, respinto).
  LIVE anche il logbook del giorno: **entrate già impegnate** dalle rateizzazioni, riquadro
  sul cruscotto e tasto su Telegram — **Telegram verificato dal vivo da Lele**, il riquadro
  no.
Deciso: **i dati parziali vanno bene così** (Lele: il passaggio da un gestionale all'altro
  non è finito, a gennaio forse i dati veri). Quindi il profilo dichiara la propria
  copertura invece di fingere numeri: 150 soci su 206 non hanno data di nascita, 136 non
  hanno il comune. E **il radar deve trovare i bandi da solo** — un sistema in cui è Lele a
  trovarli non è un radar: correzione sua, giusta, il collector non può restare per ultimo.
  Tre canali indipendenti da costruire: adattatori su fonti ufficiali (Bandi Piemonte ha un
  RSS per sezione, verificato, ma è una finestra di 10 elementi e da sola perde roba),
  ricerche programmate filtrate per dominio ufficiale, e **la casella di posta iscritta alle
  newsletter** — quest'ultima è già tecnicamente in casa (IMAP c'è già) ed è il canale che
  nessuno scraper replica.
Trovato: i documenti dell'ente **ci sono tutti sul Drive**, ma sparsi su due account e
  quattro cartelle, in più copie — quattro statuti diversi più otto scansioni sciolte. È il
  motivo per cui il registro punta ai file invece di copiarli, e perché la spunta
  "verificato" la mette una persona: il sistema sa dove sta un file, non se è il vigente.
  Oggi: 14 requisiti mancanti, 6 da controllare, **nessuno pronto**, e **zero partner non
  sportivi disponibili** — che da solo rende irraggiungibili i bandi di sport sociale.
Metodo: due agenti Sonnet in parallelo (uno su una copia isolata del repo). Riletto il loro
  codice invece di fidarmi dei rapporti, e trovati due difetti nelle rate: il dettaglio di un
  mese non tornava col totale, e "oggi" era in UTC mentre le funzioni girano su Vercel — fra
  mezzanotte e le due italiane sbagliava giorno. Il progetto aveva già `dataOggiRoma()`.
Aperto: **nessun agente può verificare con gli occhi una pagina di `/gestionale`** — è dietro
  login, gli unici superadmin sono caselle vere di Lele, e toccare credenziali di persone
  reali è vietato dal 06/08. Proposto un account di collaudo creato col flusso normale,
  **Lele: lasciare così**. Restano fuori anche i **5 inviti di accesso scaduti** (creati
  24-29/08, scaduti 7-12/09: cinque persone col link morto in mano) — segnalati, non toccati
  per sua scelta. Verbali e RID→fattura restano parcheggiati da lui.

## Stato al 12/09/2026

Stato: in produzione — 12/09/2026. **Home accorciata e bot completato.** Sul sito: da
  **10 fermate a 6** su telefono (foto di apertura ridotta e ritagliata sul viso, paragrafo
  "cosa facciamo" che ripeteva le card ridotto a una riga, "Chi ti allena" e "Chi siamo"
  fusi in una sezione sola, stacchi da 20/28 a 12/20). Nata la **quarta anima —
  Allenamento**: sala pesi e functional erano infilati in coda al riquadro
  "Combattimento", chi cerca solo la palestra non si riconosceva lì. I quattro riquadri
  ora **portano a /corsi già filtrato** (`?area=`), a due colonne già da telefono.
  Sul bot: `/compenso` da superadmin (prima diceva "non risulti un collaboratore"),
  `/scadenze` interattivo con un bottone per persona scaduta, `/incassi` per mese con
  totale da inizio anno, link diretti in ogni avviso, e un bottone per istruttore che
  apre la sua scheda. Nel gestionale, da ogni mese di compenso si va ai pagamenti
  filtrati su quell'istruttore.
Deciso: **le FAQ della home parlano a tutti, non a un settore** — "Devo combattere?"
  non diceva niente a chi arriva per lo yoga, sostituita con "Posso provare più di un
  corso?"; la risposta dice **due** discipline, mai "tutte" (equivarrebbe a un mese di
  lezioni gratis ovunque). **Il compenso di un istruttore guarda tutti i corsi che fa**,
  non solo le tipologie in base compenso (Lele, 12/09). Il titolo di un riquadro non è il
  nome del gruppo e non deve diventarlo: "Kalèido" da fuori non dice niente, "Danza" sì.
Trovato e corretto sui compensi: **"Difesa personale & Bastone da passeggio" era
  agganciato a 8 tipologie Kalèido**. Nessuno l'aveva deciso: un abbonamento danza dava
  accesso a un corso Combat e, peggio, faceva entrare quell'incasso nella base compenso
  del suo responsabile. Senza effetti sui soldi solo perché Claudio Genovesi è volontario
  senza compenso. Scollegato. Verificato dopo: Denaro e Rago restano a 12 tipologie
  Kalèido a testa, ognuna al 30% di tutto il gruppo — che è il patto vero.
Aperto: la **sezione Corsi è ora il blocco più lungo della home** (19 nomi su 5 gruppi) e
  in parte ridondante ora che le quattro porte funzionano — ridurla è la prossima leva, ma
  vale per Google, **decisione di Lele**. Verbali ("non mi convince") e RID→fattura
  restano parcheggiati da lui. Restano da dare **orari di apertura** e **foto di danza e
  olistico**.
Aggiunto in coda al 12/09 — **incasso senza documento** (0147/0148): si può registrare un
  pagamento senza emettere la ricevuta, spunta chiusa in fondo al modulo, motivo
  facoltativo. **A cosa serve davvero** (Lele: "non è una cosa da fare ma di necessità
  virtù"): tenere in piedi le **scadenze del socio** quando l'incasso non viene
  fatturato, es. contanti usati per una spesa d'emergenza. Quindi: il socio risulta
  pagato e l'abbonamento avanza, **il consuntivo NON lo conta** (conta solo gli ingressi
  documentati — mia prima versione sbagliata, corretta lo stesso giorno), la **base
  compenso dell'istruttore SÌ** (confermato da Lele: la lezione l'ha fatta). Resta fuori
  dal filtro anche il confronto commissioni carta, perché dal POS quei soldi passano
  comunque. Non è invisibile: riga a database, badge "Senza documento" nell'elenco
  pagamenti. Solo in registrazione — una ricevuta emessa ha già consumato il suo numero.
Prossimo passo: Lele prova `/incassi` e `/compenso` dal bot ora che i bottoni arrivano
  davvero (vedi lezione sul webhook in regole-AI.md). Poi si decide se accorciare la
  sezione Corsi in home.

---

## Stato al 10/09/2026 (sera)

Stato: in produzione — 10/09/2026, **cassa e banca ora si confrontano da sole con la
  realtà**: eliminato il blocco "cassa e banca reali" da inserire a mano a fine
  periodo (mai più conteggio fisico della cassa, mai più ridigitare un saldo di banca
  già nel PDF) — la banca si confronta in automatico con
  `estratto_conto_mensile.saldo_finale`, la cassa resta sempre calcolata. Scoperto
  costruendo quel confronto: un bonifico di 1.000€ (Teresa Errico, erogazione
  liberale) datato 31/08 nell'incasso ma arrivato in banca il 06/07 — 56 giorni di
  scarto, quasi tutto lo scarto banca di agosto (-862,88€). Causa reale: il
  consuntivo leggeva `data_incasso` (inserita a mano) invece della data vera del
  movimento bancario. Corretto alla radice (0144): nuova colonna
  `incasso.movimento_estratto_conto_id`, funzione `incassi_contabili()` che usa la
  data del movimento abbinato quando c'è. L'abbinamento (in fase di caricamento
  estratto conto) richiede importo + finestra di 120gg + cognome del socio nella
  descrizione del bonifico, univoco — verificato sui dati reali che l'importo da
  solo non basta (una famiglia che paga la stessa quota ogni mese genera decine di
  candidati identici). Backfill fatto su Errico e Genovesi. Scarto agosto sceso da
  -862,88€ a +137,12€.
  Aggiunta anche "Commissioni carta teoriche" (incassi con carta meno bonifici
  Stripe/SumUp ricevuti, lo stesso conto che Lele faceva a mano a fine anno) —
  calcolata da sola ogni volta che si apre la pagina, MAI registrata come spesa
  automatica (i payout raggruppano più giorni insieme, il numero mensile può uscire
  storto o negativo — luglio e agosto 2026 escono entrambi "non affidabili" per
  questo). Trovato uno scarto sospetto anche sul cumulato 2026 (lordo 11.940,01€
  contro 12.165,33€ ricevuti, -225,32€): da controllare contro i pannelli veri di
  Stripe/SumUp, potrebbero esserci vendite con carta mai registrate come incasso.
Deciso: mai più conteggio fisico della cassa (Lele, 10/09: "troppo complesso ed
  inutile"); il 2025 resta un buco di dettaglio — l'anno è nel gestionale (60.913€
  in `entrata_extra`, non in `incasso`: importato come totali mensili per categoria
  dal bilancio storico, senza dettaglio socio né modalità di pagamento) ma non
  abbastanza fine per rifare il conto commissioni. Lele: "lascia così, vediamo i
  problemi grossi che salteranno fuori chiudendo settembre a inizio ottobre".
**Seconda metà del 10/09 — il sito pubblico: ricerca incrociata e prime due mosse LIVE.**
  Nuovo obiettivo dato da Lele: sito "più minimal e di facile lettura, ma bello". Due
  ricerche Consensus sue + una mia, incrociate: la prima sua era **fuori tema** (la parola
  "sport" ha portato neuroscienza dello sportivo, 28 lavori su 40 sul cervello degli atleti,
  non sul design); la seconda, rifatta senza "sport", è ottima. Quello che regge: la fiducia
  si decide **entro 1 secondo** e non si rivede (Pengnate 2018); con chi non ti conosce
  l'aspetto pesa più dell'usabilità, **e di più sulle donne** (Pengnate 2017 — il takeaway
  di Consensus aveva il genere invertito, verificato alla fonte); i **volti** costruiscono
  fiducia iniziale (Karimov 2011); **l'ordine** è l'unica variabile su cui tutti concordano,
  la complessità no. Diagnosi sul sito vero: non è brutto, **è vuoto** — zero fotografie in
  home, zero prezzi, indirizzo sepolto in /chi-siamo, telefono e orari da nessuna parte,
  palinsesto sotto la piega. Pagina di direzione con mockup veri (foto e colori suoi):
  https://claude.ai/code/artifact/ebf3cda8-29a3-4894-a100-52a454592e2a
  **Lavoro 28 LIVE**: contatti in ogni pagina (telefono +39 351 659 2057 e orari come chiavi
  `testo_sito_*`, modificabili senza deploy; tel:/wa.me cliccabili; la riga orari non compare
  finché la chiave è vuota) e palinsesto con intestazione compressa + giorno di oggi marcato.
  **Lavoro 29 LIVE**: la home ha finalmente una fotografia di persone — Emanuele sul tappeto
  col figlio, `public/foto/apertura-home.jpg`, **specchiata** perché il bambino cada sotto la
  sfumatura scura (è un minore); via il logo nella scheda inclinata, l'Ensō passa **sopra**
  l'immagine (dietro sparirebbe) a opacità 0.3. Su /staff la riga che dichiara perché le foto
  sono scattate fuori (`testo_sito_staff_foto`, con ripiego già scritto: i medaglioni non si
  toccano). Nuovo `BloccoInfoPrezzi` — «Per info e prezzi, chiamaci» + tasto numero + tasto
  WhatsApp — in fondo alla home e sotto l'elenco dei corsi.
  **Poi tre correzioni di Lele guardando dal telefono**, tutte nella stessa direzione:
  (1) la foto dietro il testo sul telefono "si vede poco e niente" — un 16:9 schiacciato in
  verticale resta un grigio indistinto, e non si aggiusta con `object-position`: ora sotto
  `lg` c'è `apertura-home-mobile.jpg`, scatto **verticale 4:5** tagliato stretto su di lui
  (il bambino esce da solo dall'inquadratura, niente velo necessario) messo **sotto** il
  testo e in chiaro; (2) via del tutto la riga sopra i ritratti — "meglio niente e lasciare
  a l utente capire" — e via anche la chiave `testo_sito_staff_foto`, pagina staff tornata
  identica; (3) chiuso il vuoto scuro fra testo e foto (padding reso asimmetrico e solo
  sotto `lg`). **Formato di riferimento per le foto nuove: verticale.**
Deciso sul sito: **prezzi mai pubblicati** (sono un'ASD, un listino li avvicina a
  un'immagine commerciale) — al loro posto «Per info e prezzi, chiamaci» + tasto telefono +
  WhatsApp, asciutto; **apertura** = Emanuele sulla fitball col figlio, **specchiata** così
  il bambino resta sotto le scritte (è un minore); **Ensō come mantra** in apertura e su ogni
  sezione, ma **i medaglioni degli istruttori non si toccano** (già centrati, un mio
  rifacimento li aveva scentrati); **iaido mai come immagine rappresentativa**, è un corso
  marginale — il peso commerciale della disciplina viene prima della bellezza dello scatto.
Aperto: lo scarto -225,32€ sul cumulato 2026 delle commissioni carta, causa non
  ancora trovata; cassa calcolata negativa da agosto 2026 (ancora da spiegare, vedi
  blocco sotto); **mancano le foto di danza, olistico e corsi bambini** — delle 16
  d'archivio di Lele sono tutte combattimento/grappling/functional, ma la home promette
  tre mondi e Kalèido è la parte che porta più iscritti; **gli orari di apertura** non
  sono ancora stati dati (la chiave c'è, va riempita da /gestionale/testi-sito).
Prossimo passo: a inizio ottobre, chiusura di settembre — è lì che Lele si aspetta
  di vedere i problemi veri della cassa negativa e delle commissioni. Sul sito le cinque
  mosse sono tutte in produzione: restano gli **orari di apertura** da scrivere in
  /gestionale/testi-sito e **un'ora di foto** a lezione da Giulia e da Aurora (danza e
  olistico non hanno una sola immagine, e Kalèido è la parte che porta più iscritti).

---

## Stato al 10/09/2026 (mattina)

Stato: in produzione — 09-10/09/2026, **chiusi i 4 gruppi di logbook aperti** (filtri
  anagrafica multiflag come in vvf, il duplicato Bertola unito e la domanda scartata
  che ora toglie davvero dai "Richiedenti", colore/logo dei gruppi sportivi resi veri
  con avviso di contrasto mai bloccante, switcher genitore-figli a pieno controllo,
  tre bottoni verbali protetti dal doppio invio) **e due bug reali sul consuntivo**:
  il saldo cassa/banca non si ereditava oltre un capodanno (la ricorsione scendeva
  mese per mese invece di saltare all'anno, esauriva il tetto prima di trovare
  l'apertura 2025) — e i versamenti di contanti allo sportello, mai sincronizzati (6
  movimenti reali, 3.600€ da gennaio ad agosto, verificato zero entrate collegate):
  ora il caricamento dell'estratto conto li riconosce da soli ("...per versamento da
  cassa") e registra insieme entrata banca e uscita cassa. Nuovo registro movimenti
  di cassa nel consuntivo, riga per riga come il vecchio foglio Excel.
Deciso: gruppi sportivi con colore/logo **diretti** (Lele li sceglie, avviso di
  leggibilità mai bloccante), non più tradotti a mano nel codice; genitore-figli con
  **pieno controllo**, un profilo alla volta con switcher, non tutto mescolato.
Aperto: **cassa calcolata negativa** ad agosto 2026 (-239,55€ a fine mese, visto per
  la prima volta nel nuovo registro) — segnale vero da guardare, non ancora spiegato;
  17 foto duplicate di Auricchio ancora da cancellare a mano in Supabase Storage.
Prossimo passo: Lele guarda la cassa negativa di agosto nel registro movimenti e dice
  se torna; verificare lo switcher genitore-figli quando Mirela Rotaru accede di nuovo.

---

## Stato al 07/09/2026 (sera)

Stato: in produzione — 07/09/2026, **bonifica di dati, sicurezza e reversibilità**
  (giornata lunga, il dettaglio sta nei task pendenti). Chiuse verso l'esterno tre
  funzioni raggiungibili con la sola chiave pubblica del sito e due funzioni morte
  ancora invocabili. Reso impossibile registrare due volte lo stesso pagamento.
  Corretta la data di inizio abbonamento, che a chi tornava dopo una pausa
  rubava i giorni di assenza. Libro soci ripulito dai nominativi di collaudo e
  blindato. Estesa la tracciabilità ai registri che prima non lasciavano traccia,
  e aggiunta una via d'uscita dal verbale confermato per errore. Chiuso il buco
  che sdoppiava le anagrafiche. Sistemati cruscotto, allarmi e ordine degli elenchi.
Deciso: **quota associativa per anno solare** (gen-dic), mai per stagione;
  **abbonamenti a durata di tipologia** dal giorno in cui si fanno, solo Kalèido
  è stagionale; **l'assicurazione copre anche i non soci**, quindi non è un
  argomento per sollecitare la quota; **niente inviti in blocco** — chi rientra
  passa dalla pre-iscrizione e l'invito parte da solo; oltre **15 giorni** di
  ritardo sul rinnovo la data d'inizio non si decide da soli, si chiede.
Aperto: due soci si allenano **senza certificato medico** · 9 ammissioni senza
  quota (verbale del 01/09) · quattro incoerenze anagrafiche di cui una senza
  percorso legittimo per correggerla · **ripristino del backup mai provato** ·
  consuntivo banca/cassa senza diagnosi · 7 note di logbook.
Prossimo passo: **il sito pubblico**, che non convince Lele. Sul gestionale,
  i due certificati mancanti: riguardano persone che si allenano adesso.

---

## Stato al 07/09/2026 (mattina)

Stato: in produzione — 07/09/2026, giornata di **bonifica dati e sicurezza**.
  Chiuse tre funzioni `security definer` che erano eseguibili da chiunque avesse
  la chiave pubblica del sito, ed eliminate le due `registrati_collaboratore`
  morte dal 28/08 (0137). Corretti: il filtro "Rata non pagata" che ignorava la
  data di scadenza, il generatore dei verbali che riproponeva 113 persone già
  socie, il contatore "da regolarizzare" (18 → 2), la campanella delle notifiche
  che usciva dallo schermo. Unite le schede doppie dei due Lo Bianco e chiuso il
  buco che le aveva create. Nuovo allarme "si allena con la quota scaduta".
Deciso: la **quota associativa va per anno solare** (gen-dic), mai per stagione;
  gli **abbonamenti scadono per durata della tipologia** dal giorno in cui si
  fanno, solo Kalèido è stagionale; l'**assicurazione copre anche i non soci**,
  quindi non è una motivazione per sollecitare la quota.
Aperto (dal controllo incrociato di fine giornata, in ordine di gravità):
  2 soci si allenano **senza certificato medico** (Sejdic, Gallo) · 4 incoerenze
  di libro soci · residui di collaudo vivi (Socio Prova, Regolare ZZSTRESS) ·
  210 spese non agganciate all'estratto conto, ed è il motivo per cui il
  consuntivo non quadra banca e cassa · le 9 ammissioni senza quota del 01/09.
Prossimo passo: i due certificati mancanti — riguardano persone che si allenano
  adesso.

---

## Stato al 06/09/2026

Stato: in produzione — 06/09/2026: giro sul **metodo**, non sulle funzioni.
  Aggiunta `nota_logbook.scoperto_da` (migrazione 0135): chiudendo una nota si
  dice come è emerso il difetto — utente, caso, collaudo, test, sentinella — e
  in cima alla pagina c'è il riepilogo di chi li trova. È l'unica misura che
  dice se il modo di lavorare funziona. Creati `docs/MAPPA.md` e
  `docs/coerenza.sql`. Deploy verificato (Age 1m).
Deciso: 06/09/2026 — la fascia di numerazione **≥ 9000 è riservata ai collaudi**
  e non entra mai nella sequenza fiscale vera (di fatto era già in uso: la
  ricevuta 9001/2026 è una prova del 07/08). Gli eventi di libro soci
  precedenti al 01/08/2026 sono storico importato e restano fuori dai controlli.
Trovato e **non** risolto (dati di persone vere, decide Lele):
  - **41 inviti** creati il 16-17/08 risultano ancora `in_attesa` ma sono
    scaduti dal 30/08. Sono gli stessi dell'incidente del 04/09: la causa è
    corretta, le righe no. Da verificare se quelle persone riescono a entrare.
    → **RISOLTO il 07/09**: cancellati su richiesta di Lele, quelle persone
    tornano "mai invitate". Restano i 4 dello stesso giro che erano stati usati.
  - **9 ammissioni** al libro soci da agosto in poi senza quota incassata: sono
    quelle del verbale confermato dall'agente in 14 secondi il 01/09. Mai
    ripulite.
Prossimo passo: decidere su quei due elenchi; poi la scelta vera —
  **The Crew resta il gestionale della palestra o diventa prodotto?**

---

## Deciso: niente inviti in blocco (07/09/2026)

Gli inviti ad attivare l'accesso **non si mandano a tappeto**. Chi non ha
l'accesso e non torna in palestra non è un problema da risolvere: quando
rientra compila la pre-iscrizione, il sistema lo riconosce come socio già
esistente, e l'invito parte da solo alla conferma. Semplice e senza valanghe.

Perché regge solo da oggi: prima il codice trovava l'invito vecchio «in
attesa» e non ne generava uno nuovo (caso Rosa Di Gregorio, 04/09: accettata,
nessuna mail). Ora l'invito scaduto viene annullato e rigenerato, e sulla
scheda di ogni socio c'è il riquadro «Accesso al sito» con lo stato reale e il
pulsante per mandarlo, che verifica nel registro se è partita davvero.

I 41 inviti spediti in blocco il 16-17/08 sono stati cancellati: quelle
persone risultano «mai invitate», che è la verità.

## Come si lavora qui

- **Collaudo con dati finti nel DB reale**, poi rimossi. Attenzione: una riga
  "TEST" può avere ricevute numerate vere agganciate. Per incassi e ricevute si
  **storna** (`rimborsato_il`), non si cancella.
- **Il collaudo RLS si fa via SQL diretto**, mai con un GRANT per colonna. E un
  collaudo fatto da superadmin non dimostra niente sugli altri tre ruoli.
- **Niente service role key in locale** (è sempre vuota, ed è comunque bloccata
  dal sandbox): si passa dal tool MCP di Supabase, `execute_sql` /
  `apply_migration`.
- **Deploy dopo ogni sessione**, e si verifica l'**età** del deployment, non un
  HTTP 200.
- **Il tetto fail-closed sulle email non si aggira mai** (migrazione 0111, max 3
  al giorno allo stesso indirizzo): esiste perché il 26/08 sono partite ~3.000
  mail in due giorni, 577 alla stessa persona, e Google ha bloccato la casella
  dell'ente.

## Aperti / sospesi

- Bug "Indietro" su dispositivo, `numero_rate_online` Kalèido, ~130 inviti
  storici, gruppo "Claudio" (lasciato apposta, diventerà altro).
- Nessun test automatico, nessuna CI, nessun ambiente di prova separato.
- Betatest a 4 ruoli fatto da Claude come acquirente (agosto): mancano
  onboarding di un cliente nuovo, e i canali WhatsApp/Telegram sono finti.
- Azzeramento dei dati di collaudo quando Lele dà l'ok all'uso pieno.

## File collegati nel vault

- `fight-in-progress.md` — l'associazione (soldi, collaboratori, struttura)
- `the-crew-brief-prodotto-b2b.md` — l'ipotesi prodotto, rimandata
- `the-crew-brief-pubblicita-asd.md` — la campagna per la palestra
- `the-crew-social-calendario.md` — contenuti social THE CREW
- `the-crew-migrazioni/` — note sulle migrazioni
