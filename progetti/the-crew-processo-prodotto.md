# Il processo: da gestionale di una ASD ad azienda che lo fornisce a tante

> **Rivedere entro:** 2026-12-17

**Cos'è questo file.** Il percorso completo per trasformare Crew da strumento interno di
un'associazione a servizio venduto a molte piccole ASD. Comprende la parte tecnica, quella
legale e quella commerciale, e soprattutto **le decisioni già prese con il motivo di ciascuna** —
perché il costo più alto di un progetto lungo è ridiscutere ogni mese le stesse cose.

Scritto il 17/09/2026, dopo una sessione di confronto con cinque pareri esterni indipendenti.

---

## Da dove si parte, dove si arriva

Si parte da un gestionale che serve **una** associazione, in produzione dal 12 luglio 2026, con
soci veri, 624 ricevute numerate vere e la contabilità dell'anno dentro. Non è un prototipo: è
il sistema su cui gira davvero A.S.D. Fight in Progress.

Si arriva a **molte piccole ASD** che pagano un canone annuo per lo stesso software, dove nessuna
vede i dati delle altre. A vendere e ad assistere è la società di un commercialista; chi scrive
il software riceve una quota come diritti d'autore.

Il salto non è tecnologico — lo stack va già bene. È tutto nel passaggio da *"funziona per me"*
a *"funziona per chi non ho mai visto, senza che io sia presente"*.

---

## Le sei decisioni che non si ridiscutono

Ognuna è costata una discussione lunga. Se un domani sembrano sbagliate, si riaprono solo con un
fatto nuovo, non con un'opinione.

**Un database solo per tutti, non uno per cliente.** Un database per cliente costa circa dieci
dollari al mese e non è un problema di soldi: si rompe sulla catena di rilascio, perché ogni
modifica andrebbe applicata a ogni database e ogni pubblicazione moltiplicata. Il punto di
rottura sta intorno ai quindici clienti, non ai trecento. E il costo della fusione cresce con il
numero di clienti già attivi: con un database solo — il nostro — è una migrazione; con quindici è
un progetto. Per questo si fa **prima** di riempirsi di clienti.

**Il cliente è la singola ASD.** Commercialisti e federazioni sono *incubatori*: canali che
mettono in contatto con molte associazioni insieme. Non sono clienti e non sono un livello del
modello dati. Basta registrare da chi è arrivata un'associazione, per l'attribuzione. Una
gerarchia federazione → associazione era stata proposta e ritirata nella stessa giornata:
complessità comprata per un caso che non esiste.

**La semplicità è un vincolo, non un'aspirazione.** L'utente è un volontario che apre il
gestionale venti minuti a settimana e non ha voglia di imparare niente. Ogni scelta che aggiunge
un'opzione va contro il prodotto. Il vantaggio competitivo dichiarato è che lo costruisce chi una
ASD la gestisce davvero, e quel vantaggio si spende in semplicità o non si spende affatto.

**Il presidente non apre un account da nessuna parte.** Né posta, né bot, né dominio, né hosting.
Porta i suoi dati e il suo logo. Tutto il resto arriva già acceso. L'unica eccezione è il denaro:
per incassare online serve un conto intestato all'associazione, perché la verifica d'identità è
di legge — ma resta opzionale, e la maggior parte delle piccole ASD incassa contanti e bonifico.

**Vende la società, l'autore prende diritti d'autore.** Lele è dipendente pubblico e la partita
IVA per attività abituale ricade nelle incompatibilità dell'art. 53 del D.Lgs. 165/2001. I
proventi che l'autore ricava dall'utilizzazione economica della propria opera dell'ingegno ne
stanno invece fuori, e il software è opera protetta. Dettagli e paletti più sotto.

**Si consegna solo ciò che ha dati veri dietro.** Una funzione costruita ma mai usata non si
vende: la collauderebbe il primo cliente pagante, sui suoi soci. Dove serve, si spegne con un
interruttore e si riaccende quando è stata provata.

---

## Il percorso tecnico

L'ordine conta più dell'elenco. Ogni passo è messo lì per un motivo, scritto accanto.

**Prima di tutto, mettere al sicuro quello che già c'è.** Un controllo che avvisa se gli invii
automatici si fermano, e il passaggio da una casella Gmail personale a un servizio di posta vero.
Ad agosto le email sono rimaste ferme cinque giorni senza che nessuno se ne accorgesse: è un
rischio che esiste **adesso**, per l'associazione che usa il sistema oggi, non domani per i
clienti. Due o tre giorni di lavoro, e non dipende da nessuna decisione.

**Poi togliere "The Crew" dal programma.** Oggi il nome dell'associazione, l'ente a cui è
affiliata, il numero di registro, l'informativa privacy, il logo e i colori sono scritti dentro
il codice e nelle variabili di configurazione. Vanno spostati dove ogni associazione può avere i
propri. È il prerequisito di tutto il resto — finché stanno lì dentro non esiste niente da
personalizzare — ed è il passaggio che **nessuno dei cinque pareri esterni aveva visto**: partono
tutti direttamente dalla separazione dei dati.

**Poi chiudere le porte di servizio.** Ci sono 41 punti del programma — invii automatici,
controlli notturni, webhook dei pagamenti — che lavorano con una chiave che apre tutto e ignora
ogni regola di accesso. Vanno fatti passare da un solo punto obbligato che pretende di sapere di
quale associazione si parla, con un controllo automatico che impedisce di aggiungerne altri per
distrazione. Su questo concordano tutti e cinque i pareri: è il rischio numero uno.

Si fa **prima** della separazione dei dati, non insieme: non ha bisogno che le associazioni siano
già più di una, e una volta ridotta la superficie l'identificativo si aggiunge in un posto solo
invece che in quarantuno. *(Nota tecnica: impostare variabili di sessione non basta finché si usa
la chiave che apre tutto — le regole di accesso non vengono proprio eseguite. Hanno senso solo su
un ruolo che non ha quel privilegio.)*

**Poi la separazione vera, insieme ai ruoli.** Ogni dato impara a quale associazione appartiene,
e le 142 regole di accesso vengono riscritte. Nello stesso passaggio entrano i ruoli nuovi,
perché toccano le stesse regole e riscriverle due volte è lavoro e rischio raddoppiati.

I ruoli si fanno come **permessi**, non come lista: con una lista, fra due anni sono ventisette.
A schermo però restano cinque combinazioni già pronte — presidente, amministratore, segreteria,
istruttore, socio — e nessuna matrice da compilare.

The Crew diventa l'associazione numero uno **come tutte le altre**: nessuna scorciatoia nel
codice, nessuna modalità speciale. La prima eccezione è quella che uccide il prodotto in silenzio.

**Come si sa che è finito, e non è a occhio.** Una prova automatica tenta, per ogni singola
tabella, di leggere, scrivere e cancellare i dati di un'altra associazione, e deve fallire
sempre. Settantaquattro tabelle per quattro operazioni. Finché quella prova non è tutta verde,
il lavoro non è finito — indipendentemente da come sembra.

**Poi pronti a consegnare.** Il tasto che scarica tutta l'associazione in un file, ben visibile.
L'abbonamento scaduto che mette in sola lettura senza cancellare niente. Il controllo che le
funzioni mai usate siano spente. E il manuale di attivazione, su cui vedi più avanti: è più
importante di quanto sembri.

**I verbali dell'assemblea vengono dopo il primo cliente.** Convocazione, approvazione del
rendiconto, rinnovo delle cariche: documenti già riempiti con i dati veri, da stampare e firmare,
con solo il risultato essenziale che rientra nel sistema — approvato o no, le nuove cariche, la
data. Non un modulo da compilare a schermo, che nessun presidente compilerebbe.

Vengono dopo perché il primo cliente è un commercialista che i verbali se li fa da sé. Servono
invece **prima di presentarsi alle federazioni**, ed è lì che diventano urgenti.

---

## Il percorso legale

**Il veicolo.** La strada scelta è che venda la società del commercialista e all'autore vada una
quota come diritti d'autore. Sembra solida, ma regge solo se resta genuina, e questo impone tre
cose:

La royalty paga **il software**, non il lavoro. Attivazione, migrazione dei dati e assistenza ai
presidenti sono servizi, e i servizi riporterebbero dritti dentro il problema
dell'incompatibilità: li eroga chi vende, non l'autore.

Si concede in **licenza**, non si cede il diritto. Cedere significa incassare una volta e perdere
l'asset. È una riga di contratto e vale tutto il progetto.

Va scritta la **catena delle responsabilità sui dati**: chi vende è la società, chi opera il
database è un altro soggetto, e i dati sono dei soci di associazioni terze. Titolare,
responsabile e sub-responsabile vanno definiti per intero, e serve una nomina scritta per ogni
cliente.

**Un effetto collaterale che vale molto.** Il rischio più grave dell'intero progetto era che una
persona sola, con un lavoro a turni, non regge l'assistenza a centinaia di associazioni. Nessuna
scelta tecnica lo risolve. Lo risolve questa struttura — ma **solo se il processo di attivazione
è scritto abbastanza bene da essere eseguito da qualcun altro**. Finché resta nella testa di chi
l'ha inventato, il problema non è risolto: è nascosto.

Per questo il manuale operativo di attivazione non è documentazione, è una delle cose che tengono
in piedi il modello.

**Nel contratto col cliente** vanno: dove stanno i dati, l'esportazione completa garantita, cosa
succede se il servizio si ferma, e un tempo di risposta dichiarato e onesto — due giorni
lavorativi, non il telefono la sera. Il deposito del codice presso terzi è stato valutato e
scartato: troppo pesante per questo prezzo, e il tasto di esportazione più una clausola di
continuità coprono quasi tutto.

---

## Il percorso commerciale

**Adesso: due o tre associazioni in prova.** Pagano un forfettario, si impegnano a usarlo davvero
e a segnalare i problemi. È la fase in corso al 17/09/2026: il documento di invito è pronto ed è
stato messo in PDF per essere girato.

Il patto è scritto: ricevono il gestionale completo, i dati caricati a mano, la copia di
sicurezza notturna, le funzioni nuove senza aggiungere nulla, e i dati scaricabili in qualunque
momento. In cambio si chiede di usarlo sul serio, di segnalare anche le sciocchezze, e soprattutto
di dire quando una cosa è **scomoda** — perché un errore si trova anche da soli, prima o poi,
mentre una scomodità la vede solo chi lo usa tutti i giorni.

Ed è dichiarato anche cosa **non** si promette: che non ci siano errori, che la risposta arrivi
in giornata, che ogni richiesta venga realizzata.

**Poi il primo cliente pagante vero**, che è il commercialista stesso — presidente di
un'associazione ultracentenaria, e insieme il canale.

**Poi le federazioni**, che non comprano: mettono in contatto con molte associazioni insieme.
Prima di arrivarci servono i verbali dell'assemblea, perché è esattamente quello che il canale
sta già promettendo.

**Il rischio più commerciale di tutti**, ed è già presente: la promessa del canale corre più
veloce del prodotto. Si sta dicendo in giro che è l'unico gestionale che automatizza la burocrazia
del presidente, mentre i verbali d'assemblea hanno zero righe in produzione. Prima che un cliente
pagante senta quella frase, al canale va data una versione della promessa che regge oggi. Costa
una conversazione e non si può rimandare.

**Sul prezzo.** Il riferimento è circa 300 euro l'anno, incassati anticipati per l'anno intero —
risolve la cassa e azzera l'abbandono per dodici mesi — più un costo di attivazione separato, che
oltre a pagare il lavoro manuale serve a filtrare chi non è convinto e genererebbe solo assistenza.

Se quel prezzo sia giusto **non si decide a tavolino**: si misura contando le ore di assistenza
spese sul primo cliente per sei mesi. Venti ore l'anno e trecento euro è sottocosto; tre ore e il
margine è buono. Un parere esterno ha insistito per alzarlo subito: la cifra però viene
dall'osservazione diretta di come ragiona un presidente di ASD piccola, che è il vantaggio
competitivo del progetto — non si scavalca con la logica generale del software a canone, si
verifica con i numeri.

---

## Le associazioni in prova entrano dopo il lavoro, non prima

Deciso il 17/09/2026, correggendo l'ipotesi della mattina. Le associazioni in prova non hanno
fretta di entrare, quindi **non serve aprire istanze separate** da fondere in seguito: si fa prima
la separazione dei dati, e loro entrano direttamente nel sistema definitivo come associazione
numero tre, quattro e cinque.

Sparisce così l'unico compromesso che il piano aveva. E si guadagna una cosa che vale di più: il
loro ingresso diventa **la verifica vera** del lavoro di separazione — associazioni reali, dati
reali, persone che non siamo noi.

**Ma quella verifica non può essere la prima.** Se l'isolamento cede mentre dentro ci sono i soci
di due associazioni vere, non è un difetto da correggere: è una violazione di dati personali da
notificare, ed è la fine del canale di vendita. L'ordine delle prove è quindi:

1. **La prova automatica**, su tutte e settantaquattro le tabelle: tentare di leggere, scrivere e
   cancellare i dati di un'altra associazione, e fallire sempre. Tutta verde prima di proseguire.
2. **Un'associazione finta come numero due**, con dati inventati, usata davvero per qualche
   giorno — incassi, ricevute, scadenze, un verbale confermato. È il metodo di collaudo già in uso
   qui (dati finti nel database reale, poi rimossi), applicato al livello superiore.
3. **Le associazioni vere**, che provano l'unica cosa che nessun collaudo artificiale può provare:
   che il sistema regge in mano a chi non l'ha scritto.

Se l'isolamento cede al punto 2 costa un pomeriggio. Al punto 3 costa il progetto.

**Quello che invece comincia subito, senza aspettare il codice.** La raccolta dei loro dati — con
quale ente sono affiliati, l'elenco dei soci in qualunque forma, a che numero sono con le ricevute
dell'anno, i corsi, le quote, il logo — è la parte più lenta dell'attivazione e non dipende da una
riga di programma. Si manda l'invito adesso, si comincia a raccogliere, e il materiale è pronto
quando lo è il sistema. Nell'invito va detto chiaramente **quando** si parte, altrimenti
l'interesse si raffredda nell'attesa.

## Regole operative che valgono sempre

Da qui in avanti, su ogni riga di codice nuova: **si scrive come se l'associazione fosse già un
parametro**. In particolare è vietato creare nuove tabelle a riga unica o a chiave globale — sono
esattamente le cinque che oggi costituiscono tutto il debito del modello dati, e non vanno
aumentate.

Nessuna eccezione per The Crew nel codice. Nessuna modalità speciale, nessun controllo sul nome
dell'associazione.

I dati non si cancellano mai. Abbonamento scaduto significa sola lettura con l'esportazione
sempre disponibile, non rimozione.

Le ore di assistenza si contano dal primo cliente, sempre. È l'unico dato che manca per sapere se
il modello economico regge, e non si recupera a posteriori.

---

## Cosa resta fuori, dichiarato

L'attivazione autonoma del cliente è **fuori ambito**, non rimandata. Caricare un libro soci
disordinato e far ripartire la numerazione delle ricevute a metà anno senza che nessuno controlli
significa sbagliare i registri fiscali di qualcun altro. Si automatizza solo un processo manuale
già fatto bene molte volte, e servono almeno dieci attivazioni a mano per sapere quali passi
automatizzare.

Fuori anche: colori e grafica liberi (il logo sì, e alcune combinazioni già verificate);
WhatsApp, che si paga a messaggio e richiede una verifica per ogni ente; l'app da scaricare, visto
che il sito funziona già bene dal telefono; tornelli e controllo accessi; e un cruscotto
trasversale per i canali, finché non lo chiede qualcuno che paga.

---

## Dove siamo al 17/09/2026

Il documento di invito ai betatester è pronto e in PDF. Il piano tecnico è scritto per intero. Il
veicolo legale è deciso nella forma ma va confermato dal commercialista. Nessuna riga di codice
del percorso è ancora stata scritta.

**Il prossimo passo** è quello che si fa in giornata e non dipende da nessuna decisione: il
controllo sugli invii fermi e il mittente di posta vero.

---

## Dove sta il resto

- **Piano tecnico dettagliato, con i numeri**: `docs/MULTICLIENTE.md` nel repo `the-crew`
- **Report tecnico** (scritto per farsi criticare da fuori): https://claude.ai/artifact/LJEbfNviLd1WAry8zkrBor
- **Riepilogo semplice interno** (come funziona, il lavoro, chi prende cosa): https://claude.ai/artifact/7e9Daw6QyKGgTV1e1678it
- **Invito ai betatester** (niente cifre, niente struttura commerciale): https://claude.ai/artifact/TwZBMREgi3a68ZT7GkPsSD — PDF in `~/Downloads/Crew-in-prova.pdf`
- **Scheda del progetto**: `the-crew.md` in questa cartella
- **Ipotesi prodotto di agosto**, superata da questo file ma utile per i numeri del 19/08:
  `the-crew-brief-prodotto-b2b.md`
