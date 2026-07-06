# Guida al Prompt Engineering 2026
*Antonio Guadagno, aprile 2026*

## Il problema di fondo
L'AI non sa chi sei, cosa vuoi, né quali sono i tuoi limiti.
La qualità dell'output dipende direttamente dalla qualità dell'input.

## La formula CRAFT

| Lettera | Elemento | Cosa include |
|---|---|---|
| C | Contesto | Chi sei, la tua situazione, il tuo obiettivo |
| R | Ruolo | La figura professionale che l'AI deve incarnare |
| A | Azione | Cosa deve fare, in che ordine, con quali vincoli |
| F | Formato | Output desiderato (tabella, elenco, markdown, JSON) |
| T | Target | A chi è destinata la risposta (tono, linguaggio, livello) |

### C — Contesto
Spiega chi sei come faresti con un professionista che incontri per la prima volta.

### R — Ruolo
Inizia sempre con "Comportati come". Sii specifico.
Non "un personal trainer" ma "un personal trainer specializzato in ginnastica dolce per anziani".

### A — Azione
Descrivi cosa fare, in che ordine, con quali vincoli, con quale livello di dettaglio.

### F — Formato
Specifica sempre l'output: tabella, elenco puntato, email, markdown, JSON.

### T — Target
Indica chi leggerà la risposta. Cambia tono, linguaggio e livello di complessità.

Trucchetto bonus: chiudi ogni prompt con "Se ti servono più informazioni, non esitare a farmi domande."

## I vincoli
Senza vincoli → risposta nel mondo ideale.
Con vincoli → risposta nel tuo mondo reale.

## Reference e Few Shot Learning
Fornisci 2-5 esempi del tuo stile. Meno di 2 è insufficiente; più di 5 crea confusione.

## Le 4 tecniche di iterazione
1. Ricontrolla — verifica che siano presenti tutti gli elementi CRAFT
2. Riscrivi — frasi più corte e dirette
3. Riformula — cambia prospettiva
4. Inserisci vincoli — aggiungi budget, tempo o risorse

## Tecniche avanzate

### Prompt Chaining
Usare la risposta di un prompt come input del successivo.

### Reasoning Tree
Chiedere all'AI di esplorare più soluzioni radicalmente diverse nella stessa risposta.

## Meta Prompting
Chiedi all'AI di costruire il prompt al posto tuo.
1. Fornisci un meta-prompt con la formula CRAFT
2. Indica l'argomento
3. L'AI genera il prompt completo
4. Apri una nuova chat e usa quel prompt

## La direzione futura: gli agenti AI
Il settore si sposta da chatbot ad agenti.
Il lavoro non sarà più eseguire, ma dirigere.
