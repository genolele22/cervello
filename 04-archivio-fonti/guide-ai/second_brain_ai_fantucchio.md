# Non riscrivere più gli stessi prompt: costruisci il tuo Second Brain AI
*Andrea Fantucchio, maggio 2026 — Parte 1 di 7*

## Il problema che risolve
Ogni volta che apri una nuova conversazione con l'AI ricomincia da zero.
La soluzione: un sistema di file .md che rappresenta il tuo contesto stabile —
portabile su qualsiasi AI, oggi e in futuro.

## Struttura del sistema

cervello/
├── 00-identita/        → chi sei, obiettivi, tono di voce
├── 01-mercato/         → profili cliente, casi tipo
├── 02-operativo/       → strumenti quotidiani, workflow standard
├── 03-voce-e-stile/    → lessico, espressioni da evitare, esempi
└── 04-archivio-fonti/  → documenti originali

Ogni file .md ha un blocco YAML in testa con: data di creazione, fonte, stato.

## Fase 1 — Intervista con l'AI

Prompt completo:
"Sei un giornalista esperto in identità organizzativa. Mi aiuti a costruire
il documento fondante del mio secondo cervello per l'intelligenza artificiale.

Fase 1 — Intervista guidata. Una domanda alla volta, aspetta la mia risposta.
Se rispondo superficialmente, chiedi un esempio concreto prima di passare avanti.

Fase 2 — Mappa delle informazioni mancanti.

Fase 3 — Struttura cartelle proposta in formato albero."

Regola d'oro: rispondi sempre con almeno un esempio concreto.

## Fase 2 — Aggiungi quello che internet sa di te

Se hai un sito web:
"Vai sul mio sito [URL] e leggi tutte le pagine principali.
Sistema le informazioni chiave in una knowledge base strutturata.
Se trovi contraddizioni tra il sito e quanto ho detto io, segnalamele."

## Fase 3 — Organizza in Obsidian

Se conosci già Obsidian, aggiungi al prompt:
"Crea collegamenti tra i file correlati usando la sintassi [[nome-file]] di Obsidian."

## Schema di sintesi

| Fase | Strumento | Output |
|---|---|---|
| Intervista identità | Claude | identikit.md |
| Estrazione sito web | Claude + URL | knowledge-base.md |
| Estrazione da PDF | NotebookLM + Gemini | sintesi per area |
| Consolidamento | Claude | file .md per cartella |
| Organizzazione | Claude Cowork + Obsidian | vault navigabile |
