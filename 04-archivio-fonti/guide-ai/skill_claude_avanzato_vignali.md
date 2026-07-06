# Guida alle Claude Skill — Livello avanzato
*Dario Vignali, maggio 2026*

## Cosa rende una skill professionale
Skill amatoriale → nasce da un'idea di cosa servirebbe fare.
Skill professionale → nasce da un workflow umano già rodato, fatto a mano almeno 5 volte.

"Se non hai mai fatto a mano il lavoro che vuoi automatizzare,
l'automazione che costruirai sarà mediocre."

## I 5 errori più comuni

1. Trattare la skill come un prompt lungo — file da 2.000 righe senza struttura
2. Descrizioni educate e generiche — invisibili al trigger automatico
3. Tutto in un file solo — corpo oltre 500 righe fa collassare la qualità
4. Skill che non ricordano cosa hanno già fatto — ogni run riparte da zero
5. Skill isolate che non parlano tra loro — script invece di sistema

## I 5 principi delle skill che funzionano

### Principio 1 — La descrizione è il motore
La descrizione fa tre cose:
1. Spiega in una frase cosa fa la skill
2. Elenca i trigger frasali esatti che devono attivarla
3. Indica eventuali contesti automatici

Formula: imperativa + trigger espliciti tra virgolette.
"USA SEMPRE questa skill quando l'utente dice:
'scrivi un post', 'scrivi su LinkedIn', 'fammi un post per LinkedIn'."

Descrizione gentile → attivazione nel 50% dei casi.
Descrizione imperativa con trigger → attivazione nel 95%.

### Principio 2 — Distillata dal lavoro vero
Due passaggi pratici prima di costruire qualsiasi skill:
1. Scrivi i lavori meccanici e ripetitivi che fai ogni settimana e che odi.
2. Scrivi per filo e per segno come lo fai: quali file apri, in che ordine,
   quali decisioni prendi, cosa controlli, dove finisce il risultato.

### Principio 3 — Mostra il minimo, tieni il resto sullo scaffale

Struttura consigliata:
cartella-skill/
├── SKILL.md          → corpo sotto 500 righe
├── references/       → contesto sempre utile
└── knowledge/        → da consultare solo se serve

CLAUDE.md globale → sotto le 200 righe. Oltre quella soglia le istruzioni
iniziano a competere tra loro e Claude ne perde pezzi.

### Principio 4 — Dille di controllare cosa ha già fatto
Riga da aggiungere quando chiedi a Claude di costruire una skill:
"Tieni traccia di cosa è già stato processato e non rifarlo due volte."

In gergo tecnico: idempotenza. Puoi rilanciare la skill 100 volte,
ottieni sempre lo stesso risultato corretto.

### Principio 5 — Skill che chiamano skill
Skill madre (morning-routine): non fa niente di concreto, è un orchestratore.
Lancia in parallelo più skill figlie con una frase sola.

## MEMORY.md — la coscienza storica del progetto

Regola da mettere nel CLAUDE.md del progetto:
"Ogni volta che durante una conversazione emerge una decisione,
un dato importante, un insight strategico, oppure ogni volta che
l'utente dice 'ricordami questo', appendi una voce nel MEMORY.md
con la data di oggi."

Formato:
- [2026-05-14] Decisione: [cosa è stato deciso e perché]
- [2026-05-10] Insight: [pattern osservato che vale la pena ricordare]

## Skill che si adattano da sole al sistema

Pattern sbagliato: lista di progetti scritta dentro la skill.
Pattern corretto: dare una regola, non una lista.
"Quando devi smistare qualcosa, capisci l'argomento.
Poi guarda nel filesystem e cerca se esiste una cartella di progetto dedicata.
Se la trovi, usa quella. Se non esiste la sottocartella, creala."

## Il fix del trigger automatico
Quando Claude ignora una skill, aggiungi questa riga:
"Ogni volta che rispondi, controlla sempre se c'è una skill rilevante che puoi usare."

Dove metterla:
- Claude Code → ~/.claude/CLAUDE.md (vale per tutti i progetti)
- Progetto specifico → CLAUDE.md della cartella progetto

## Il framework in 5 step

1. Scegli un task che ripeti almeno una volta a settimana e che odi.
2. Scrivi IL TUO metodo di esecuzione, con i tuoi standard e regole.
3. Trasforma il metodo in skill: descrizione imperativa, corpo sotto 500 righe.
4. Testa 10-15 volte su input diversi.
5. Orchestrala. Aggiungila a una skill madre.

## MCP come ponte verso il mondo esterno
Senza MCP: skill che vive nel filesystem.
Con MCP: agente che parla con il mondo.

La divisione pulita: MCP fa la connessione al mondo esterno, skill fa l'expertise.
