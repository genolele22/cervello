# Progetto — Automazioni e Bot

> **Rivedere entro:** 2026-12-05

## Stato

Stato: infrastruttura — ultima in classifica, non è un progetto con un fine
  ma il contenitore dei bot e delle automazioni che girano.
Deciso: vvf-ferie-bot ha una scheda propria (`vvf.md`) ed è uscito di fatto
  da qui. Quello che resta di specifico: bot Telegram trading, cervello-bot
  (`~/cervello/bot-telegram`, oggi solo `send_briefing.py`), briefing mattutino.
Prossimo passo: nessuno aperto. Da ripulire quando capita — vedi nota sotto.

## Cosa esiste

- Bot Telegram per il trading
- Automazioni di processi ripetitivi (in evoluzione)
- **vvf-ferie-bot** — bot Telegram per gestione richieste ferie, Comando VVF Genova

## vvf-ferie-bot — stato al 2026-05-06

**Path:** `/home/genolele22/vvf-ferie-bot`  
**Deploy:** Fly.io  
**Stack:** Python, python-telegram-bot 20.8, SQLite

### Architettura
- Vigile si registra con email istituzionale `@vigilfuoco.it` + password Zimbra (cifrata Fernet)
- Richiesta ferie: wizard a bottoni su Telegram → email inviata FROM `vigile@vigilfuoco.it` TO `capoturno@vigilfuoco.it` via SMTP Zimbra
- Capoturno risponde direttamente via email (Reply-To → vigile): nessun Telegram per il capoturno
- Tracciabilità istituzionale completa su Zimbra

### Comandi bot
| Comando | Chi | Cosa |
|---|---|---|
| /start | Pompiere | Registrazione (email + password Zimbra) |
| /ferie | Pompiere | Richiesta ferie (wizard a bottoni) |
| /mie_richieste | Pompiere | Storico richieste |
| /aggiorna_password | Pompiere | Aggiorna credenziali email |
| /pending | Capoturno | Lista richieste in attesa |
| /pending_data | Capoturno | Lista richieste per mese |

### Stato al 14 maggio 2026 — LIVE ✅
- App Fly.io: vvf-ferie-bot.fly.dev (regione fra, sempre attivo)
- 9 secret configurati e deployati
- SMTP Zimbra testato e funzionante
- 109 vigili in DB
- Nessun blocco aperto

## Approccio

Lele ha competenze tecniche solide.
Non ha bisogno di spiegazioni di base — ha bisogno di soluzioni dirette.

## Come l'AI può aiutare

- Debug e sviluppo di bot
- Progettazione di nuove automazioni
- Ottimizzazione di flussi esistenti
