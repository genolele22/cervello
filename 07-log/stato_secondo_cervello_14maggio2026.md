# Secondo Cervello — Stato al 14 maggio 2026
*Aggiornato a fine sessione Claude Code*

---

## Sistema operativo — tutto in funzione

| Componente | Stato |
|---|---|
| Cron briefing 7:30 | ✅ Fixato (PATH + flag -p) |
| cervello-bot Telegram | ✅ active/running (systemd) |
| ~/.claude/CLAUDE.md globale | ✅ Creato |
| Hook PreToolUse (rm -rf, .env) | ✅ Attivi |
| Hook Stop (session log) | ✅ Attivo |

---

## Vault ~/cervello/ — stato completo

```
~/cervello/
├── 00-identita/lele.md               ✅
├── 01-mercato/the-raven.md           ✅ aggiornato con stack reale
├── 02-operativo/
│   ├── task-pendenti.md              ✅
│   ├── task-completati.md            ✅ creato
│   └── note-giornaliere/             ✅ briefing attivo
├── 03-voce-e-stile/
│   ├── voce.md                       ✅
│   └── succedonocose.md              ✅ creato da 6 puntate
├── 04-archivio-fonti/guide-ai/       ✅ 10 guide (2 fixate, 1 aggiunta)
├── 05-prompt-library/
│   ├── craft-checklist.md            ✅
│   ├── template-6-campi.md           ✅
│   └── template-6-campi-panucci.md   ✅ creato
├── 06-skills/
│   ├── briefing-mattutino.md         ✅
│   ├── genera-storia.md              ✅ creato + aggiornato con stack reale
│   ├── pipeline-newsletter.md        ✅ creato + aggiornato con 6 puntate
│   └── morning-routine.md            ✅ creato
└── 07-log/
    ├── cron.log                      ✅ attivo
    └── sessions.log                  ✅ attivo (hook Stop)
```

---

## Guide operative caricate (04-archivio-fonti/guide-ai/)

| File | Autore | Stato |
|---|---|---|
| claude_prompting_guide.md | Anthropic | ✅ |
| istruzioni_generali_claude.md | Paolo Dalprato | ✅ |
| guida_prompt_engineering_2026.md | Antonio Guadagno | ✅ |
| agenti_ai_vignali.md | Dario Vignali | ✅ |
| strumenti_ai_giusti_grossi.md | Cristian Grossi | ✅ |
| second_brain_ai_fantucchio.md | Andrea Fantucchio | ✅ fixato |
| modulo9_prompting_opus47.md | Giovanna Panucci | ✅ |
| claude_code_avanzato_crostini.md | Perplexity Pro | ✅ fixato |
| skill_claude_avanzato_vignali.md | Dario Vignali | ✅ estratto da crostini |
| connettori_api_mcp_fantucchio.md | Andrea Fantucchio | ✅ aggiunto |

---

## Progetti — stato

### The Raven ★ priorità massima
- Live su the-raven.it
- Racconto attivo, Romanzo disabilitato per betatester
- Score qualità: 6.5/10 (target 7.5-8.5)
- MEMORY.md creato in ~/progetti/the-raven/MEMORY.md
- CLAUDE.md aggiornato con istruzione MEMORY
- **Bloccante aperto:** decidere modello di business (abbonamento / crediti)

### #succedonocose ★ priorità alta
- Substack, attiva
- Stile documentato in 03-voce-e-stile/succedonocose.md (6 puntate)
- Skill feedback: pipeline-newsletter.md operativa

### ASD Fight in Progress
- Nessuno strumento costruito
- Da fare: contabilità mensile, rendiconto, libro soci

### vvf-ferie-bot ✅ LIVE
- App: vvf-ferie-bot.fly.dev — macchina 48ee91db37e6d8, regione fra, state: started
- 9 secret deployati (SMTP, Telegram, Google OAuth, Fernet)
- SMTP Zimbra testato e funzionante (smtp-s.vigilfuoco.it:465)
- 109 vigili in DB
- Nessun blocco aperto

---

## Task pendenti aperti

- [ ] Modello di business per the-raven.it — 05/05/2026
- [ ] vvf-ferie-bot: configurare env Fly.io — 07/05/2026
- [ ] vvf-ferie-bot: test reale SMTP con credenziali vigilfuoco.it — 07/05/2026

---

## Ambiente tecnico

- Chromebook con terminale Linux (Crostini), username genolele22
- Claude Code v2.1.141
- Obsidian: ~/apps/obsidian.AppImage (flag --enable-unsafe-swiftshader)
- Hosting bot: Fly.io
- Manuale operativo: ~/cervello/MANUALE_OPERATIVO.txt
