# Claude Code avanzato su Crostini/ChromeOS
*Report Perplexity Pro, maggio 2026 — per genolele22*

## MODULO 10 — Pattern avanzati per sessioni lunghe

### CLAUDE.md come memoria di progetto
- Sezioni stabili: stack, convenzioni di stile, struttura cartelle, policy di sicurezza
- Sezioni variabili: stato corrente, milestone, TODO, decisioni di architettura
- Riferimento a file di piano (plan.md) rigenerati a ogni milestone

### Sessioni brevi, obiettivi stretti
- Definire un obiettivo stretto per sessione
- Tenere le sessioni entro 5-10 turni operativi, poi /clear o nuova sessione
- Prima di chiudere, far scrivere a Claude un riassunto in plan.md

Blocco contratto per ogni task complesso:
"Contesto: [situazione attuale]
Vincoli: [cosa non toccare]
Obiettivo di questa sessione: [una cosa sola]
Output atteso: [file da modificare]"

## MODULO 11 — Hook avanzati

### Hook come firewall su Bash
PreToolUse + matcher "Bash" blocca con exit code 2:
- rm -rf
- git reset --hard
- curl http verso host non whitelisted

### Hook post-edit per qualità automatica
PostToolUse + matcher "Edit":
prettier --write $FILE
eslint --fix $FILE
git add $FILE && git commit -m "chore(ai): auto-format"

### Configurare hook senza editare JSON
Nel terminale con Claude Code aperto: /hooks

## MODULO 12 — MCP server utili

GitHub MCP: npx @github/mcp-server
Notion MCP: npx makenotion/notion-mcp-server
Browser automation: npx @playwright/mcp
Web scraping: npx firecrawl-mcp
Supabase locale: http://127.0.0.1:54321/mcp
Vercel MCP: ufficiale, espone log di deploy

## MODULO 13 — Collegare a Fly.io, Supabase, Vercel

Non serve sempre un MCP. Spesso è più semplice dare a Claude accesso alle CLI.

Fly.io:
fly status --json
fly deploy --json
fly machines list --json

Flag --json su quasi tutti i comandi → parsing robusto da parte di Claude.

## MODULO 14 — Limiti Crostini/ChromeOS

### systemd
Crostini non ha systemd pieno. Per servizi persistenti:
tmux new-session -d -s mcp-server "node ~/mcp/server.js"

### Resource killing
Crostini può uccidere container con poca RAM.
Prima di sessioni intense: chiudi tab Chrome pesanti.

## MODULO 15 — Workflow agentici e skill SKILL.md

### Struttura cartella skill
.your-skill-name/
├── SKILL.md
├── scripts/
├── references/
└── assets/

### Frontmatter SKILL.md
---
name: pipeline-contenuti
description: "Trasforma URL in articolo + post social"
model: claude-sonnet-4-5
tools:
  - Bash
  - Edit
context: fork
---

### Architettura progressive disclosure
Claude carica solo i metadati (~100 token) → se rilevante, carica il contenuto esteso.

### Skill per The Raven
---
name: genera-storia
description: "Genera una storia ad albero per The Raven e aggiorna Supabase"
tools: [Bash, Edit, mcp__supabase__query]
---
Passi:
1. Leggi prompt e metadati da input/storia-config.md
2. Genera storia con struttura ad albero (3 livelli di scelta)
3. Valida struttura (minimo 2 scelte per nodo)
4. Aggiorna tabella storie su Supabase via CLI
5. Conferma con output: "Storia [TITOLO] pubblicata — ID: [ID]"

### Skill per newsletter #succedonocose
---
name: pipeline-newsletter
description: "Da URL o idea grezza a bozza newsletter nel formato succedonocose"
tools: [Bash, Edit]
