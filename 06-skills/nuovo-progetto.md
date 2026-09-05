---
stato: attiva
versione: 1.0 — creata 2026-09-05
trigger: "partiamo con X", "nuovo progetto", "ho un'idea per" — prima di
         qualunque riga di codice, anche di un prototipo
---

# Skill: Nuovo Progetto

## Premessa (decisa da Lele il 05/09/2026)
Nessuno dei quattro progetti esistenti è nato per essere venduto: il VVF è un
gestionale interno, The Crew è per la sua palestra, Last Pact è un gioco fatto
col figlio, The Raven è il primo, di quando non sapeva ancora cosa fosse
possibile. **Da qui in avanti ogni nuovo progetto nasce come prodotto di lavoro
da vendere.** Questa skill esiste per non ripetere il costo di trasformare in
prodotto qualcosa nato per sé.

## Obiettivo
Fissare, prima del codice, le poche cose che costano **zero il primo giorno e
mesi al centesimo**. Non è un documento di progetto: è una sessione sola, con
un file solo alla fine.

## Cosa NON fa
- Non produce specifiche, roadmap, business plan o wireframe.
- Non decide se l'idea è buona: quello è di Lele.
- Non parte in parallelo su più progetti. Vedi «tassa mensile».

---

## Sessione zero — nessun codice

Si esce con **un solo file**, `PRODOTTO.md` nella radice del repo, con dentro
le sette risposte qui sotto. Se una risposta non c'è, il progetto non parte:
non è pignoleria, è che ognuna di queste sette decide una colonna del database.

### 1. Chi paga, e per cosa
Non «a chi serve»: chi firma. E su cosa si conta il prezzo — per
organizzazione, per persona, per transazione, per anno. **Il modello di prezzo
decide quali contatori esistono nello schema**: se lo decidi dopo, i dati per
fatturare non ci sono e non sono ricostruibili all'indietro.

### 2. Come arriva il cliente
Vendita diretta o rivenditore (per The Crew l'ipotesi è un commercialista).
Cambia cosa si costruisce: un rivenditore ha bisogno di vedere più clienti da
un posto solo, la vendita diretta ha bisogno che uno sconosciuto si iscriva da
solo. Sono due prodotti diversi, non due schermate diverse.

### 3. Il primo cliente non sei tu
**La regola più importante di tutte.** The Crew è nato bene ma senza
onboarding, perché il cliente era lui: nessuno ha mai dovuto entrare da fuori.
In un prodotto, «creare una nuova organizzazione» è una funzione del sistema,
non una sessione di lavoro con me. Il primo percorso che si costruisce è
quello di uno sconosciuto che arriva, si registra, mette i suoi dati e parte
da solo. Prima delle funzioni, prima della grafica.

### 4. Cosa vede chi non ha ancora comprato
Una demo in sola lettura con dati finti, viva dal primo giorno e sempre
allineata. Non si improvvisa alla prima richiesta.

### 5. Che dati tocca, e di chi
Se ci sono minori, dati sanitari, documenti giudiziari o denaro, vendere
significa trattare dati **per conto di altri**: cambia la responsabilità
legale, non solo lo schema. Va deciso subito se ci si mette in mezzo o no.
Da qui discende anche l'export: **un cliente che se ne va deve poter portare
via i suoi dati.** Costa poco farlo subito, toglie l'obiezione più comune in
vendita, ed è dovuto.

### 6. Quanto costa un cliente al mese
Infrastruttura, email, storage. Se non si misura dal primo giorno non si può
fissare un prezzo, e si scopre di rimetterci al decimo cliente.

### 7. Quando si smette
Un prodotto non finisce mai — quindi la condizione di uscita non è «quando è
finito», sono due numeri: **la versione minima vendibile** (cosa deve fare,
niente di più, per poter chiedere dei soldi) e il **criterio di abbandono**
(se entro N mesi non ha M clienti paganti, si chiude o si regala). Scritti
prima, quando non fanno male.

---

## Le sei condizioni tecniche

Discendono dalle sette risposte. Nascono col repo, non si aggiungono dopo.

**1. `organizzazione_id` su ogni tabella, dalla prima riga.**
Su un database vuoto è una colonna e un pattern di policy. Su The Crew oggi
sono 161 policy da riscrivere. Con un prodotto da vendere non è più
un'assicurazione: è il prodotto.

**2. Le regole del dominio in funzioni pure, fuori dalle pagine.**
Niente database, niente schermo: calcoli, scadenze, importi, numerazioni.
È l'unica differenza vera fra Last Pact (254 test) e il gestionale VVF (zero,
e non per pigrizia: la logica sta dentro le pagine e non è estraibile).
Da qui viene anche la fonte unica: la regola non si ricopia mai in due
linguaggi, si genera.

**3. Una fascia riservata ai collaudi in ogni sequenza numerata.**
Ricevute, protocolli, tessere. Decisa quando si disegna la tabella, non quando
ci sono tredici documenti veri da stornare.

**4. Ogni processo automatico scrive la propria riga di esito**, e la
sentinella che le legge nasce subito, vuota. Tre righe adesso, un rientro in
ogni job dopo.

**5. L'irreversibile nasce già protetto.**
Deciso in sessione zero: cosa non deve mai poter succedere in un secondo.
Quelle azioni nascono con il ritardo e l'annullamento, oppure con un ruolo di
database che non ha il permesso di farle — mai con una regola scritta solo
nell'interfaccia, che un agente scavalca (verbale confermato in 14 secondi,
01/09/2026).

**6. Chi scrive non certifica.**
Un ramo per agente e la revisione prima del merge. Su un repo nuovo è gratis,
è il flusso naturale; su un progetto avviato è un cambio di abitudini.

---

## Il primo file del repo
`PRODOTTO.md` (le sette risposte) e `AGENTS.md` (invarianti, azioni vietate
per nome, glossario del dominio) sono i file numero uno e due, prima del
codice. Su The Crew e Last Pact sono arrivati dopo, quando i danni avevano già
insegnato qualcosa: ogni agente delle prime venti sessioni ha lavorato senza.

## La tassa mensile
Ogni sistema vivo con utenti veri costa per sempre: note, incidenti, chiavi da
ruotare, gente che aspetta. Oggi ne pagano tre — VVF, The Crew, Last Pact.
Un prodotto da vendere è la tassa più alta di tutte, perché i clienti pagano e
quindi hanno diritto di pretendere.
**Prima di aprire il prossimo, si decide quale dei tre passa a manutenzione
fredda.** Se la risposta è «nessuno», il progetto non parte: non è una
questione di volontà, è che le ore non ci sono.

## Regola di stop
Se dopo la sessione zero mancano le risposte 1, 3 o 7 — chi paga, come entra
uno sconosciuto, quando si smette — non si scrive codice. Sono le tre che non
si possono aggiungere dopo senza rifare.
