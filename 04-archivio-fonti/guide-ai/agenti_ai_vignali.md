# Creare un team di agenti AI con Claude
*Dario Vignali, aprile 2026*

## Il concetto chiave: da un agente a un team
Un singolo agente è un dipendente digitale.
Un team di agenti è un'organizzazione: ogni agente ha una specializzazione,
lavora nei propri orari, e comunica con gli altri attraverso file condivisi (.md).
Il sistema è asincrono, tracciabile, revisionabile.

## I 3 workflow concreti

### 1. Il Briefing Mattutino
Un agente si attiva alle 7:30 e:
- Importa gli appuntamenti da Google Calendar
- Controlla task pendenti con scadenza oggi
- Processa registrazioni delle call del giorno prima
- Smista promemoria telefonici in task per progetto
- Scrive il piano della giornata nel daily note di Obsidian

Risparmio stimato: 30-45 minuti al giorno = ~150 ore all'anno.

Come costruirlo:
1. Aprire Claude Code e descrivere la routine desiderata
2. Rispondere alle domande di configurazione
3. Claude crea la skill — un file .md che descrive il processo esatto
4. Schedulare la skill: con Claude Co-work o con un cron job locale

### 2. La Pipeline Contenuti
Si passa un URL e l'agente esegue in sequenza:
1. Transcript — scarica il testo del video tramite TranscriptAPI
2. Articolo — trasforma il transcript in articolo lungo nel proprio stile
3. Post social — genera 5 proposte di post Instagram
4. Selezione — confronta con i post che hanno performato meglio
5. Carosello Canva — compila il template con titoli e testi

Note importanti:
- L'agente non pubblica nulla autonomamente. Produce bozze.
- La qualità della prima bozza è già al 70-80% di quella finale.

Foglio di stile — come crearlo:
"Fammi tutte le domande necessarie per capire come scrivo, il mio tono, il mio ritmo,
le cose che voglio evitare. Poi produci un file stile.md."

### 3. Il Radar
Ogni mattina alle 7:00 un agente scansiona:
- Reddit — 21 subreddit selezionati; filtra solo i post in esplosione
- Testate internazionali — The Atlantic, Wired, Bloomberg, HBR
- Newsletter Substack — post recenti con più engagement
- Inbox Gmail — newsletter ricevute ma non lette

Per ogni contenuto: titolo, brief di 2 righe, chiave di lettura, voto di viralità 1-10, link diretto.

Prompt di partenza:
"Voglio che ogni mattina tu faccia una ricerca su Reddit in questi subreddit [lista],
cerchi i post con più engagement nelle ultime 48 ore, e mi crei un report con titolo,
riassunto, link e un voto di rilevanza per il mio business. Salva il report nella
cartella research/reports/. Poi me lo mandi via Telegram."

## L'errore da evitare: automatizzare le cose sbagliate
Cosa automatizzare → task che richiedono poco pensiero ma molto tempo di esecuzione.
Cosa non automatizzare → task che richiedono giudizio.

## Il protocollo in 4 fasi

### Fase 1 — Osserva (una settimana)
Prompt per accelerare:
"Voglio capire dove butto via tempo nella mia giornata lavorativa.
Fammi un'intervista approfondita sulla mia operatività quotidiana."

### Fase 2 — Prioritizza (un giorno)
Ordinare la lista per frequenza x tempo.

### Fase 3 — Costruisci un agente alla volta (2-4 settimane per agente)
Un agente. Una skill. Una settimana di test. Non due agenti in parallelo.

### Fase 4 — Orchestra (ongoing)
Dopo 3-4 agenti crea una skill orchestratrice che concatena le skill in sequenza.

## Il cambiamento di mentalità
Quando esiste un team che esegue, la domanda smette di essere
"come faccio questa cosa?" e diventa "questa cosa vale la pena farla?"
