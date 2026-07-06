---
aggiornato: 2026-05-14
stato: attivo, in produzione
priorità: massima (obiettivo reddito 12 mesi)
---

# Progetto — The Raven

**URL:** the-raven.it
**Repo:** genolele22/the-raven-
**Deploy:** Vercel (auto-deploy da main)
**Path locale:** `/home/genolele22/progetti/the-raven`

---

## Cos'è

Piattaforma italiana per storie navigabili generate da AI.
NON è un librogame. È un romanzo-albero.
Slogan: "La storia obbedisce a te."

## Target

- Mamme: storie della buonanotte diverse ogni sera, create con i figli
- Maestre: narrativa didattica interattiva

## Obiettivo

Generare reddito sufficiente da comprare tempo a Lele per scrivere.
The Raven è il mezzo. Il fine è la scrittura.

---

## Stack tecnico

- **Framework:** Next.js 14, React 18, TypeScript
- **Database:** Supabase
- **Hosting:** Vercel
- **Storage:** Cloudflare R2
- **Orchestratore:** Trigger.dev (attivo) — Inngest (backup, inattivo)
- **AI adulti:** Gemini 2.5 Flash → Cerebras → fail controllato
- **AI under-18:** Groq Llama 4 Scout
- **Email:** Resend
- **Costo per storia:** ~0.04 €

## Architettura generazione

11 step: bible → trunk_1 → branch_a → branch_b → trunk_2 → branch_c → branch_d → trunk_final → ending_good → ending_bittersweet → ending_ambiguous

---

## Stato attuale (maggio 2026)

**In produzione:**
- Generazione storia in background (Trigger.dev, nessun timeout)
- Wizard conversazionale (il Corvo) con 7 blocchi
- 27 autori di riferimento su 5 generi
- Racconto attivo per betatester, Romanzo disabilitato ("Prossimamente")
- Email notifica completamento (Resend) ✅
- Dominio the-raven.it collegato ✅

**Qualità storie:** 6.5/10 attuale → 7.5-8.5/10 stimato con miglioramenti in pipeline

**Da fare:**
- [ ] Test qualità racconto per betatester
- [ ] Test under-18 per ogni fascia d'età
- [ ] Abilitare Romanzo
- [ ] Decidere modello di business

---

## Modello di business — aperto

Non ancora deciso. Opzioni sul tavolo:
- **Freemium:** alcune storie gratis, abbonamento per accesso illimitato
- **Crediti:** pacchetti pay-per-use, nessun abbonamento ricorrente

Questa decisione sblocca qualsiasi lavoro su acquisizione utenti e automazioni.

---

## File chiave nel progetto

| File | Cosa fa |
|---|---|
| `trigger/generate-story.ts` | Job principale Trigger.dev |
| `lib/ai/generate-block.ts` | Chain AI, timeout, retry, parsing JSON |
| `lib/prompts-v2/block-prompts.ts` | Prompt per ogni blocco narrativo |
| `lib/prompts-v2/author-guides.ts` | Guide stile 27 autori |
| `app/api/wizard/generate-background/route.ts` | Avvia generazione |

Decisioni dettagliate → `MEMORY.md` nel progetto.
