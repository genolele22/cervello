# Progetto — App tempo libero

**Stato:** da progettare (idea del 2026-07-06)

## Obiettivo

App che propone come usare il tempo libero in modo coerente:
incrocia i turni VVF, gli impegni (famiglia, ASD) e gli obiettivi personali (basso, inglese).

## Vincolo chiave

Lele la userà dal telefono (Android). Interfaccia mobile-first:
il candidato naturale è Telegram, non una web app.

## Asset riusabili

- Il ciclo turni è già codificato in `vvf-ferie-bot/calendar_turni.py`
- Bot Telegram del cervello già scritto (`~/cervello/bot-telegram`) — oggi usato solo per send_briefing.py
- Google Calendar è già collegato via MCP (lato Claude)
- Il briefing mattutino è l'embrione: stesso output, ma senza calendario né turni

## Da decidere

- Forma: bot Telegram (consigliato) vs web app
- Fonte impegni: Google Calendar vs inserimento manuale via bot
- Hosting: Fly.io (stessa infrastruttura di vvf)
