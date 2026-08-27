# The Crew — Social: calendario e stato

*File vivo — aggiornato ad ogni sessione. Procedura e regole di brand fisse sono in `~/cervello/06-skills/social-the-crew.md`, non qui.*

Ultimo aggiornamento: 27/08/2026.

---

## 🟢 DOVE RIPRENDERE (stato al 27/08 sera — SBLOCCATO)

**Fatto in questa sessione**: estensione Claude in Chrome collegata e funzionante (il problema precedente si è risolto da sé, non serviva altro). Costruite da zero in Canva vero due locandine (Iaido, Yoga) — vedi sezione "Metodo Canva" sotto per l'architettura, sono nettamente più curate delle due precedenti in HTML piatto (vedi [[project_crew_locandine_baseline]] in memoria). Due giri di correzione dopo il primo invio: (1) foto ritagliata + cerchio Ensō invece del riquadro fotografico intero, (2) logo vero del marchio al posto del badge placeholder IA + tolta la data di pubblicazione Instagram scritta per errore come orario del corso Yoga (vedi [[feedback_crew_verificare_asset_e_dati_reali]]). Versione finale mandata a Lele — **in attesa del suo ok prima di replicare il metodo sugli altri contenuti in coda**.

**Design Canva (id, per riprenderli/ricopiarli)**:
- Iaido: `DAHTgYcjQB8` — https://www.canva.com/d/j9uKkb8opc1d2Yv
- Yoga: `DAHTgcWpB8Q` — https://www.canva.com/d/dsRjYFySCmxC9h7

---

## Metodo Canva — architettura verificata funzionante il 27/08/2026

Aggiorna/sostituisce quanto scritto nella skill §6 (Bulk Create manuale): esiste una via molto più diretta, **niente Bulk Create, niente CSV**.

1. **Foto reale → Canva**: il Canva MCP connector (`mcp__claude_ai_Canva__*`) NON accetta upload di file locali (solo URL già pubblici). Soluzione: caricarla una volta nel Chrome vero di Lele via `mcp__claude-in-chrome__file_upload` sul pannello "Carica" di Canva, poi **trascinarla (drag) dalla libreria Caricamenti sopra la foto placeholder già presente nel design** — Canva la sostituisce *in-place* nello stesso elemento (stessa posizione/ritaglio), niente da riposizionare via API.
2. **Tutto il resto è API pura**, via `mcp__claude_ai_Canva__edit-design` (operazioni tipografiche: `replace_text`, `find_and_replace_text`, `format_text`, `position_element`, `resize_element`, `insert_shape` per barre/onde/fondo, `layer_element` per l'ordine). Serve `read-design` con `open_transaction:true` per leggere i `locator_id`, poi `edit-design` con `finalize:"commit"` a fine lavoro. **Limite noto**: `format_text` non ha un parametro font-family — il font resta quello scelto in fase di generazione, non è impostabile a piacere via API.
3. **Per una locandina nuova sullo stesso impianto**: `copy-design` del design finito → drag della nuova foto reale nel placeholder (unico passo da browser) → `edit-design` per sostituire titolo/tagline/nome istruttore/credenziale/info pratiche (stesso schema testi di Iaido/Yoga) → `export-design` in PNG.
4. **Punto di partenza per un design nuovo da zero** (non da duplicare): `generate-design` (Canva MCP, `design_type:"instagram_post"`) con un prompt dettagliato di brand → 3-4 candidati via `create-design-from-candidate` → `resize-design` a 1080×1080 custom → rifinire via `edit-design` come sopra. Va sempre rifinito a mano (i candidati grezzi non rispettano mai fedelmente palette/font/footer), ma dà una base tipografica migliore di partire da un rettangolo vuoto.

Questo metodo **è già l'automazione**: per produrre le prossime locandine (Bastone&Coltello, Tai Chi, Sala Functional non appena arrivano le foto) basta ripetere lo stesso giro, senza che Lele tocchi Canva — l'unico suo compito resta darmi le foto reali.

---

## Inventario foto — stato reale aggiornato il 27/08/2026

Ricerca iniziale (disco + Drive) risultata a vuoto — dettaglio storico in fondo al file. **27/08 sera: Lele ha caricato 15 immagini in chat**, ora salvate in modo permanente in `~/cervello/progetti/the-crew-social-foto/ricevute-27-08/`:

| Corso/istruttore | Stato | Cosa c'è nella cartella |
|---|---|---|
| Yoga (Giulia La Rocca) | ✅ **sbloccato** | 6 foto reali candid (roccia/lago, cresta rocciosa, due verticali in giardino, posa su cresta innevata, posizione barca al chiuso) + 1 locandina già finita nel nuovo stile Crew, con tagline e testo reali |
| Iaido (Massimo Valentini) | 🟡 **quasi sbloccato** | 1 foto reale nuova (bianco/nero, azione, non in posa) + 2 locandine già finite (una nel nuovo stile Crew, una vecchia del dojo di Valentini — jikishinkandojo.it) con orario/telefono/testo reali. Manca solo un ritaglio pulito senza sfondo se si vuole la stessa posa in silhouette; la foto B/N regge già come "foto scenica intera" |
| Tai Chi (Claudio Genovesi) | ❌ non ricevuta | foto ancora da rifare/procurare |
| Bastone & Coltello (Claudio Genovesi) | ❌ non ricevuta | — |
| Sala Functional/Pesi | ❌ non ricevuta | — |
| Sara Lione / Play&Dance | ✅ **usabile** — non è Kaleido, è di The Crew | Bio card reale + volantino ricevuti (bio: "Amo i bambini perché insieme a loro posso finalmente smettere di fingere di essere adulta"). Non ancora in coda di produzione — non l'ho aggiunta al calendario di mia iniziativa, è una decisione di priorità tua se e quando inserirla |
| Silat (workshop 19/9) | ✅ dati confermati | volantino reale con Guru Michele Brocca + William Aliati, conferma data/ora/luogo già nel calendario |

**Nota sui file**: sono 15, nomi originali non rinominati (mantenuti come ricevuti) — dentro la cartella si distinguono a colpo d'occhio, non li ho rietichettati uno per uno per non rischiare di scambiare una posa con un'altra a memoria.

**Resta da procurare**: foto per Tai Chi, Bastone&Coltello, Sala Functional/Pesi — nessuna urgenza su Boxe/Difesa personale/Kempo Kids (scelta tua di saltarle per ora).

---

## Calendario editoriale

| Data | Contenuto | Stato | Blocco |
|---|---|---|---|
| 26/08 | Reel Silat (workshop 19/9) | ✅ pubblicato | — |
| 30/08 | Bastone & Coltello | 🟡 didascalia pronta (sotto), locandina bloccata | foto mancante |
| 01/09, 18:30 | Yoga | ✅ didascalia + foto pronte (sotto) | — |
| 04/09, 19:00 | Iaido | ✅ didascalia + foto pronte (sotto) | — |
| 08/09, 19:00 | Tai Chi | 🟡 didascalia pronta (sotto), locandina bloccata | foto mancante + foto vecchia ha difetto testa/mano da rifare comunque |
| 11/09 | Sala Functional | 🟡 didascalia pronta (sotto), locandina bloccata | foto mancante (o da verificare se le 2 trovate in Drive bastano) |
| in coda | Bastone & Coltello (altre), Difesa personale, Boxe, Kempo Kids | ⬜ | Boxe/Difesa personale/Kempo Kids: niente foto per scelta esplicita di Lele, non urgente |
| metà settembre | Reminder workshop Silat (19/9) | ⬜ da schedulare a ridosso della data | — |
| da ottobre | Regime: istruttori rimanenti, Sala Pesi/Functional ogni ~10gg | ⬜ | — |
| — | Template Canva con autofill | ⬜ **non ancora costruito** | build one-time nell'editor Canva, vedi skill §6 |

**Cadenza confermata**: batch settimanale/ogni 10 giorni, va bene preparare più contenuti insieme.

---

## Contenuti pronti — 5 didascalie, testo completo

Tutte seguono la formula fissa (skill §4). Segnalate esplicitamente le assunzioni fatte per mancanza di un dato esplicito nel brief — da confermare o correggere.

### 1. Bastone & Coltello — Claudio Genovesi (30/08)

> Bastone, coltello, un istinto solo.
>
> Bastone e coltello nella tradizione dell'arte marziale pugliese: distanza, tempismo, coordinazione tra le due armi. Un percorso tecnico, non solo di autodifesa, guidato da Claudio Genovesi — 50 anni di pratica nelle arti marziali.
>
> Via Giuseppe Milano 7, Vercelli. Pre-iscrizioni aperte — link in bio. Ingresso riservato ai soci.
>
> #ArtiMarziali #BastoneEColtello #TheCrewVercelli #Vercelli #AllRounderGym

Barra istruttore: CLAUDIO GENOVESI — "50 anni di pratica nelle arti marziali."
⚠️ **Riga pratica (orario) non scritta**: il calendario non indica un orario per questo corso specifico e non l'ho inventato. Confermalo tu prima di mandarlo in Canva.
Audio suggerito: percussioni cinematiche leggere, tensione controllata (stessa categoria di Iaido — non è nel brief originale, è un'estensione ragionevole mia, correggimi se non va bene).

### 2. Yoga — Giulia La Rocca (01/09, 18:30) — ✅ foto reale disponibile

*Didascalia aggiornata il 27/08 con il testo reale già usato nella locandina che mi hai mandato — al posto della mia bozza precedente.*

> Radicati come la montagna, fluidi come l'acqua.
>
> Hatha Yoga: postura, respiro, equilibrio. Per ogni corpo, per ogni età. Con Giulia La Rocca, insegnante di Hatha Yoga.
>
> 1 settembre, ore 18:30. Via Giuseppe Milano 7, Vercelli. Pre-iscrizioni aperte — link in bio. Ingresso riservato ai soci.
>
> #Yoga #HathaYoga #TheCrewVercelli #Vercelli #AllRounderGym

Barra istruttore: GIULIA LA ROCCA — "Insegnante di Hatha Yoga".
Simbolo: ॐ — già usato nella locandina reale, verificato.
Foto: usa la meditazione su roccia/lago (già nella cartella foto) — è la stessa che hai già usato, oppure una delle altre 5 candid per varietà.
Audio: acustico calmo, ambient natura, piano leggero.

### 3. Iaido — Massimo Valentini (04/09, 19:00) — ✅ foto reale disponibile

*Didascalia aggiornata il 27/08 con i dati reali (orario, telefono, testo) presi dalle due locandine esistenti — al posto delle mie ipotesi/placeholder.*

> Trova la tua concentrazione attraverso la via della spada.
>
> Iaido: non solo arte marziale — meditazione in movimento, disciplina, controllo assoluto. Accessibile a tutti, uomini e donne di qualsiasi età. Con Massimo Valentini, 5° dan e oro agli Europei 2009.
>
> Martedì e venerdì, 20:00–22:00. Abbigliamento sportivo, attrezzatura in comodato d'uso. Prove gratuite — tel. 339 188 1034. Via Giuseppe Milano 7, Vercelli. Ingresso riservato ai soci.
>
> #Iaido #ArtiMarzialiGiapponesi #TheCrewVercelli #Vercelli #AllRounderGym

Barra istruttore: MASSIMO VALENTINI — "5° dan Iaido — oro Europei 2009".
Simbolo: 居合道 — già usato nella locandina reale, verificato (non lo sto generando io ora, lo riprendo da lì).
Foto: nuova foto B/N in azione (nella cartella) come alternativa/variante alla posa già usata — entrambe reali.
Nota: la vecchia locandina del dojo di Massimo cita anche un sito e una mail separati (jikishinkandojo.it) — non li ho messi nel post di The Crew, restano il suo canale a parte.
Audio: percussioni cinematiche leggere, tensione controllata.

### 4. Tai Chi - Qi Gong — Claudio Genovesi (08/09, 19:00)

> Forza lenta, mente ferma.
>
> Tai Chi e Qi Gong: movimento lento, respiro guidato, radicamento. Claudio Genovesi accompagna un lavoro che allena corpo e mente insieme, adatto a ogni età — 50 anni di pratica nelle arti marziali.
>
> 8 settembre, ore 19:00. Via Giuseppe Milano 7, Vercelli. Pre-iscrizioni aperte — link in bio. Ingresso riservato ai soci.
>
> #TaiChi #QiGong #TheCrewVercelli #Vercelli #AllRounderGym

Barra istruttore: CLAUDIO GENOVESI — "50 anni di pratica nelle arti marziali."
⚠️ Stesso avviso di Iaido sul simbolo/hanzi: non generato, verificare da fonte certa.
⚠️ **Anche a foto pronta**, ricorda: la vecchia versione ha un difetto testa/mano segnalato da te — non riusare quella foto senza pulizia in Canva.
Audio: ambient zen, strumentale calmo.

### 5. Sala Functional (11/09) — nessun istruttore fisso

> Non smettere di crederci.
>
> Sala Functional e Sala Pesi: bilancieri, kettlebell, anelli, corde. Spazio libero per allenarsi con il proprio metodo, o base per chi segue un percorso strutturato.
>
> Sala Pesi Open ad accesso libero, 16:00–20:00 lun-ven. Via Giuseppe Milano 7, Vercelli. Ingresso riservato ai soci.
>
> #Functional #SalaPesi #Allenamento #TheCrewVercelli #Vercelli #AllRounderGym

⚠️ **Adattamento mio, da confermare**: questo post non ha un istruttore, quindi ho sostituito la barra istruttore standard con un richiamo diretto alla Sala Pesi Open — non è nella spec del brief, è la scelta più sensata che ho trovato per un contenuto senza persona. Correggimi se preferisci diversamente.
Tagline presa da una scritta murale reale già fotografata ("Non smettere di crederci") — non inventata.
Audio: non specificato nel brief per questa categoria, non ne ho inventato uno.

---

## Prossimi passi

1. **Yoga e Iaido sono pronti**: didascalia + foto reali disponibili in `the-crew-social-foto/ricevute-27-08/` — mancano solo il template Canva e il caricamento.
2. **Da Lele**: foto per Tai Chi, Bastone&Coltello, Sala Functional (ancora mancanti).
3. **Da Lele**: costruire il brand template in Canva (spec completa in skill §2) — una tantum, ~15-30 min nell'editor.
4. **Da Lele**: decidere se e quando inserire Sara Lione (Hip Hop/Play&Dance) in calendario — materiale reale già disponibile, non l'ho aggiunta di mia iniziativa.
5. Boxe/Difesa personale/Kempo Kids restano in coda, non prioritari (nessuna foto, per scelta esplicita di Lele).
