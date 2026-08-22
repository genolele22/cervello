---
aggiornato: 2026-08-06
stato: in pausa — rientra in priorità appena il gestionale ASD (The Crew) è operativo
priorità: condizionata (dopo vvf e gestionale ASD)
---

# Progetto — The Raven

**URL:** the-raven.it
**Repo:** genolele22/the-raven-
**Deploy:** Vercel (auto-deploy da main)
**Path locale:** `/home/genolele22/progetti/the-raven`

## Stato

Stato: in pausa — 4° in classifica. Rientra appena Crew è operativo (deciso 06/08).
  La pausa vale per lo sviluppo, non per il rischio: 3 chiavi restano esposte.
Deciso: 06/08/2026 — il rientro non è più a tempo indeterminato ma agganciato a
  Crew. Modello di business ancora **non deciso** dopo 3,5 mesi (aperto dal
  05/05): è la decisione che sblocca tutto il resto. Ipotesi sul tavolo dal 06/08:
  catalogo a bivi con sblocco/abbonamento stile DramaBox.
Prossimo passo: fuori classifica e subito — ruotare le 3 chiavi esposte
  (Supabase service_role, Mistral, Gemini). Alla ripresa vera: mergiare
  `tema-carta-globale`, poi i 3 test rimasti aperti da maggio (qualità racconto
  betatester, under-18 per fascia d'età, abilitare Romanzo).

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

## Com'era a maggio 2026 (storico)

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

### Ricerca monetizzazione stile DramaBox (recap 06/08/2026, da un amico)

Riferimento: DramaBox — episodi gratis + cliffhanger + sblocco a monete o abbonamento flat (~20$/sett, 70% dei ricavi), pubblicità per chi non paga. Funziona per volume enorme di episodi economici.

Il mercato "DramaBox dei libri" esiste già (Webnovel, GoodNovel, Dreame, Radish) — affollato, con conglomerate cinesi e anni di catalogo. Non è spazio vuoto.

Due strade indviduate:
- **Modello A** (com'è oggi): storia privata 1:1 via wizard col Corvo, niente catalogo da monetizzare a capitolo.
- **Modello B**: catalogo condiviso, storie a bivi scritte dal Corvo, sblocco a capitolo + abbonamento. È un prodotto diverso da quello attuale — da "crea la tua storia" a "sfoglia un catalogo e sblocca".

**Differenziante identificato:** i bivi. Nessun concorrente (narrativa lineare) offre la scelta come leva di monetizzazione — un ramo gratis, uno premium. Vantaggio reale, non estetico.

**Perché ora:** costo di generazione AI (~0.04€/storia) è una frazione del costo di una scuderia di autori umani — margine strutturale migliore di Webnovel/Dreame.

**Nodi aperti, in ordine di urgenza:**
1. Cold-start catalogo: generare a volume è economico, ma "economico" ≠ "abbastanza buono da trattenere un abbonato per mesi" — serve piano di QA a scala
2. Mercato solo IT per ora — volumi ridotti rispetto a DramaBox
3. Retention da costruire da zero (oggi: una storia, un'email, fine — manca push/"nuovo capitolo pronto")
4. Rischio legale/IP diverso da "l'AI ti aiuta con la tua storia personale" — da verificare prima di scalare qualcosa a pagamento

Nota: è materiale per riflettere, non una spec di prodotto. Nessuna decisione presa.

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
