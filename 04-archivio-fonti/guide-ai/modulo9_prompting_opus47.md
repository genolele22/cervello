# MODULO 9 — Nuovi standard di prompting: Claude Opus 4.7 vs GPT-5.5
*Giovanna Panucci, maggio 2026*

## Il cambiamento chiave

| | Claude Opus 4.7 | GPT-5.5 |
|---|---|---|
| Comportamento | Letterale — esegue esattamente ciò che scrivi | Autonomo — sceglie il percorso da solo |
| Cosa vuole | Istruzioni granulari su ogni variabile | Obiettivo finale + criteri di completezza |
| Cosa non vuole | Vaghezza, istruzioni incomplete | Step-by-step rigidi |
| Metafora | Artigiano: vuole il disegno tecnico completo | Consulente senior: vuole il brief |

## Claude Opus 4.7 — Come è cambiato

Opus 4.7 ha rimosso il comportamento compensativo delle versioni precedenti.
Non inferisce. Non aggiunge struttura non richiesta.

Esempio:
PRIMA: "Scrivi un parere sulla videosorveglianza in un comune."
ORA: "Scrivi un parere in materia di protezione dei dati personali destinato
al responsabile del settore Polizia Locale di un comune di 25.000 abitanti.
Struttura: inquadramento normativo, analisi dei profili di rischio,
valutazione sulla necessità di DPIA, raccomandazioni operative numerate.
Lunghezza indicativa: 1.500 parole."

Per attivare ragionamento profondo:
"Questo problema ha più livelli. Analizza con attenzione prima di rispondere."

Regola: migliora prima il prompt, poi aumenta l'effort se serve ancora.

## Il template a 6 campi

### 1. RUOLO
Chi è l'assistente e in quale contesto opera.
"Sei un consulente in materia di [TEMA] per [TIPO DI ORGANIZZAZIONE]."

### 2. OBIETTIVO
Il risultato visibile che il destinatario deve ottenere.
"Produrre [DOCUMENTO] che [DESTINATARIO] possa usare per [SCOPO]."

### 3. CRITERI DI SUCCESSO — IL PIU IMPORTANTE
Cosa deve essere vero perché il lavoro sia considerato finito.
"Il documento è completo quando contiene: [ELEMENTO 1], [ELEMENTO 2], [ELEMENTO 3]."

### 4. VINCOLI
Limiti di tono, fonti, lunghezza, cose da non fare.
"Non inventare riferimenti. Distingui tra fatti e interpretazioni."

### 5. FORMATO DI OUTPUT
Struttura, sezioni, stile del documento.
"Struttura in [N] sezioni: [SEZIONE 1], [SEZIONE 2]. Le raccomandazioni in forma numerata."

### 6. REGOLE DI STOP
Quando fermarsi, chiedere chiarimenti, o dichiarare che mancano informazioni.
"Se ti mancano informazioni essenziali, elenca cosa ti serve prima di procedere."

## Differenza di applicazione

Per Claude Opus 4.7: compila tutti e 6 i campi, specie il 5 (Formato).
Per GPT-5.5: priorità ai campi 3 e 6. Niente step-by-step.

## Convergenze tra i due modelli
- La vaghezza è il problema principale in entrambi i casi
- I criteri di successo sono il campo più importante e il più spesso assente
- Gli esempi (few-shot) restano una delle tecniche più affidabili
