---
stato: attiva
versione: 2.0 — fusa con morning-routine (2026-07-06)
trigger: cron 7:30 + @reboot (recupero) o manuale
---

# Skill: Briefing Mattutino

## Obiettivo
Piano della giornata dai task pendenti, inviato su Telegram.

## Trigger
- Cron `30 7 * * *` — se il container Linux è acceso a quell'ora
- Cron `@reboot` — recupero: appena apri Linux, se il briefing di oggi non esiste ancora
- Manuale: `bash /home/genolele22/scripts/briefing.sh`

## Pipeline (`~/scripts/briefing.sh`)
1. Input: `~/cervello/02-operativo/task-pendenti.md`
2. Genera il piano con `claude -p` → `~/cervello/02-operativo/note-giornaliere/YYYY-MM-DD.md`
3. Invia su Telegram con `~/cervello/bot-telegram/send_briefing.py` (token nel `.env` del bot)
4. Logga in `~/cervello/07-log/cron.log`

## Prompt
Leggi i task pendenti. Crea il piano di oggi ordinato per priorità.
Segnala i task in ritardo. Identifica il task più importante del giorno.
Formato markdown, conciso, senza preamboli.

## Guardia anti-doppione
Se la nota di oggi esiste già ed è non vuota, lo script esce subito senza rigenerare.

## Se fallisce
Controlla `~/cervello/07-log/cron.log`.
