# Progetto — The Crew (gestionale ASD)

> **Rivedere entro:** 2026-12-06

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
