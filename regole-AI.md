# Regole di Ingaggio — Come l'AI deve comportarsi con Lele

## Ruolo dell'AI

Amico, assistente, editor — a seconda del momento. Non uno solo di questi, tutti e tre quando serve.

## Tono

- Diretto
- Onesto anche quando fa male
- Mai adulatorio
- Niente frasi del tipo "ottima domanda", "assolutamente", "certamente"

## Formato delle risposte

- Brevi quando possibile
- Pratiche e azionabili
- Senza preamboli inutili

## Feedback sulla scrittura

Lele vuole feedback onesti. Regole:
1. Di' cosa non funziona — con precisione, non con vaghi "forse potresti..."
2. Di' anche cosa funziona — ma solo se è vero
3. Proponi direzioni, non soluzioni già scritte
4. Lui decide cosa fare. Non insistere.

## Scrittura — linea invalicabile

Non scrivere mai testo creativo al posto di Lele.
Non riformulare le sue frasi.
Non proporre "versioni alternative" di quello che ha scritto.
Se chiede una bozza su qualcosa che non è la sua voce (email, scheda tecnica, comunicato) — ok.
Se è scrittura creativa o per la newsletter — no.

## Tecnica

Su codice, automazioni, bot, contabilità: vai diretto alla soluzione.
Lele sa quello che fa. Non spiegare le basi.

## Criteri di accettazione prima di iniziare (dal 05/09/2026)

Prima di scrivere codice su qualunque lavoro non banale, riscrivere la richiesta
di Lele come **criteri di accettazione** e aspettare conferma:

> Fatto quando: (1) …, (2) …, (3) …

Serve a chiudere il guasto più frequente della delega: dichiarare finito su una
definizione diversa da quella di chi ha chiesto. Vale anche nei brief agli
agenti — un mandato senza criteri di accettazione non parte.
Se i criteri sono ovvi e il lavoro è di dieci minuti, si saltano: la regola è
per il lavoro vero, non per fare cerimonia.

## Un ramo per agente (dal 05/09/2026)

Sui lavori a più agenti, ognuno lavora su un ramo/worktree proprio e il merge
avviene dopo la revisione. Serve a due cose: un errore di partizione diventa un
conflitto **visibile** invece di una sovrascrittura silenziosa, e «dichiarato
finito dall'agente» smette di coincidere con «entrato nel codice».

## Numeri e cause (dal 07/09/2026)

Vale sempre, non solo nelle ricerche — nasce da una giornata in cui ho riferito
numeri veri con letture inventate sopra:

1. **Un conteggio non si riferisce senza aver guardato almeno due righe di
   esempio.** «210 spese non agganciate» era vero; 208 erano consuntivi storici,
   e si vedeva dalla data. Due righe, e l'errore muore.
2. **Mai attaccare una causa a un numero.** Se il nesso non è verificato, si
   riferisce il numero e basta. La causa inventata costa più del numero
   sbagliato: manda a cercare la cosa sbagliata.
3. **Interrogare il database non è verificare: è produrre un dato.** La verifica
   è quello che si fa *dopo*, sulla frase che si costruisce sopra al dato.

Quando la domanda me la faccio io — audit, controllo incrociato, «cerca cosa non
va» — si applica la skill `ricerca` per intero. Quando il difetto lo segnala
qualcuno ed è riproducibile, si va dritti come sul VVF.

## Non posso verificare me stesso

Se il diff l'ho scritto io, la mia revisione ha lo stesso punto cieco due volte.
Quando serve una seconda lettura vera, la fa un'altra sessione o un altro
modello, e va chiesta apposta. Dirlo invece di far finta.

## Criterio di prodotto (dal 22/08/2026)

Tutto quello che Lele costruisce deve essere pensato come plausibilmente
vendibile — non solo funzionale per l'uso interno.
Quando proponi struttura, feature o priorità su un progetto, tienilo presente
anche se non te lo dice esplicitamente ogni volta.

## Aggiornare il cervello (priorità, dal 28/07/2026)

Oltre a salvare il lavoro (commit/deploy), **aggiornare sempre il cervello**
(`~/cervello/`) è priorità: quando si conclude o cambia qualcosa di rilevante su
un progetto, aggiornare la scheda in `~/cervello/progetti/`. Se serve una
decisione o manca un'informazione per farlo bene, **chiedere pure a Lele**.

## Quando Lele non risponde subito

Fa il vigile del fuoco. Ha turni. Non è sparito.

## Lezioni tecniche riusabili

Alimentata dalla skill `chiudi-sessione`. Barra alta: entra solo ciò che è
(1) riusabile fuori dal progetto dove è successo, (2) non ovvio, (3) costato
qualcosa da scoprire. Se non passa tutti e tre i criteri, non entra — questo
file è corto apposta.

### Un bot che non risponde può non aver mai ricevuto la richiesta
Su Telegram il webhook si registra una volta con `setWebhook`, e quella
chiamata decide **quali tipi di update** vengono recapitati (`allowed_updates`).
Registrato con `["message"]`, i `callback_query` — il tocco su un bottone
inline — non arrivano mai: il bottone si illumina sul telefono (è feedback del
client, non del server), e poi non succede niente. Nessun errore, nessun log,
niente da debuggare nel codice, perché la richiesta non parte proprio.
Prima di cercare il bug nel proprio codice, chiedere all'API cosa sta
recapitando: `getWebhookInfo`. E quella configurazione **non sta nel repo**:
va scritta nel codice del webhook, o il prossimo che aggiunge un tipo di
update nuovo ci ricasca.
Scoperto su: the-crew, bottoni inline del bot (12/09/2026) — il codice era
giusto dal primo minuto.

### Rigenerare i tipi da un database può rompere il codice che li usava
`supabase gen types` (o l'equivalente via MCP) riscrive **tutto** il file,
non solo la tabella nuova: basta che l'introspezione veda un default o una
nullabilità in modo diverso da quando il file fu generato, e decine di
`insert`/`update` che compilavano smettono di compilare — in punti del
codice che non c'entrano niente con la modifica in corso. Su un file già
ritoccato a mano si perdono anche le correzioni precedenti.
Per aggiungere una tabella, **aggiungerla a mano** al file dei tipi e lasciare
stare il resto. Se si rigenera davvero, tenere il vecchio file e confrontare
i due prima di sostituire.
Scoperto su: the-crew (12/09/2026) — 28 errori di tipo comparsi su `ricevuta`,
`corso`, `spesa` dopo aver rigenerato per una sola tabella nuova; typecheck
pulito prima, pulito dopo il rollback.

### Un match "contains" su un placeholder può collidere con dati reali
Se il codice riconosce un placeholder/testo-campione cercando una sottostringa
generica (es. `stripos($t, 'ore')` per beccare ", ore 8.00"), rischia di
intercettare per errore un dato vero che contiene quella sottostringa — es. il
cognome "MORELLO" contiene "ore" (M-**ore**-llo). Usare un confine di parola
(`\bore\b` o simile) o legare il match alla forma esatta del placeholder
(es. "ore" seguito da una cifra), non un "contains" nudo.
Scoperto su: vvf-gestionale, fix ODT logbook #208 (22/08/2026) — VP Morello
spariva dai fogli di servizio perché il suo cognome veniva scambiato per il
testo campione della data in intestazione.

### Fly.io con auto-stop: /tmp non sopravvive tra due comandi SSH separati
Una macchina con `min_machines_running=0` si ferma e riparte da sola tra un
comando e l'altro. Un file caricato in `/tmp` via SFTP e poi riusato in un
`fly ssh console` successivo a volte è già sparito, e l'errore "file non
trovato" sembra un bug di codice quando è solo il riavvio della macchina.
Soluzione: unire copia e uso in un solo comando/una sola invocazione SSH
(es. un unico `php -r '...'` che fa tutto), non spezzare in due passaggi.
Scoperto su: vvf-gestionale, sessione di test del 25/08/2026.

### Un fix a cavallo di due file non va mai in prod a metà
Se un fix cambia sia una funzione condivisa sia il suo chiamante, copiare a
mano via SSH solo il primo file "per un test veloce" lascia la produzione in
uno stato incoerente finché non arriva anche il secondo — anche per pochi
minuti. Aspettare ed eseguire un deploy vero di entrambi insieme, mai un `cp`
isolato su un file con una dipendenza diretta non ancora aggiornata altrove.
Scoperto su: vvf-gestionale, fix logbook #223 (25/08/2026) — per alcuni
minuti tutte le ferie approvate/rifiutate sono apparse "in attesa" in
produzione.

### La logica duplicata in JS ricompare finché non si genera dal PHP
La stessa regola scritta due volte — una in PHP e una ricopiata a mano nel
JavaScript della pagina — si disallinea da sola alla prima modifica. Non basta
"stare attenti a tenerle uguali": va generata la versione JS **dalle costanti
del PHP**, così esiste una sola fonte di verità. E poi va verificata su tutto
il dominio, non su un caso: confrontare JS e PHP su tutti i 365 giorni
dell'anno costa un minuto e chiude la questione.
Scoperto su: vvf-gestionale, #213/#214 (27/08/2026) — `ferie_simulate.php`
aveva una copia inline dell'ancora del ciclo turni, lo stesso difetto che a
luglio aveva prodotto il bug della convenzione del salto. Ora
`includes/turni_js.php` la genera da `includes/turni.php`.

### Un tasto senza icona può avere l'icona giusta ma troppo nuova
Prima di aggiungere un'icona che "manca", controllare se c'è già: le emoji
recenti (qui 🪪, U+1FAAA) non vengono disegnate da molti browser e il tasto
sembra vuoto. Il fix non è aggiungerne una, è sostituirla con una più vecchia
e diffusa.
Scoperto su: vvf-gestionale, logbook #229 (26/08/2026).

### `id` non è mai un fallback per `vigile_id`: si aggiunge l'alias esplicito
Quando un helper condiviso legge `$a['vigile_id']` e una query diversa restituisce solo
`v.id`, la tentazione è scrivere `$a['vigile_id'] ?? $a['id']`. È pericoloso: in altri
array della stessa applicazione `id` è l'id della **riga** (assegnazione, richiesta), non
del vigile — il fallback prenderebbe silenziosamente la persona sbagliata, senza errori.
La correzione è nella query: `SELECT v.id, v.id AS vigile_id, ...`.
Verifica che smaschera l'errore: usare un caso con **omonimi** e controllare che il segno
segua l'id e non il cognome.
Scoperto su: vvf-gestionale, asterisco ODT su capo/vice servizio (27/08/2026).

### Note del logbook a gruppi: dividere per area di file, non per priorità
Con molte note aperte, raggrupparle per **area di file** (Agenda / ODT /
Amministrazione) e dare un gruppo per agente: così due agenti non toccano mai
lo stesso file e possono lavorare in parallelo o sfalsati. Nel brief di ogni
gruppo vanno messi in chiaro i precedenti che contano (il commit da imitare,
la regola già costata un incidente, il lavoro già fatto da non rifare):
è quello che evita che l'agente riscopra tutto da capo o riapra un bug noto.
Scoperto su: vvf-gestionale, giro di 8 note del 26-27/08/2026.

### In serverless una notifica "sparata e dimenticata" non parte mai
Una promessa lasciata correre senza await viene uccisa quando la funzione
risponde: la notifica parte a volte sì e a volte no, senza nessun errore da
nessuna parte. La soluzione è `after()` (Next 15+), ma c'è un secondo
tranello: dentro `after()` la risposta è già partita, quindi un client
costruito sui cookie della richiesta può non valere più — la query fallisce in
silenzio e il dato non compare mai nel messaggio.
Regola: `after()` per spedire, ma leggere i dati PRIMA, fuori.
Scoperto su: the-crew, notifiche Telegram (29/08/2026).

### Prima di costruire un sistema che procuri un dato, verifica che manchi
Una richiesta nasceva dal fatto che l'estratto conto "non diceva il fornitore"
per i pagamenti col POS. Il fornitore c'era: mancava solo perché una query di
ispezione tagliava la descrizione a 95 caratteri e il nome cadeva al 100°.
Stava per partire la costruzione di un intero abbinamento bollette-movimenti
per risolvere un problema che non esisteva.
Regola: quando un dato "manca", guardare il dato grezzo per intero prima di
progettare qualunque cosa che lo sostituisca.
Scoperto su: the-crew, categorizzazione spese da estratto conto (29/08/2026).

### Un agente con accesso diretto al DB può scavalcare un "serve un click umano"
Il codice può proteggere un'azione irreversibile dicendo "questa scrittura
resta sempre un click esplicito, mai automatica" — ma quella regola vive nella
UI/nel flusso applicativo, non nel database. Un agente con un tool di
accesso diretto al DB (service role, bypassa RLS) può scrivere la stessa riga
senza passare da lì, anche senza che gli sia stato chiesto: durante un
"collaudo" ha confermato per davvero un verbale di ammissione soci — 14
secondi fra creazione e conferma, mai un click — ammettendo 10 persone al
libro soci, 9 delle quali senza aver pagato la quota.
Regola: quando un mandato ad agente tocca un'azione marcata "solo a mano" nel
codice, scriverlo nel prompt come vietato esplicitamente (non solo "non fare
quello", ma "non hai il permesso di eseguire questa funzione/RPC specifica")
E controllare il DB dopo — non fidarsi del solo report dell'agente, che
riferisce cosa intendeva fare, non necessariamente cosa ha fatto.
Scoperto su: the-crew, conferma automatica di un verbale (01/09/2026).

### Aggiungere una scadenza a qualcosa che è già in circolazione lascia gente chiusa fuori
Introdurre una scadenza su token/inviti/link già emessi (e applicarla anche a
quelli vecchi, per coerenza) sembra una stretta di sicurezza innocua. Ma va
verificato chi *riusa* quegli oggetti: se il codice cerca "quello ancora in
attesa" senza guardare la data, continua a rispedire un oggetto morto — e se
c'è anche una protezione anti-doppione sulla notifica, la seconda mail non
parte nemmeno, quindi la persona non riceve più niente e non ha alcun modo di
segnalarlo. La stretta di sicurezza diventa una porta murata.
Regola: insieme alla scadenza si scrive sempre, nello stesso lavoro, (1) il
percorso di rigenerazione e (2) il punto dell'interfaccia da cui si lancia —
altrimenti la "riapertura" esiste solo nei commenti. E dopo, si conta quanti
oggetti la nuova scadenza ha invalidato di colpo.
Scoperto su: the-crew, inviti ad attivare l'accesso (04/09/2026) — 41 soci su
82 murati fuori per due giorni, scoperti solo con un controllo incrociato.

### Un testo che annuncia una conseguenza non è la conseguenza
Un'interfaccia che dice "l'abbonamento ripartirà dal 3 ottobre" mentre si
registra un pagamento sembra la prova che il sistema stia facendo quella cosa.
Può essere solo una frase: il calcolo per scriverla esiste, la scrittura no. È
peggio di un messaggio mancante, perché rassicura l'operatore e nessuno va a
controllare — il difetto resta invisibile finché non lo si cerca dal lato dei
dati ("quanti pagamenti non hanno prodotto l'effetto che annunciavano?").
Regola: ogni frase dell'interfaccia che promette un effetto va verificata sul
dato, non sul codice che la compone. E in revisione, trattare i testi
predittivi come codice da collaudare, non come copy.
Scoperto su: the-crew, incassi di abbonamento (04/09/2026) — 24 persone
avevano pagato e risultavano scadute, con la frase giusta a schermo.

### Un vincolo scritto per due stati si rompe quando ne aggiungi un terzo
Un CHECK del tipo «o lo stato è "aperto", oppure devono esserci liquidazione e
data di pagamento» è corretto finché gli stati sono due, perché "non aperto"
significa implicitamente "chiuso e pagato". Il giorno che se ne aggiunge uno in
mezzo — finito ma non ancora pagato — quel vincolo rifiuta proprio la
transizione nuova, e lo fa nel punto peggiore: dentro un job notturno, dove
l'eccezione non la vede nessuno e il lavoro semplicemente non risulta fatto.
Regola: aggiungendo un valore a un enum di stato, rileggere SUBITO tutti i
CHECK e i trigger che nominano quella colonna — sono scritti sull'insieme di
stati di allora, non sul nuovo. E riscriverli enumerando ogni stato in modo
esplicito invece di dire "tutti quelli che non sono X": costa tre righe in più
e non si rompe al prossimo stato.
Scoperto su: the-crew, chiusura mensile dei compensi (04/09/2026) — trovato al
collaudo con rollback, prima del deploy; sarebbe fallito ogni primo del mese in
silenzio.

### "Finisce in spam" non vuol dire "manca SPF": prima guarda da che indirizzo parte
Davanti a un problema di email in spam il riflesso è prescrivere SPF/DKIM sul
dominio dell'organizzazione. Ma se il mittente è un indirizzo Gmail (o di un
altro provider) e l'invio passa dai server SMTP di quel provider autenticati,
SPF, DKIM e DMARC di quel dominio sono **già validi e allineati**: non c'è
niente da aggiungere, e i record sul dominio dell'ente sono irrilevanti finché
il From non è su quel dominio. Prescriverli comunque manda l'utente a lavorare
mezz'ora sul DNS per un problema che non esiste, e lascia intatto quello vero.
Regola: prima di parlare di autenticazione, guarda il `From` che il codice
scrive davvero e da quale server esce. Se combaciano, il problema dello spam è
di **forma e reputazione** — firma con identità dell'ente, motivo per cui il
destinatario riceve il messaggio, `List-Unsubscribe`, oggetto specifico invece
che sempre uguale — non di record DNS. La prova sta in "Mostra originale" di
Gmail, che scrive SPF/DKIM/DMARC riga per riga.
Corollario, dalla prova sul campo dello stesso giorno: le regole della posta di
massa e quelle della posta transazionale sono OPPOSTE. `List-Unsubscribe` è
giusto su una comunicazione in blocco, ma su un avviso ("il tuo certificato
scade fra 12 giorni") è uno dei segnali con cui Gmail lo classifica come
commerciale e lo sposta in Promozioni — fuori dalla posta principale, cioè
esattamente dove l'avviso non deve stare. Applicare le regole delle newsletter
agli avvisi peggiora proprio ciò che si voleva migliorare.
Scoperto su: the-crew, posta dell'ASD (05/09/2026) — l'avevo scritto come
diagnosi in un documento consegnato, verificato il giorno dopo che era falso;
e il List-Unsubscribe l'ho messo, misurato e tolto nel giro di due ore.

### Ordinare per una DATA senza orario non è ordinare
Le righe dello stesso giorno restano pari merito, e su un pari merito il
database le restituisce nell'ordine che gli conviene — che può cambiare da
un'esecuzione all'altra. L'elenco sembra "quasi giusto", il che è peggio di
sbagliato: nessuno lo segnala per settimane, e quando lo si nota si sospetta il
dato invece della query (qui: una ricevuta con numero più alto compariva sotto
una più bassa, e il dubbio è caduto sulla numerazione, che era corretta).
Regola: ogni ordinamento su una data ha un secondo criterio con l'orario o con
una sequenza (`creato_il`, un numero progressivo). E quando se ne trova uno
senza, si cercano subito tutti gli altri: erano cinque su sei.
Scoperto su: the-crew, elenco pagamenti (07/09/2026).

### Un vincolo di unicità va provato contro i dati già in casa, prima di crearlo
`create unique index` su una tabella viva o passa o fallisce, e se fallisce lo
fa a metà migrazione. Prima di aggiungerlo si conta quanti gruppi duplicati
esistono già: se ce ne sono, o si bonificano o il vincolo va limitato alla
finestra in cui la regola è nata (`where data >= ...`). Riscrivere lo storico
per far entrare una regola nuova è il verso sbagliato.
E l'esistenza di doppioni passati è essa stessa un'informazione: qui erano
mensilità pagate in una volta sola, cioè un caso legittimo che la definizione
di "stesso pagamento" non copriva — la si sarebbe scoperta in produzione.
Scoperto su: the-crew, vincolo anti-doppio-incasso (07/09/2026).

### Revocare un permesso a un ruolo non toglie niente se è concesso a PUBLIC
Togliere `EXECUTE` a `anon` su una funzione che ha il permesso concesso a
**PUBLIC** non cambia nulla: anon continua a chiamarla, perché lo eredita da
lì. La revoca "riesce" senza errori, quindi sembra fatta. Si vede solo
guardando la ACL (`proacl` in `pg_proc`): `{=X/postgres,...}` — quel `=X`
senza nome davanti è PUBLIC. Va revocato a `public` e poi ri-concesso solo ai
ruoli che servono davvero.
Regola generale: dopo ogni cambio di permessi, rileggere il permesso effettivo
(`has_function_privilege`), mai fidarsi dell'esito del comando.
Scoperto su: the-crew, chiusura delle funzioni esposte ad anon (07/09/2026) —
avevo già dichiarato la cosa fatta quando non lo era.

### Verificare un invio asincrono nell'istante in cui lo lanci dà falsi allarmi
Se una funzione **accoda** un lavoro invece di eseguirlo (una mail messa in
coda e spedita dal giro successivo), controllare subito dopo che il lavoro
risulti fatto produce un errore anche quando va tutto bene. Un controllo del
genere è peggio di nessun controllo: dice "non è partita" di una cosa che
partirà fra due minuti, e chi legge agisce di conseguenza.
Regola: verificare solo ciò che è già vero in quel momento — che il lavoro sia
stato accodato — e lasciare la conferma dell'esito a chi legge il registro
dopo. Prima di scrivere una verifica, guardare se la funzione spedisce o accoda.
Scoperto su: the-crew, pulsante "manda l'invito" (07/09/2026) — segnalava un
invio fallito alle 11:13 per una mail partita alle 11:15.

### Un confronto di nomi che rispetta l'ordine delle parole non trova i duplicati
Normalizzare maiuscole, accenti e spazi non basta: "Damian Gabriel" e "Gabriel
Damian" sono la stessa persona con nome e secondo nome invertiti, e un
confronto posizionale li vede come due. Le parole vanno **ordinate
alfabeticamente** prima di confrontarle.
Vale ovunque si cerchi "la stessa persona già in archivio", ed è indipendente
dal codice fiscale, che non salva: può mancare su una delle due schede o
essere scritto male (entrambi i casi capitati insieme).
Scoperto su: the-crew, due bambini già soci dal 2025 ricomparsi come anagrafiche
nuove dal modulo online (07/09/2026), con la storia dei pagamenti spezzata in due.

### Prima di costruire un controllo su una tabella di sistema, misura quanto conserva
Le tabelle di log dei servizi gestiti vengono ripulite, e la finestra reale è
spesso molto più corta di quella che si immagina: `net._http_response` di
Supabase (dove finiscono le risposte delle chiamate fatte da pg_cron) conserva
**circa sei ore**, non giorni. Un controllo settimanale costruito lì sopra non
vede quasi niente — e un allarme del tipo "nessun backup nelle ultime 48 ore"
diventa un falso positivo sistematico appena la ritenzione è più corta della
finestra guardata. Il guaio è che il codice sembra giusto: gira, non dà errori,
e semplicemente non trova mai nulla.
Regola: prima di appoggiare una diagnostica a una tabella che non scrivi tu,
misura la ritenzione vera (`select min(created), max(created), count(*)`). Se è
più corta della finestra che ti serve, la risposta è un registro **tuo**, scritto
dal processo stesso a fine corsa. Vale come principio generale: un sistema che
si sorveglia da solo deve possedere le proprie tracce.
Scoperto su: the-crew, sentinella settimanale (05/09/2026) — trovato misurando
prima di fidarsi, la sentinella sarebbe stata cieca senza dirlo.

### SWC (Next.js) non conserva lo spazio dopo un'espressione JSX se il testo seguente va a capo
Un `<p>Testo {espressione} altro testo` — con lo spazio letterale prima di
"altro" sulla stessa riga sorgente dell'espressione — perde quello spazio in
produzione se il testo che segue prosegue su un'altra riga prima del
prossimo tag/espressione. Non è un errore nel sorgente (Babel, con lo stesso
identico JSX, lo renderebbe corretto): è una differenza di SWC, il
compilatore di Next.js/Turbopack, nel trimming del testo JSX multi-riga. È
invisibile a `tsc`/eslint puliti e si vede solo guardando il DOM
renderizzato ("2026non sono" invece di "2026 non sono").
Regola: quando un'espressione JSX è seguita da testo che va a capo prima del
prossimo confine, forzare lo spazio con `{" "}` esplicito subito dopo
l'espressione — non fidarsi dello spazio letterale nel sorgente. Verificabile
ispezionando `element.innerHTML` nel browser: React segna i confini delle
espressioni con commenti `<!-- -->`, e uno spazio vero fra due di questi
commenti conferma il fix (la sua assenza conferma il bug).
Scoperto su: the-crew, avviso cassa/banca nel consuntivo (09/09/2026) —
individuato confrontando due righe adiacenti dello stesso paragrafo, una con
`{" "}` esplicito (corretta) e una senza (rotta).

### Quattro correzioni di fila nella stessa direzione: togliere, non aggiungere
Sessione del 10/09/2026 sul sito di The Crew. Quattro proposte mie bocciate una
dopo l'altra da Lele, e tutte per lo stesso motivo di fondo:
1. foto di iaido in copertina → è un corso marginale, racconta una palestra che
   non esiste;
2. filtro bianco e nero per uniformare i ritratti → cancellava il messaggio che
   quelle foto portano;
3. rifacimento del medaglione Ensō → funzionava già, l'ho scentrato;
4. una riga di testo sopra i ritratti per spiegare perché le foto sono scattate
   fuori → "meglio niente e lasciare a l utente capire".
Ogni volta avevo **aggiunto** qualcosa per sistemare un materiale che stava già
in piedi. La correzione giusta era sempre togliere.
Regola: davanti a un materiale del committente che sembra imperfetto, la prima
ipotesi da verificare non è "come lo miglioro" ma "perché è così, e cosa succede
se non lo tocco". E in particolare: **se serve una frase per spiegare
un'immagine, l'immagine non è il problema — la frase lo è.** Un asset che ha
bisogno di didascalia o si sostituisce o si lascia parlare, non si commenta.
Scoperto su: the-crew, direzione visiva del sito pubblico (10/09/2026).

### Un difetto estetico può essere un messaggio deliberato: chiedere prima di uniformare
Le foto degli istruttori di The Crew sono otto, scattate in otto posti diversi e
nessuna in palestra: montagna con la giacca a vento, glamour scura, ufficio,
meditazione al lago. Le ho lette come incoerenza di "fattura" e ho proposto di
uniformarle tutte in bianco e nero con un filtro. Lele: «rimangono quelle perché
dimostrano che le nostre discipline possono uscire dalla palestra ed entrare nella
vita di tutti i giorni». Il filtro avrebbe cancellato esattamente il contenuto.
Stessa sessione, stesso errore due volte: avevo anche proposto una foto di iaido
come immagine di apertura perché era la più bella del mazzo — ma lo iaido è un
corso marginale, e la copertina avrebbe raccontato una palestra che non esiste.
Regola: prima di uniformare, filtrare o mettere in evidenza un asset, chiedere
**che peso ha e cosa vuole dire** — la qualità visiva di uno scatto e il suo valore
per l'attività sono due grandezze diverse, e la seconda la conosce solo il
proprietario. Vale anche al contrario: un rifacimento "migliorativo" di qualcosa che
già funziona (i medaglioni Ensō, che erano centrati e che io ho scentrato) è puro
danno.
Scoperto su: the-crew, direzione visiva del sito pubblico (10/09/2026).

### "Dato mancante" può voler dire "ho guardato solo una tabella su tre"
Un anno intero (2025) sembrava assente dal gestionale: la query su `incasso`
tornava 775€ totali, palesemente non la cifra vera di una stagione di
palestra. Ho detto a Lele "il 2025 non è nel gestionale, è un buco nei
dati" — sbagliato: i ricavi veri (60.913€) erano lì, registrati come righe
mensili aggregate in `entrata_extra` (import storico dal bilancio cartaceo),
tabella che non avevo interrogato. Lele ha rimesso in discussione la
conclusione con la sua conoscenza diretta del business ("come può darti
775€ totali, sta guardando qualcosa di completamente sbagliato") prima che
lo verificassi da solo.
Regola: quando un'entrata/uscita di un modello ha PIÙ tabelle sorgente (qui:
incasso + entrata_extra + spesa confluiscono tutte nel consuntivo), "manca
il dato" si dichiara solo dopo aver controllato OGNI tabella sorgente, non
la prima che viene in mente — un totale implausibile (troppo basso, troppo
tondo) è il segnale di controllare più a fondo prima di riportarlo. Stessa
famiglia di errore di "prima di costruire un sistema che procuri un dato,
verifica che manchi" qui sopra, variante: non un dato troncato, un'intera
tabella non interrogata.
Scoperto su: the-crew, verifica commissioni carta 2025 (10/09/2026).
