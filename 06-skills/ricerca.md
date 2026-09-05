---
stato: attiva
versione: 1.0 — creata 2026-09-05
trigger: manuale ("ricerca", "verifica prima di decidere") o automatico quando
         una risposta porta a una decisione che costa soldi, tempo o obblighi
---

# Skill: Ricerca

## Obiettivo
Impedire che una conclusione **plausibile** venga scambiata per una conclusione
**verificata**, e che una ricerca finisca in archivio senza produrre una decisione.
È la regola «non fidarsi dell'esecutore, verificare il risultato» spostata dal
codice al ragionamento.

## Quando si applica
Solo quando la risposta porta a una decisione con un costo reale: denaro,
mesi di lavoro, obblighi di legge, un impegno preso con qualcuno.
Casi tipici: ASD a norma (fisco, statuto, contratti), il gestionale come
prodotto (prezzo, canale, concorrenza), scelte di fornitore o di piattaforma.

**Non si applica al codice.** Lì la verifica si fa guardando: si deploya, si
apre la pagina, si interroga il DB. Una domanda che si può risolvere guardando
non è una ricerca, e questa procedura sarebbe solo cerimonia.

## Cosa NON fa
- Non sostituisce la decisione: la prepara. Decide Lele.
- Non produce report lunghi. Il report è materiale di lavoro, non il risultato.
- Non entra nel vault per intero — vedi punto 5.

## Procedura

### 1. Partire dalla decisione, non dall'argomento
Prima riga sempre: **«devo decidere se ___»**, non «raccogli informazioni su ___».
Se la decisione non si riesce a scrivere in una frase, la ricerca non è ancora
pronta per partire: manca la domanda, non i dati.

### 2. Etichettare ogni affermazione che conta
Tre categorie, sempre distinte in modo esplicito nella risposta:
- **FATTO** — la fonte dice X. Con la fonte.
- **INFERENZA** — da A + B concludo X. È mia, non della fonte.
- **GIUDIZIO** — secondo me conviene X.

La confusione fra le tre è il difetto principale di qualunque AI su una ricerca,
me compreso: una catena di inferenze ragionevoli esce con lo stesso tono
sicuro del dato di partenza.

Regola sulle fonti, in una riga: **il livello della fonte va proporzionato al
tipo di affermazione.** Su una cifra o su una norma serve la fonte primaria
(legge, bilancio, dato ufficiale). Su cosa si lamentano gli utenti, un forum
vale più di un istituto di ricerca. Non esiste una gerarchia unica.

### 3. Contraddittorio — obbligatorio, non facoltativo
Seconda passata, sempre, prima di consegnare: **assumere che la conclusione sia
sbagliata e cercare le prove più forti contro**. Poi dire quale delle due tesi
regge meglio, e perché.

Questo passaggio esiste per un caso preciso: il 04/09/2026 una diagnosi su
SPF/DKIM è stata consegnata dentro un documento come se fosse verificata, ed
era falsa — smentita il giorno dopo dalla prova sul campo. Il costo di una
passata contraria è due minuti; quello di un documento sbagliato consegnato è
un lavoro rifatto e la fiducia bruciata.

### 4. Quando smettere
Non si smette quando il materiale è tanto. Si smette quando **una fonte nuova
non cambia più la decisione**. In concreto: le fonti primarie concordano, la
tesi contraria è stata esaminata, e ogni domanda decisiva ha una risposta.
Se dopo tre fonti la conclusione non si muove, è finita.

### 5. Chiudere con la scheda, non col report
Sempre questo formato, corto:

```
DOMANDA        cosa devo decidere
RISPOSTA       in due righe
CONFIDENZA     alta / media / bassa — e perché
3 FATTI        quelli su cui poggia tutto, con la fonte
TESI CONTRARIA la più forte trovata, e perché non regge (o regge)
DECISIONE      GO / NO-GO / TEST
               TEST = manca un dato decisivo, prima si fa X
PROSSIMA MOSSA una, concreta, con il titolare (Lele o macchina)
COSA LA RIBALTA il fatto che, se emergesse, cambierebbe la decisione
```

L'ultima riga è quella che serve fra sei mesi: dice quando la ricerca è
scaduta senza doverla rifare.

### 6. Cosa finisce nel vault
Nel file di progetto va **solo la scheda**, mai il report. Nel blocco `## Stato`
finiscono decisione e prossima mossa, come in `chiudi-sessione`.
La lezione di metodo entra in `regole-AI.md` solo se passa i soliti tre criteri.

## Vale anche per le risposte altrui
Quando Lele porta una ricerca fatta da un'altra AI, si applica lo stesso metro
prima di usarla: quali affermazioni sono fatti e quali inferenze, qual è la
tesi contraria, e a quale decisione porta. Una risposta lunga e ben scritta non
è una risposta verificata.

## Regola di stop
Se la ricerca non arriva a GO / NO-GO / TEST, non è finita — e va detto
chiaramente invece di consegnare il materiale e lasciare la sintesi a Lele.
