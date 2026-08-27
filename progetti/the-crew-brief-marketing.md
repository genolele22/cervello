# The Crew — dossier di riferimento

*Documento preparato il 27/08/2026 per uso come project knowledge in un progetto Claude.ai dedicato alla campagna pubblicitaria/social. Contiene solo fatti verificati su codice, database di produzione, sito live e documenti già prodotti — nessuno slogan, nessun post, nessun copy pubblicitario. Quello lo scrive il progetto a valle, con questo materiale come base.*

---

## 1. Cos'è, in breve

**The Crew** è un gestionale completo per associazioni sportive dilettantistiche (soci, quote, ricevute, corsi, compensi, verbali, certificati), nato dentro un'associazione vera — **A.S.D. Fight in Progress**, Vercelli, affiliata CSEN (Registro nazionale n. 35051) — per sostituire un gestionale generico inadatto alle ASD. È in uso quotidiano reale dal luglio/agosto 2026. Include anche il sito pubblico della palestra, **thecrewgym.com**.

Dal 19/08/2026 esiste anche un secondo obiettivo, parallelo al primo: portare lo stesso software sul mercato come prodotto per altre associazioni sportive, con il nome **Crew** (senza "The" — vedi §5), attraverso uno studio commercialista che già segue ASD.

Questi sono **due usi diversi dello stesso codice**, e quindi due possibili campagne — vedi §3.

---

## 2. Origine e stato attuale

**Timeline essenziale:**
- **01/08/2026**: decisione di costruire da zero (scartata l'alternativa low-cost Sheets+Stripe+Make: il risparmio economico è quasi nullo, il guadagno vero è conformità normativa e controllo). Stack scelto: Next.js + Supabase + Stripe + Vercel.
- **01–19/08/2026**: sviluppo a fasi (F0 fondamenta → F7 sito pubblico), in produzione reale con dati veri dell'associazione.
- **19/08/2026**: decisione di trasformarlo in prodotto vendibile ad altre ASD (nome "Crew", dossier commerciale scritto, ambiente demo pubblicato).
- **19–26/08/2026**: sviluppo continuo sul gestionale reale (nuove funzionalità, correzioni, un incidente di invii email diagnosticato e risolto — vedi §9).

**Cosa è live oggi** (per l'associazione reale, verificato su codice e database):
- Sito pubblico su dominio proprio, gestionale multi-ruolo, pagamenti con carta via Stripe **collaudati con denaro vero** (incluso un rimborso reale), libro soci digitale, ricevute numerate, verbali, compensi collaboratori, backup notturno automatico.

**Cosa è ancora parziale o non collaudato** (onestà necessaria, vedi anche §10):
- Rateizzazione/addebito ricorrente: mai esercitata su un caso reale.
- Certificati medici: caricato per una sola persona su ~190.
- Scadenze di legge istruttori: popolate ma poco esercitate.

**Nota metodologica**: diversi numeri in questo documento (§7) sono un'istantanea misurata il 19/08/2026 e presa da un dossier interno già scritto in quella data — non un conteggio aggiornato in automatico. Il prodotto ha continuato a crescere da allora.

---

## 3. Due pubblici, due campagne possibili

| | **B2C — la palestra** | **B2B — il software** |
|---|---|---|
| Cosa si vende | Iscrizione/corsi alla palestra Fight in Progress | Il gestionale "Crew" in abbonamento |
| A chi | Persone a Vercelli e dintorni (famiglie, adulti, chi cerca danza/combattimento/discipline olistiche) | Altre ASD/palestre, raggiunte tramite uno studio commercialista che le segue già |
| Vetrina | thecrewgym.com (già online, contenuti reali) | Ambiente demo separato: the-crew-demo.vercel.app |
| Materiale pronto | Sito pubblico con copy reale (§4), identità visiva (§5) | Dossier commerciale + presentazione prodotto già scritti (§8), numeri di prodotto (§7) |
| Stato della campagna | Da costruire (nessuna campagna ads/social attiva oggi, solo Instagram organico) | Da costruire (nessun cliente esterno ancora, canale identificato ma non attivato) |

Questo documento copre entrambe le piste. Il §4 e il §5 servono soprattutto per B2C; il §6, §7, §8 per B2B; §9 e §10 servono a entrambe.

---

## 4. Il sito pubblico oggi (thecrewgym.com) — materiale per il lato B2C

Verificato dal vivo il 27/08/2026.

**Claim e tono reali della home**: *"Combatti. Balla. Respira."* — sottotitolo *"Una palestra sola, ogni disciplina che ti serve"*. Tono diretto, energico, inclusivo; frasi imperative brevi alternate a un registro più disteso ("rallentare il passo", "ritrovare il respiro"). Tre pilastri dichiarati: **Combattimento, Danza, Olistico**.

**Struttura pagine pubbliche**: Home · Corsi · Palinsesto · Staff · Chi siamo · Pre-iscrizione · Informativa privacy · (aree riservate dietro login: gestionale, istruttore, socio).

**Corsi (18 attivi, elenco reale dal sito)**:
Bastone & Coltello · Boxe · Corso adulti hip hop (Kalèido) · Dancehall kids/teens (Kalèido) · Dancehall ragazzi/e (Kalèido) · Difesa personale & Bastone da passeggio · Female (Kalèido) · Heels (Kalèido) · Hip Hop kids/teens (Kalèido) · Hip Hop ragazzi/e (Kalèido) · Iaido · Kempo Kids (6–12 anni) · Play & Dance (3–6 anni) · Pukulan Pentjak Silat Sera · Sala Pesi Open · Soft Functional · Tai chi - Qi gong · Yoga.

Non è quindi (nonostante il nome "Fight in Progress") una palestra di sole discipline da combattimento: danza e discipline olistiche pesano quanto o più del combattimento nell'offerta reale.

**Staff pubblicato (7 istruttori con bio/citazione reali)**:
- **Claudio Genovesi** — Karate, Shorinji Kempo, Difesa Personale, Bastone e Coltello Pugliese, Qi Gong; 50 anni di esperienza.
- **Aurora Denaro** — Hip-Hop e Heels, 10 anni di insegnamento, diplomata Modulo Factory Milano, esperienza in videoclip/TV/brand. *"W la danza fatta col cuore!"*
- **Giulia Rago** — solo foto, bio non ancora compilata.
- **Sara Lione** — Hip Hop, educatrice, laureata Scienze dell'Educazione. *"Amo i bambini perché insieme a loro posso finalmente smettere di fingere di essere adulta"*.
- **Giulia La Rocca** — Hatha Yoga, oltre 10 anni di pratica. *"Piccoli passi, grandi progressi!"*
- **Massimo Valentini** — Iaido (5° dan), Kendo (1° dan), medaglia d'oro europei 2009. *"七転び八起き"* (proverbio giapponese, cadere sette volte alzarsi otto).
- **William Aliati** — Pukulan Pentjak Silat Sera, 10 anni di pratica.

Le foto sono tutte in formato medaglione circolare in stile Ensō pennellato (vedi §5).

**Chi siamo — sintesi del posizionamento reale**: *"La stessa persona può allenarsi con la boxe un giorno, ballare il successivo e chiudere la settimana con il tai chi — qui non serve scegliere una sola identità sportiva."* Denominazione legale A.S.D. Fight in Progress, marchio THE CREW — All Rounder Gym, affiliata CSEN. Sede: via Giuseppe Milano 7, Vercelli. Contatti: fightinprogress@gmail.com, Instagram **@the_crew_fitandfight** (unico social attivo, Facebook escluso per scelta esplicita).

**Palinsesto**: settimana su 6 giorni (lun–sab), 4 spazi (Sala corsi, Sala functional, Tatami, più la Sala Pesi Open ad accesso libero 16–20 lun–ven). Danza concentrata lun/mar/gio, Boxe lun/gio/ven, martedì è il giorno con più varietà (7 corsi diversi), sabato una sola attività mattutina.

---

## 5. Identità di marchio (materiale utile per la grafica della campagna)

**Tre nomi distinti, da non confondere**:
| Nome | Dove si usa |
|---|---|
| **THE CREW — All Rounder Gym** | marchio della palestra: sito, interfaccia, social |
| **A.S.D. Fight in Progress** | ente giuridico: ricevute, libro soci, contratti, verbali, informative privacy |
| **Crew** (senza "The") | nome scelto per il software come prodotto vendibile ad altre associazioni |

**Palette colori** (campionata dal file del logo, non a occhio — con varianti calcolate per contrasto WCAG):
| Ruolo | Hex | Origine |
|---|---|---|
| Antracite | `#192322` | contorni a pennello del logo |
| Giallo | `#F4C40A` | lettering "THE CREW" |
| Turchese | `#229494` | le onde del logo |
| Crema | `#F1E5CB` | il fondo carta |

Attenzione: giallo e turchese pieni su crema sono **illeggibili come testo** (contrasto 1.32:1 e 2.93:1) — vanno usati come superficie con testo antracite sopra, mai come colore di testo. Esistono varianti scure per testo/link (turchese testo `#1A7272`, verde stato `#186B42`, rosso stato `#A93226`).

**Motivi grafici ricorrenti**:
- **Ensō**: il cerchio zen tracciato in un gesto solo, mai chiuso — è il tratto del logo che Lele chiama "il cerchio del tao". Usato come motivo di sfondo e come cornice per le foto dello staff (medaglioni).
- **Onda**: una striscia divisoria che richiama le onde del logo, con filo turchese sulla cresta.
- Font display **Bebas Neue** (condensato, maiuscolo) solo per i titoli grandi del sito pubblico — mai nel gestionale.
- **Nessuna modalità scura**: scelta deliberata, il marchio ha un fondo caldo che una dark mode tradirebbe.

Tre sale fisiche hanno ciascuna un colore fisso (Sala corsi blu, Tatami viola, Sala functional ruggine) usato ovunque nell'interfaccia, sempre affiancato dal nome (mai il solo colore).

---

## 6. Funzionalità del gestionale (lato B2B/prodotto)

**Anagrafica e libro soci**
- Persona ≠ socio ≠ account: un genitore gestisce N figli minori.
- Libro soci **append-only**: nessuna riga si modifica o cancella, solo si aggiunge (una correzione è un nuovo evento di rettifica) — imposto a livello di database, nemmeno l'amministratore può aggirarlo.
- Numerazione progressiva mai riassegnata.
- Decadenza automatica per mancato rinnovo quota, annotata nel libro soci.
- Consensi GDPR separati (rapporto associativo / dati sanitari / comunicazione all'ente di affiliazione) — mai un unico "accetto tutto".
- Import storico da CSV/Excel con validazione codice fiscale (checksum) e deduplica.

**Quote, pagamenti, ricevute**
- Ricevute numerate progressivamente per anno solare, a prova di due operatori simultanei (blocco di riga), riparte da 1 ogni anno.
- Multi-metodo: contanti, bancomat, bonifico, Satispay, carta (Stripe), omaggio (senza sporcare cassa/consuntivo).
- Pagamento online con carta **collaudato con denaro vero, rimborso incluso** (nonostante il README del repository dica ancora genericamente "da attivare" — è testo residuo dell'impostazione iniziale, superato dai fatti: i pagamenti Stripe sono live e testati).
- Rate su abbonamento stagionale, sconti a percentuale o cifra secca con motivo obbligatorio, storno (mai cancellazione) per correzioni su incassi già numerati.
- Erogazioni liberali con causale a norma (art. 15 TUIR).

**Corsi, palinsesto, certificati**
- Tipologie di ingresso configurabili da pannello (non hardcoded), anche multi-corso.
- Certificato medico caricabile dal socio via telefono; l'istruttore vede solo "in regola sì/no" e la scadenza, **mai il file né il tipo di certificato** (dato sanitario, accesso ristretto per costruzione).
- Vista "oggi in palestra": chi è atteso, chi non è in regola, appello presenze.
- Sito pubblico e palinsesto generati dagli stessi dati (nessun doppio inserimento).

**Collaboratori e compensi**
- Compenso calcolato sull'incassato effettivo, mai sul dovuto; regola versionata nel tempo (cambiare percentuale non altera i conti degli anni passati).
- Rimborsi spese solo con giustificativo allegato, esclusi dalle soglie di calcolo.
- Tipi di compenso configurabili (percentuale sull'incassato, o incassato meno una detrazione fissa per lezione svolta).
- Calendario del collaboratore: corsi pianificati in automatico + lezioni individuali/masterclass annotate da lui, con compenso dichiarato; il superadmin può assegnare alla palestra una percentuale o cifra fissa su ogni impegno extra.
- Scadenze di legge (visita medica, formazione sicurezza, certificato antipedofilia) tracciate per singolo collaboratore.

**Verbali e governance**
- Verbali di assemblea/consiglio direttivo con storico delle modifiche, collegati ai soci deliberati.
- Bozza settimanale generata in automatico dalle nuove adesioni, confermata sempre da una persona — mai pubblicata da sola.

**Comunicazioni**
- Email libera ai soci (singola o in blocco, mai in copia unica per privacy).
- Notifiche in-app (icona a campanella, interruttore per tipo di notifica, generate da un cron notturno).
- Tracciabilità: ogni email inviata resta anche in "Posta inviata" (copia via IMAP), non solo spedita.
- **Tetto anti-valanga fail-closed**: ogni invio passa da un unico punto che conta gli invii per destinatario (max configurato al giorno); se il conteggio non è verificabile, l'email non parte. Introdotto dopo un incidente reale (vedi §9).

**Ruoli e sicurezza**
- Tre ruoli: chi amministra (tutto), chi insegna (solo i propri corsi/allievi/compenso), il socio/genitore (solo la propria posizione e quella dei figli). Un quarto ruolo (responsabile di sezione) è stato progettato ma non costruito, per un eventuale scenario polisportiva (vedi sotto).
- Permessi imposti dal database (Row Level Security), non dalla sola interfaccia — verificato ripetutamente entrando con l'identità reale di ruoli diversi, non solo ispezionando il codice.
- Dati giudiziari (casellario) e sanitari (certificati) in storage separato con accesso loggato.

**Affidabilità**
- Backup automatico ogni notte, con notifica di conferma.
- Conferma visibile dopo ogni salvataggio (pattern uniformato su ~30+ punti dell'interfaccia dopo che si era scoperto che mancava).
- Pagina di errore globale (mai una schermata di crash grezza).

**Altro**
- PWA (installabile da telefono).
- Reportistica: consuntivo per categoria di bilancio, riconciliazione contro l'estratto conto bancario (con controllo di coerenza obbligatorio sul PDF caricato).
- Testi del sito pubblico modificabili da pannello, senza toccare il codice.
- **Studio di progettazione già scritto ma non costruito**: gestione di una polisportiva a sezioni (più discipline con conti separati che confluiscono in un bilancio unico) — architettura pensata, in attesa di un caso reale su cui costruirla.

---

## 7. Il prodotto in numeri (istantanea del 19/08/2026, misurata su codice e database di produzione)

| Metrica | Valore |
|---|---|
| Persone in anagrafica | 192 |
| Soci a libro | 189 |
| Ricevute emesse | 548 |
| Verbali confermati | 23 |
| Incassato tracciato | € 15.822 |
| Righe di registro modifiche (audit log) | 3.659 |
| Righe di codice applicativo | 28.933 (+ 6.609 di schema dati) |
| Tabelle database | 50 |
| Migrazioni | 86 |
| Regole di accesso a livello di database (RLS) | 125 |
| Tempo di costruzione del prodotto base | 1–19 agosto 2026 (~19 giorni) |
| Dimensione database di un'associazione reale | 21 MB |

Maturità per modulo (dallo stesso dossier): **collaudati con dati reali** — libro soci, ricevute, incassi multi-metodo, pagamento carta+rimborso, verbali, sito pubblico. **Parziali** — compensi/liquidazioni, spese/consuntivo, scadenze di legge istruttori. **Non ancora validati** — certificati medici (1 caricato su 192), rateizzazione (0 contratti mai attivati in produzione).

---

## 8. Modello di vendita B2B (Crew come prodotto)

**Canale**: non si costruisce una rete commerciale — uno studio commercialista che già segue associazioni sportive lo propone ai propri clienti. Il primo livello di assistenza (domande d'uso) resta allo studio; il secondo livello (guasti veri) arriva filtrato — è la condizione che rende il servizio sostenibile per una persona sola.

**Ambiente demo pubblico**: `the-crew-demo.vercel.app` — login `demo@the-crew-demo.test`, dati tutti finti, denominazione neutra "A.S.D. Demo Sport", **sola lettura vera** (imposta da un trigger di database, non aggirabile nemmeno bypassando l'interfaccia), su un progetto Supabase separato da quello reale.

**Tre modelli di prezzo allo studio (ipotesi di lavoro, non ancora negoziati)**:
1. **Prezzo all'ingrosso** — lo studio paga una quota fissa per associazione attivata e fissa liberamente il prezzo finale.
2. **Ripartizione del canone** (60% sviluppo / 40% studio) — es. a 30 associazioni da 40€/mese: 720€ allo sviluppo, 480€ allo studio.
3. **Licenza di studio a forfait** — es. 6.000€/anno per attivare associazioni illimitate: conviene di più allo studio quante più ne attiva.

**Perché l'architettura deve cambiare prima di scalare**: il database è oggi mono-associazione (nessuna riga sa a quale cliente appartiene). Passare a una base dati condivisa non è facoltativo per questo canale: lo studio ha bisogno di una vista d'insieme su tutte le sue associazioni, e i conti dell'infrastruttura non reggono un'installazione a sé per ogni cliente (a 50 associazioni, differenza stimata di circa 5.900 $/anno). È anche il lavoro più rischioso (tocca 50 tabelle e 125 regole di accesso).

**Costi di infrastruttura professionale stimati**: Vercel Pro 20$/mese + Supabase Pro 25$/mese, più voci ancora da quotare (posta transazionale con dominio proprio, monitoraggio errori, prova di ripristino cronometrata) — oggi mancanti.

---

## 9. Punti di forza onesti (per chi scriverà il copy)

- **Nato da un uso vero**, non da un capitolato scritto a tavolino: ogni regola (rate stagionali, pagamenti misti contanti/carta, doppio calendario anno-sociale/stagione-sportiva) viene da dati reali di un'associazione che li usava già, non da un'ipotesi.
- **I vincoli di legge sono nella struttura dati**, non nella disciplina di chi digita: libro soci append-only, numerazione ricevute a prova di concorrenza, dati sanitari e giudiziari isolati per costruzione, non per convenzione.
- **Rigore dimostrato sugli incidenti**: un bug ha causato un invio ripetuto di email a un socio (centinaia di copie in due giorni, fino al blocco dell'intera casella email dell'ente da parte di Gmail). È stato diagnosticato a fondo (causa reale: un trigger di sicurezza troppo largo combinato con un cron che spediva prima di registrare l'esito) e corretto su due livelli distinti: il bug specifico, e un tetto strutturale fail-closed su **qualunque** email futura, per qualunque causa. Due falle di sicurezza trovate durante un collaudo sono state corrette lo stesso giorno in cui sono emerse. È materiale utile per dimostrare processo, non da nascondere.
- **Sito pubblico e gestionale nascono dagli stessi dati**: corsi, palinsesto e staff sul sito sono generati dal gestionale, non duplicati a mano.

## 10. Limiti attuali — da non promettere

- **Rateizzazione e addebito automatico**: mai esercitati su un caso reale in produzione.
- **Certificati medici**: il flusso esiste ma è validato su una persona sola.
- **Nessun logo neutro** per un uso white-label: il file immagine del logo ha ancora il nome della palestra disegnato dentro; il nome testuale "Crew" è già parametrico via variabile d'ambiente, il file grafico no.
- **Il database è mono-associazione oggi**: l'isolamento fra più clienti esiste solo creando installazioni separate (come la demo), non ancora come prodotto multi-cliente su base condivisa.
- **Nessun monitoraggio automatico degli errori**: un guasto si scopre perché qualcuno se ne accorge, non perché un sistema avvisa.
- **La posta parte da una casella Gmail personale**, non da un dominio/servizio email professionale — inadeguato per un servizio venduto a più clienti (limiti di invio, recapito non garantito, mittente non professionale).
- **Continuità a rischio**: le credenziali dell'infrastruttura sono in capo a una persona sola; non esistono ancora deposito del codice presso terzi, secondo accesso documentato, o procedura di uscita scritta.
- **Attivazione di un nuovo cliente non è autonoma**: richiede oggi interventi manuali sul database.
- **Onboarding sito/gestionale**: nessun manuale utente ancora scritto per segretari/volontari non esperti di tecnologia.

---

## 11. Stack tecnico (in breve)

Next.js (App Router) + TypeScript + Tailwind CSS, Supabase (Postgres, autenticazione a magic link, storage file, permessi a livello di riga), Stripe per i pagamenti con carta, Vercel per hosting/deploy/cron. Repository privato su GitHub. Nessun test automatico: il collaudo di ogni modifica si fa con dati finti creati nel database reale, verificati e poi rimossi — scelta esplicita del committente, non un'assenza per trascuratezza.

---

## 12. Fonti di questo documento

Codice e database del repository `the-crew` (letto il 27/08/2026), sito live thecrewgym.com (fetch dal vivo), dossier commerciale "The Crew come prodotto" (19/08/2026), documento "Presentazione gestionale" (già scritto in forma quasi pubblicitaria — riusabile come riferimento di tono per il lato B2B), studio "Polisportiva a sezioni" (19/08/2026), `MARCHIO.md` e `CONTROLLO_CONFORMITA.md` del repository, cronologia di sviluppo (STATO.md e memoria di sessioni precedenti, 01/08–26/08/2026).

**Non incluso deliberatamente**: dati finanziari interni dell'associazione (bilanci, compensi individuali), dettagli anagrafici privati dei soci, contenuto del casellario giudiziale — nessuno di questi è pertinente a una campagna di prodotto o di palestra.
