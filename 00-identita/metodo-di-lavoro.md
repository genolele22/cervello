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
