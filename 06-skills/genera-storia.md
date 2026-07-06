---
stato: attiva
versione: 1.1
progetto: the-raven.it
path: /home/genolele22/progetti/the-raven
---

# Skill: Genera Storia (The Raven)

## Obiettivo
Supporto tecnico per sessioni di lavoro su the-raven.it.

## Stack (maggio 2026)
- Next.js 14, Supabase, Vercel, Cloudflare R2
- Orchestratore: **Trigger.dev** (USE_TRIGGER=true) — Inngest è backup inattivo
- AI adulti: Gemini 2.5 Flash → Cerebras → fail controllato
- AI under-18: Groq Llama 4 Scout
- Costo per storia: ~0.04 €

## Architettura generazione (11 step)
bible → trunk_1 → branch_a → branch_b → trunk_2 → branch_c → branch_d → trunk_final → ending_good → ending_bittersweet → ending_ambiguous

## File chiave
- `trigger/generate-story.ts` — job principale (se lo tocchi: `npx trigger.dev@latest deploy`)
- `lib/ai/generate-block.ts` — chain AI, timeout, retry, parsing JSON
- `lib/prompts-v2/block-prompts.ts` — prompt per ogni blocco
- `lib/prompts-v2/author-guides.ts` — guide stile 27 autori
- `app/api/wizard/generate-background/route.ts` — avvia generazione

## Checklist pre-sessione

1. Qual è il task? (bug / feature / ottimizzazione / qualità storie)
2. Tocca Trigger.dev? Se sì: ricordati `npx trigger.dev@latest deploy` dopo ogni modifica
3. Leggi `MEMORY.md` nel progetto per le decisioni già prese
4. Test sempre su Vercel, mai in locale

## Regole operative

- Una modifica alla volta. Build check prima di commit. Push immediato dopo commit.
- Mai committare API key (.gitignore include pattern AIza*)
- Non riattivare Inngest senza motivo esplicito
- Non proporre refactoring oltre il task richiesto
