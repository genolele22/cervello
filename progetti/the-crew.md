# Progetto — The Crew (gestionale ASD)

> **Rivedere entro:** 2026-12-06

**Cos'è:** gestionale completo per l'ASD Fight in Progress — libro soci a norma,
quote e iscrizioni, ricevute numerate, corsi e presenze, compensi collaboratori,
spese e contabilità, verbali del direttivo, notifiche, più il sito pubblico
della palestra. Quattro ruoli con aree separate: superadmin, istruttore, socio,
pubblico.
**Stato:** LIVE su **thecrewgym.com**, con soci veri dentro dal 24/08/2026.
**Priorità:** 1ª nella classifica del 22/08/2026 (gestionale ASD a norma).

**Stack:** Next.js 16 + React 19 + TypeScript + Tailwind 4 su Vercel (regione
`fra1`), database Supabase/PostgreSQL. Stripe per gli incassi, Nodemailer su
SMTP Gmail + imapflow per la copia in Inviati, webhook Telegram, `unpdf` per gli
estratti conto. PWA installabile con notifiche push.
**Repo:** `/home/genolele22/progetti/the-crew`, branch `master`, remote GitHub
privato via SSH (`genolele22/the-crew-gym`). 324 commit dal 01/08/2026.
**Mappa del repo:** `docs/MAPPA.md` — aree, tabelle e cosa lo rompe.
**Controlli:** `docs/coerenza.sql` — 7 query che devono restituire zero righe.

**Il peso sta nel database, non nell'interfaccia:** 66 tabelle, 161 policy RLS,
76 funzioni, 71 trigger, 135 migrazioni numerate. Numerazione ricevute,
conteggio ingressi e scadenze le calcola Postgres. Chi cambia una regola di
dominio cerca la migrazione, non il componente.

**Numeri veri al 06/09/2026:** 218 persone in anagrafica, 203 ammissioni a libro
soci, 123 iscrizioni attive, 9 collaboratori, 18 corsi, 417 ricevute emesse nel
2026, 17.215 € incassati nel 2026.

**Doppia natura, da tenere distinta:** oggi è il gestionale *della sua palestra*.
Diventare **prodotto vendibile** (canale ipotizzato: un commercialista che
rivende) è un'altra cosa e non è ancora deciso — vedi
`the-crew-brief-prodotto-b2b.md`. Da quella decisione dipende il lavoro più
costoso in assoluto: oggi un cliente = un progetto Supabase a sé, e il
multi-tenant significa riscrivere tutte e 161 le policy.

---

## Stato

Stato: in produzione — 07/09/2026, **bonifica di dati, sicurezza e reversibilità**
  (giornata lunga, il dettaglio sta nei task pendenti). Chiuse verso l'esterno tre
  funzioni raggiungibili con la sola chiave pubblica del sito e due funzioni morte
  ancora invocabili. Reso impossibile registrare due volte lo stesso pagamento.
  Corretta la data di inizio abbonamento, che a chi tornava dopo una pausa
  rubava i giorni di assenza. Libro soci ripulito dai nominativi di collaudo e
  blindato. Estesa la tracciabilità ai registri che prima non lasciavano traccia,
  e aggiunta una via d'uscita dal verbale confermato per errore. Chiuso il buco
  che sdoppiava le anagrafiche. Sistemati cruscotto, allarmi e ordine degli elenchi.
Deciso: **quota associativa per anno solare** (gen-dic), mai per stagione;
  **abbonamenti a durata di tipologia** dal giorno in cui si fanno, solo Kalèido
  è stagionale; **l'assicurazione copre anche i non soci**, quindi non è un
  argomento per sollecitare la quota; **niente inviti in blocco** — chi rientra
  passa dalla pre-iscrizione e l'invito parte da solo; oltre **15 giorni** di
  ritardo sul rinnovo la data d'inizio non si decide da soli, si chiede.
Aperto: due soci si allenano **senza certificato medico** · 9 ammissioni senza
  quota (verbale del 01/09) · quattro incoerenze anagrafiche di cui una senza
  percorso legittimo per correggerla · **ripristino del backup mai provato** ·
  consuntivo banca/cassa senza diagnosi · 7 note di logbook.
Prossimo passo: **il sito pubblico**, che non convince Lele. Sul gestionale,
  i due certificati mancanti: riguardano persone che si allenano adesso.

---

## Stato al 07/09/2026 (mattina)

Stato: in produzione — 07/09/2026, giornata di **bonifica dati e sicurezza**.
  Chiuse tre funzioni `security definer` che erano eseguibili da chiunque avesse
  la chiave pubblica del sito, ed eliminate le due `registrati_collaboratore`
  morte dal 28/08 (0137). Corretti: il filtro "Rata non pagata" che ignorava la
  data di scadenza, il generatore dei verbali che riproponeva 113 persone già
  socie, il contatore "da regolarizzare" (18 → 2), la campanella delle notifiche
  che usciva dallo schermo. Unite le schede doppie dei due Lo Bianco e chiuso il
  buco che le aveva create. Nuovo allarme "si allena con la quota scaduta".
Deciso: la **quota associativa va per anno solare** (gen-dic), mai per stagione;
  gli **abbonamenti scadono per durata della tipologia** dal giorno in cui si
  fanno, solo Kalèido è stagionale; l'**assicurazione copre anche i non soci**,
  quindi non è una motivazione per sollecitare la quota.
Aperto (dal controllo incrociato di fine giornata, in ordine di gravità):
  2 soci si allenano **senza certificato medico** (Sejdic, Gallo) · 4 incoerenze
  di libro soci · residui di collaudo vivi (Socio Prova, Regolare ZZSTRESS) ·
  210 spese non agganciate all'estratto conto, ed è il motivo per cui il
  consuntivo non quadra banca e cassa · le 9 ammissioni senza quota del 01/09.
Prossimo passo: i due certificati mancanti — riguardano persone che si allenano
  adesso.

---

## Stato al 06/09/2026

Stato: in produzione — 06/09/2026: giro sul **metodo**, non sulle funzioni.
  Aggiunta `nota_logbook.scoperto_da` (migrazione 0135): chiudendo una nota si
  dice come è emerso il difetto — utente, caso, collaudo, test, sentinella — e
  in cima alla pagina c'è il riepilogo di chi li trova. È l'unica misura che
  dice se il modo di lavorare funziona. Creati `docs/MAPPA.md` e
  `docs/coerenza.sql`. Deploy verificato (Age 1m).
Deciso: 06/09/2026 — la fascia di numerazione **≥ 9000 è riservata ai collaudi**
  e non entra mai nella sequenza fiscale vera (di fatto era già in uso: la
  ricevuta 9001/2026 è una prova del 07/08). Gli eventi di libro soci
  precedenti al 01/08/2026 sono storico importato e restano fuori dai controlli.
Trovato e **non** risolto (dati di persone vere, decide Lele):
  - **41 inviti** creati il 16-17/08 risultano ancora `in_attesa` ma sono
    scaduti dal 30/08. Sono gli stessi dell'incidente del 04/09: la causa è
    corretta, le righe no. Da verificare se quelle persone riescono a entrare.
    → **RISOLTO il 07/09**: cancellati su richiesta di Lele, quelle persone
    tornano "mai invitate". Restano i 4 dello stesso giro che erano stati usati.
  - **9 ammissioni** al libro soci da agosto in poi senza quota incassata: sono
    quelle del verbale confermato dall'agente in 14 secondi il 01/09. Mai
    ripulite.
Prossimo passo: decidere su quei due elenchi; poi la scelta vera —
  **The Crew resta il gestionale della palestra o diventa prodotto?**

---

## Deciso: niente inviti in blocco (07/09/2026)

Gli inviti ad attivare l'accesso **non si mandano a tappeto**. Chi non ha
l'accesso e non torna in palestra non è un problema da risolvere: quando
rientra compila la pre-iscrizione, il sistema lo riconosce come socio già
esistente, e l'invito parte da solo alla conferma. Semplice e senza valanghe.

Perché regge solo da oggi: prima il codice trovava l'invito vecchio «in
attesa» e non ne generava uno nuovo (caso Rosa Di Gregorio, 04/09: accettata,
nessuna mail). Ora l'invito scaduto viene annullato e rigenerato, e sulla
scheda di ogni socio c'è il riquadro «Accesso al sito» con lo stato reale e il
pulsante per mandarlo, che verifica nel registro se è partita davvero.

I 41 inviti spediti in blocco il 16-17/08 sono stati cancellati: quelle
persone risultano «mai invitate», che è la verità.

## Come si lavora qui

- **Collaudo con dati finti nel DB reale**, poi rimossi. Attenzione: una riga
  "TEST" può avere ricevute numerate vere agganciate. Per incassi e ricevute si
  **storna** (`rimborsato_il`), non si cancella.
- **Il collaudo RLS si fa via SQL diretto**, mai con un GRANT per colonna. E un
  collaudo fatto da superadmin non dimostra niente sugli altri tre ruoli.
- **Niente service role key in locale** (è sempre vuota, ed è comunque bloccata
  dal sandbox): si passa dal tool MCP di Supabase, `execute_sql` /
  `apply_migration`.
- **Deploy dopo ogni sessione**, e si verifica l'**età** del deployment, non un
  HTTP 200.
- **Il tetto fail-closed sulle email non si aggira mai** (migrazione 0111, max 3
  al giorno allo stesso indirizzo): esiste perché il 26/08 sono partite ~3.000
  mail in due giorni, 577 alla stessa persona, e Google ha bloccato la casella
  dell'ente.

## Aperti / sospesi

- Bug "Indietro" su dispositivo, `numero_rate_online` Kalèido, ~130 inviti
  storici, gruppo "Claudio" (lasciato apposta, diventerà altro).
- Nessun test automatico, nessuna CI, nessun ambiente di prova separato.
- Betatest a 4 ruoli fatto da Claude come acquirente (agosto): mancano
  onboarding di un cliente nuovo, e i canali WhatsApp/Telegram sono finti.
- Azzeramento dei dati di collaudo quando Lele dà l'ok all'uso pieno.

## File collegati nel vault

- `fight-in-progress.md` — l'associazione (soldi, collaboratori, struttura)
- `the-crew-brief-prodotto-b2b.md` — l'ipotesi prodotto, rimandata
- `the-crew-brief-pubblicita-asd.md` — la campagna per la palestra
- `the-crew-social-calendario.md` — contenuti social THE CREW
- `the-crew-migrazioni/` — note sulle migrazioni
