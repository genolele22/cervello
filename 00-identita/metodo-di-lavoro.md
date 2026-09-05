# Metodo di lavoro — profilo di riferimento

> Versione leggibile e stampabile: `metodo-di-lavoro.html` (stessa cartella)
> Online: https://claude.ai/code/artifact/369d5b32-90f8-41e5-b7fc-f41a778538e4
> Aggiornato: 05/09/2026 — da rileggere e ritarare a ogni cambio di direzione.

Documento con tre usi: riferimento per l'AI che lavora con Lele, materiale
diagnostico da dare ad altre AI (forza/debolezza + consigli), base per
presentarsi a un eventuale collaboratore.

## Numeri alla data (verificati sui repo)

- 6 repository attivi, 4 con utenti veri — 1.145 commit da marzo a settembre 2026
- ~34.000 righe PHP (vvf-gestionale) + ~52.000 TS/TSX (the-crew)
- 134 migrazioni DB su the-crew in 5 settimane
- 0 file di test su vvf-gestionale e the-crew; 21 su br-turni; nessuna CI

## Il ciclo in sette passaggi

1. Segnalazione dall'utente vero, dentro l'applicativo (logbook "Qui non va", note numerate)
2. Ricognizione prima di delegare (massima resa per la minima spesa)
3. Note raggruppate **per area di file**, un agente per area, sfalsati
4. Collaudo con dati finti nel DB vero, poi rimossi; dry-run con rollback sulle migrazioni
5. Deploy a fine sessione, sempre
6. Verifica guardando (età del deployment, non HTTP 200; riverificare il lavoro degli agenti)
7. Aggiornare il cervello prima di chiudere (scheda progetto + lezione se supera i 3 criteri)

## Punti di appoggio

vault `~/cervello/` · skill richiamabili · logbook dentro i prodotti ·
produzione come banco di prova (Fly/Vercel/Supabase) · l'AI come unico
collaboratore, con 88 file di memoria persistente.

## Inventario tecnico (al 05/09/2026)

| Progetto | Stack | Database | Hosting | Dimensione |
|---|---|---|---|---|
| vvf-gestionale | PHP 8.2 + Apache, no framework, FoglioRenderer→HTML+ODT | TiDB Cloud (MySQL-compat., porta 4000, PDO), 37 tabelle | Fly.io fra, 256MB, auto-stop, sessioni su DB | 241 commit, ~34k righe |
| vvf-ferie-bot | Python 3, python-telegram-bot 20.8, odfpy/lxml, Fernet | stesso TiDB via PyMySQL | Fly.io fra, volume /data, sempre acceso | 71 commit |
| the-crew | Next.js 16 + React 19 + TS + Tailwind 4, Server Actions | Supabase/Postgres: 66 tabelle, 161 policy RLS, 76 funzioni, 71 trigger, 134 migrazioni, pg_cron | Vercel fra1, PWA + web push | 322 commit, ~52k righe |
| br-turni (Last Pact) | motore TS puro + Next 16/React 19, vitest 254 test | Supabase | Vercel | 206 commit |
| the-raven | Next.js 14 + React 18, @xyflow/react, zod, Trigger.dev 4.4.6 | Supabase | Vercel | 305 commit, fermo dal 19/06 |
| cervello-bot | Python + python-telegram-bot, cron 7:30 | — | Fly.io | infra |

**Servizi**: Stripe (+webhook) · Nodemailer SMTP Gmail + imapflow (copia in Inviati) ·
IMAP APPEND vigilfuoco.it · Telegram webhook · Resend · Cloudflare R2 · Google
OAuth/Drive/Sheets · unpdf · modelli AI Llama 4 Scout / Llama 3.3 70B /
gpt-oss-120b via Groq, OpenRouter, Mistral, Gemini.

**Postazione**: Chromebook con Linux, nessun ambiente locale (si prova sul deploy).
Claude Code da terminale con MCP: Supabase, Vercel, Canva, Gmail, Calendar, Drive,
Chrome. Playwright/Chrome headless per gli screenshot. GitHub via SSH.

**Vincoli noti**: TiDB non ha AUTO_INCREMENT usabile e rifiuta `--single-transaction`
nel dump · il DB VVF si interroga solo da dentro Fly, con `machine exec` + base64
(`fly ssh console` è rotto) · una macchina Fly che si spegne perde `/tmp` fra due
comandi SSH · `net._http_response` di Supabase conserva ~6 ore · in serverless serve
`after()` ma i dati vanno letti prima · la logica duplicata PHP↔JS va **generata**
dalle costanti PHP.

**Cosa non c'è**: nessuna CI, nessun ambiente di prova, nessun IaC, nessun
monitoraggio esterno, nessun inventario dei segreti.

## Punti di forza

Consegna in produzione · gli errori diventano regole scritte e datate ·
dominio conosciuto dall'interno · corregge la causa **e** impedisce l'effetto ·
sa contraddire l'AI e ha ragione abbastanza spesso.

## Punti deboli (tutti con guasti reali documentati)

Zero test automatici dove conta · i difetti li trova l'utente o il caso ·
il collaudo avviene in produzione · la delega agli agenti non ha rete di
sicurezza (un agente col DB scavalca le protezioni scritte nell'interfaccia) ·
un solo punto di rottura ed è una persona (niente documentazione d'ingresso) ·
si apre più di quanto si chiuda.

## Consigli, per resa decrescente

1. Test solo sulla logica pura e costosa (cicli turno, salto, scadenze, compensi)
2. Ogni promessa fatta a schermo diventa un controllo sul dato
3. Un registro **proprio** per ogni processo automatico + sentinella che lo legge
4. Staging vero (branch DB) invece dei dati finti in produzione
5. Nei brief per agenti si scrive il **divieto**, non solo l'obiettivo; e si controlla il DB dopo
6. Chiudere prima di aprire — un progetto per volta fino a "finito e a norma"
