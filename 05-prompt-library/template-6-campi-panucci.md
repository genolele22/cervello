---
fonte: Giovanna Panucci — Modulo 9, maggio 2026
quando-usarlo: prompt complessi su Claude Opus 4.7 — compila tutti e 6 i campi
---

# Template 6 Campi (Panucci)

> Per Claude Opus 4.7: compila **tutti** i campi, specialmente il 5 (Formato).
> Per GPT-5.5: priorità ai campi 3 e 6. Niente step-by-step.

---

## 1. RUOLO
Chi è l'assistente e in quale contesto opera.
> "Sei un [RUOLO] per [TIPO DI ORGANIZZAZIONE/CONTESTO]."

## 2. OBIETTIVO
Il risultato visibile che il destinatario deve ottenere — non il processo.
> "Produrre [DOCUMENTO/OUTPUT] che [DESTINATARIO] possa usare per [SCOPO]."

## 3. CRITERI DI SUCCESSO ← IL PIÙ IMPORTANTE
Cosa deve essere vero perché il lavoro sia considerato finito.
Se questo campo è vuoto, Claude riempie i vuoti da solo — spesso male.
> "Il documento è completo quando contiene: [ELEMENTO 1], [ELEMENTO 2], [ELEMENTO 3]."

## 4. VINCOLI
Limiti di tono, fonti, lunghezza, cose da non fare.
> "Non inventare riferimenti. Distingui fatti da interpretazioni. Max [N] parole."

## 5. FORMATO DI OUTPUT
Struttura, sezioni, stile del documento.
> "Struttura in [N] sezioni: [SEZIONE 1], [SEZIONE 2]. Raccomandazioni in forma numerata."

## 6. REGOLE DI STOP
Quando fermarsi, chiedere chiarimenti, dichiarare informazioni mancanti.
> "Se ti mancano informazioni essenziali, elenca cosa ti serve prima di procedere."

---

## Differenza rispetto al template CRAFT

| Campo | CRAFT | 6 Campi Panucci |
|---|---|---|
| Chi sei | Contesto | Contesto |
| Cosa fare | Azione | Obiettivo + Vincoli |
| Come finisce | — | **Criteri di successo** ← nuovo |
| Output | Formato | Formato |
| Per chi | Target | — |
| Quando stop | — | **Regole di stop** ← nuovo |

I due campi in più (Criteri di successo + Regole di stop) sono quelli più spesso assenti
e quelli che fanno più differenza su Opus 4.7.
