---
stato: attiva
versione: 1.0 — creata 2026-08-22
trigger: manuale ("chiudi sessione", "fine lavoro", "salviamo tutto") o a fine sessione lunga
---

# Skill: Chiudi Sessione

## Obiettivo
Non perdere quello che si è capito lavorando. A fine sessione il vault deve
poter rispondere da solo a: a che punto siamo, cosa è stato deciso, cosa viene dopo.

## Trigger
- Lele dice "chiudi sessione", "fine lavoro", "salviamo tutto"
- Fine di ogni sessione lunga, anche senza che lo chieda — proporlo, non farlo di nascosto

## Cosa NON tocca
- La memoria nativa di Claude (`~/.claude/projects/.../memory/`) — è un sistema
  separato e automatico. **Il vault è la fonte di verità umana: in caso di
  conflitto tra i due, vince quello scritto nel vault.**
- Il testo creativo di Lele. Mai, in nessuna forma.
- Qualunque file esistente, senza avergli prima mostrato cosa cambia.

## Procedura

### 1. Rivedere la sessione
Ripercorrere cosa è stato fatto davvero — non cosa si era pianificato.
Separare tre cose, che sono diverse:
- **Decisioni prese** — scelte con un'alternativa scartata. Vanno salvate con il
  *motivo*, che è la parte non ricostruibile dai fatti tra un mese.
- **Blocchi trovati** — cosa impedisce di andare avanti, e **di chi è l'azione**
  (Lele o macchina). Un blocco senza titolare non è un blocco, è un lamento.
- **Prossimi passi** — la cosa successiva concreta, non l'elenco di tutto l'aperto.

### 2. Aggiornare solo la voce pertinente
Nel file `~/cervello/progetti/<progetto>.md` toccato dalla sessione, aggiornare
**solo il blocco `## Stato` in cima** (Stato / Deciso / Prossimo passo).
- Un solo progetto per sessione, di norma. Se se ne sono toccati due, due blocchi.
- Il blocco resta **max 10 righe, niente cronaca**: la cronologia va nel corpo
  del file, sotto, o non va da nessuna parte.
- Se il fatto nuovo contraddice qualcosa scritto più in basso nel file,
  **segnalarlo a Lele** invece di correggere in silenzio.

### 2b. Data di revisione sulla scheda (dal 05/09/2026)
Ogni scheda in `~/cervello/progetti/` porta in cima una riga
`Rivedere entro: <data>` — di norma **tre mesi** dall'ultimo lavoro vero.
Serve perché il vault cresce e non si ritira mai niente: senza una data, una
scheda resta vera per inerzia anche quando il progetto è fermo da mesi.

Scaduta la data, la scheda va **guardata**, non riscritta d'ufficio: tre esiti
possibili, e uno va scelto.
- **vivo** — si aggiorna e si sposta la data avanti
- **fermo** — resta dov'è, ma con scritto cosa serve per riprenderlo
- **archivio** — si sposta in `~/cervello/progetti/archivio/` e sparisce dal
  giro quotidiano

Il livello *vivo* è ciò che leggo a ogni sessione (`CLAUDE.md` e le schede dei
progetti in corso); l'*archivio* si legge solo se serve. Finora mancava la
regola che dice cosa retrocede: è questa.

### 3. Lezioni tecniche riusabili → regole-AI.md
Se è emersa una lezione che varrà **anche su un altro progetto**, aggiungerla
alla sezione `## Lezioni tecniche riusabili` di `~/cervello/regole-AI.md`.
Barra alta, tre criteri tutti obbligatori:
1. Riusabile fuori dal progetto dove è successa
2. Non ovvia — non è "testare prima di deployare"
3. È costata qualcosa scoprirla (un bug vero, un incidente, un giro a vuoto)
Se non passa tutti e tre, non entra: `regole-AI.md` è corto apposta, se diventa
un diario nessuno lo legge più e smette di funzionare.

### 4. Blocco prove (dal 05/09/2026)
Prima delle tre righe, **le prove di ciò che si dichiara**. Non lavoro in più:
è lo stesso lavoro scritto, e sposta la verifica da un atto di Lele a una
lettura. Solo le voci pertinenti alla sessione:

```
PROVE
DB        query lanciata → cosa ha risposto (righe, valori)
DEPLOY    id del deployment + età ("Age"), non un HTTP 200
SCHERMO   screenshot, dove c'è grafica o una pagina cambiata
TEST      comando lanciato → esito
NON FATTO cosa si è dichiarato e NON è stato verificato
```

L'ultima riga è obbligatoria quando esiste. Una cosa fatta e non verificata va
detta come tale, mai lasciata insieme alle altre.

### 5. Chiudere con 3 righe
Esattamente tre, a Lele, in chiaro:
1. Cosa è stato fatto
2. Cosa resta aperto e di chi è la mossa
3. Da dove si riparte la prossima volta

## Regola di stop
Prima di ogni scrittura, mostrare a Lele il blocco esatto. File per file.
Nessuna sovrascrittura al buio.
