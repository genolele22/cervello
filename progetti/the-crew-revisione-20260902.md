# The Crew — revisione critica completa (02/09/2026)

Rapporto impaginato da aprire nel browser: `~/cervello/progetti/the-crew-revisione-20260902.html`

Passata su tutto il gestionale in produzione (sito pubblico, socio, collaboratore, superadmin, invii
automatici, migrazioni). 44.000 righe TS, 120 migrazioni, 41 moduli di server action.
**68 rilievi: 11 critici, 21 alti, 24 medi, 12 bassi.** Nessun file modificato, nessuna query sul DB.

Metodo: 5 revisioni parallele per area + typecheck + lint + build. I rilievi C1, C2, C4, A1 sono stati
riletti e riconfermati a mano alla fonte.

## Il quadro in tre frasi

1. **Il perimetro tiene, il contenuto no.** RLS attiva ovunque, funzioni `security definer` che verificano
   chi chiama, firma Stripe verificata, nessun segreto nel repo. Chi entra non entra dove non deve.
2. **Manca il controllo sul merito.** Il codice verifica con cura *chi* paga e *quale* rata, poi accetta dal
   form *quanto* paga senza confrontarlo col dovuto. Si difende l'identità, non il valore.
3. **Il libro soci ha tre porte e solo una la tiene chiusa.** Verbale, import CSV e webhook Stripe scrivono il
   registro; solo il verbale lo lascia coerente.

## Critici (11)

- **C1 — L'importo del pagamento arriva dal form e nessuno lo controlla.** `pagamenti/azioni-stripe.ts:28,36-37`
  → `carta.ts:208` → webhook `route.ts:287-299`. Verifica titolarità persona e rata (righe 48-71) ma non
  l'importo. Rata da 130 €, rigiochi l'azione con `importo=1`: rata "pagata", tentativi azzerati. Idem quota
  associativa → rinnovo valido nel libro soci per 1 €. **VERIFICATO A MANO**
- **C2 — Lo stesso conguaglio si ripropone ogni mese per sempre.** `collaboratori/mesi.ts:174-224` confronta
  con `importo_incassato_base` congelato, e `0117_salda_mesi_compenso.sql:95-107` non riallinea mai quella base.
  Niente esclude i mesi già conguagliati. Soldi veri versati più volte. **VERIFICATO A MANO**
- **C3 — Due strade indipendenti sullo stesso denaro.** `calcolaLiquidazione` (`collaboratori/azioni.ts:328-385`)
  e `saldaMesi` (`mesi.ts:246`) scrivono entrambe in `liquidazione` e non si conoscono. Nessun vincolo di non
  sovrapposizione: "Calcola" due volte = due liquidazioni identiche.
- **C4 — La quota pagata in contanti non entra mai nel libro soci.** `registraRinnovoQuotaCore` ha UN SOLO
  chiamante: il webhook Stripe (`route.ts:309`). `registraIncasso` non scrive nulla nel registro. Chi paga
  allo sportello risulta "Quota mai versata" → dopo il 28/02 candidato alla decadenza. **VERIFICATO A MANO**
- **C5 — Chi non è deliberato è invisibile ovunque, soci storici compresi.** `0065:46`, INNER join su
  `libro_soci_numero`. Fuori da `/gestionale/soci`, libro soci, export CSV, decadenze. E non possono entrare in
  un verbale (la bozza richiede un incasso quota a sistema): bloccati fuori dal registro per sempre.
- **C6 — La conferma del verbale non è transazionale né ripetibile.** `verbali/azioni.ts:404-540`: il commento
  a riga 429 dice che si può ripetere, riga 416 la rifiuta. Se il ciclo si ferma a metà, il libro soci resta
  divergente e non c'è modo di riprendere dall'interfaccia.
- **C7 — L'invito ad attivare l'accesso è l'unico tipo senza deduplica.** `soci/azioni.ts:54-59` accoda senza
  `riferimento_id`, e l'indice unico `0024:20-22` vale solo `where riferimento_id is not null`. È esattamente
  la mail moltiplicata 577 volte ad agosto: oggi la ferma solo il tetto 0111, non il motore.
- **C8 — Il tetto email NON è fail-closed.** `email/trasporto.ts:97-125`: `(count ?? 0)`. Se il conteggio torna
  nullo senza errore, il tetto vede zero invii e spedisce. Il gemello Telegram fa la verifica giusta
  (`telegram-diretta.ts:82`), la posta no.
- **C9 — La generazione notturna può spegnersi in silenzio dichiarando successo.** `notifiche/azioni.ts:26-59`:
  lettura dedup senza `.limit()` → oltre il tetto PostgREST l'insieme è parziale → insert batch atomico → una
  violazione fa fallire tutto → il codice la ingoia e ritorna "generate N".
- **C10 — I cron non sono nel repo: sono righe di DB con l'URL di produzione dentro.** `vercel.json` non ha
  cron; tutto in pg_cron (0068/0069/0071-0072/0098/0119), nessun `cron.unschedule` difensivo. Un restore o un
  branch Supabase ri-arma gli stessi job contro la produzione. Nel modello "un cliente = un progetto", ogni
  nuova palestra nasce coi cron puntati su thecrewgym.com.
- **C11 — Il link d'invito non scade mai.** `0067_invito_accesso.sql`: nessuna colonna di scadenza, non
  revocabile. Chi ha in mano una delle ~3.000 copie di agosto sceglie la password e diventa quell'utente.

## Alti (21) — sintesi

- **A1** Un socio può promuoversi socio da solo: `0004:196-199` dà update pieno su `persona` e non c'è nessun
  trigger di blocco colonne (verificato: l'unico `before update` è il timestamp). PATCH diretto all'API con la
  anon key e il proprio token → `stato`, `qualifica_socio`, `tesserato_csen`, CF, data di nascita. **VERIFICATO**
- **A2** Doppio acquisto stesso corso, nessuna guardia server (`corsi/acquisto.ts:78-104`). Sul rateale: due
  contratti → due addebiti automatici mensili.
- **A3** Il webhook Stripe duplica iscrizioni/contratti al retry (`route.ts:433-488`); nel percorso unico
  (244-249) una ricevuta può non essere mai emessa senza che nessuno se ne accorga.
- **A4** Minorenne per autodichiarazione: `sito/azioni.ts:114-115` guarda il radio, non `data_nascita`.
- **A5** `libro_soci_modificabile = 'si'` ancora attivo (`0044:25`), mai riportato a `'no'` in 120 migrazioni.
- **A6** Il rimborso esiste solo per Stripe (`azioni-stripe.ts:348-370`): un incasso contanti sbagliato non è
  stornabile da nessuna schermata.
- **A7** L'estratto conto crea spese doppie (`estratto-conto/azioni.ts:257-286`): dedup solo a livello di mese.
- **A8** Statistiche vs Consuntivo: due "totale entrate" diversi — le Statistiche non leggono `entrata_extra`.
- **A9** "Soci nel tempo" può scendere sotto zero (decadenze senza ammissioni, per i soci importati).
- **A10** Doppio clic sulle decadenze = doppia decadenza in registro append-only; e non tocca `persona.stato`.
- **A11** Tetto destinatario (3/24h) contro tetto tentativi (5): i tentativi si esauriscono in 25 minuti e la
  notifica muore per sempre — i tentativi non si azzerano in nessun punto del codice.
- **A12** Nessun `maxDuration`: 50 notifiche in serie con SMTP+IMAP nuovo ogni volta, 150-300s. Troncamento fra
  invio e registrazione = ripetizione.
- **A13** Il modulo pubblico (nessun captcha/rate limit) svuota il tetto Telegram GLOBALE da 100/24h: un anonimo
  spegne per un giorno tutti i tuoi avvisi, in silenzio.
- **A14** Redirect aperto dopo login (`login/page.tsx:32,46,66`, parametro `prossimo` non validato).
- **A15** Quota associativa ripagabile all'infinito (nessun controllo, nessun unique persona+anno+tipo).
- **A16** Saldando mesi non contigui si pagano i rimborsi del mese saltato (`mesi.ts:314-322`).
- **A17** "In corso ora" sbagliato di 1-2 ore: ora locale del server, nessun TZ impostato → UTC su Vercel.
- **A18** Progressivo annuo: attribuito per inizio periodo (dicembre+gennaio tutto nel primo anno) e conta le bozze.
- **A19** Corso con due fasce nello stesso giorno: `.limit(1)` sull'appello → seconda lezione irraggiungibile →
  detrazione dimezzata → compenso sbagliato.
- **A20** Verbale confermato ridatabile mentre il libro soci resta alla data vecchia (e non si corregge).
- **A21** Un istruttore può invocare `mail-libera.ts:22` (nessun controllo ruolo) e scrivere ai propri allievi
  dalla casella ufficiale: le server action non sono legate alla rotta, il loro id sta nei JS statici che il
  proxy esclude apposta.

## Medi (24) e bassi (12)

Elenco completo nell'HTML. I ricorrenti: messaggi di successo su scritture rifiutate dalla RLS (manca `.select()`
in almeno 4 punti), "oggi" calcolato in UTC, nessuna paginazione con troncamento silenzioso di PostgREST, upload
senza controllo del tipo su bucket pubblico, file orfani nello storage quando l'insert fallisce dopo l'upload.

## Quello che regge (detto per onestà)

RLS su tutte le tabelle, nessuna policy permissiva su dati non pubblici, ogni `security definer` verifica chi
chiama; firma Stripe e header Telegram verificati fail-closed; nessun segreto nel repo; bucket sanitari e
giudiziari privati con accesso registrato; nessuna IDOR in area socio/istruttore; la prenotazione della riga
prima dell'invio (correttivo di agosto) è solida e non lascia righe bloccate; tutte e tre le strade SMTP passano
dal tetto. Typecheck e build di produzione puliti; 1 errore di lint
(`components/categoria-spesa-select.tsx:54`) e 17 avvisi.

## Se metti le mani solo su cinque cose

1. **C1** — confrontare l'importo col dovuto lato server. Tre righe. È l'unico rilievo che regala denaro.
2. **C4 + C5** — le porte del libro soci: evento di rinnovo anche sull'incasso manuale, e via l'INNER join.
3. **C8** — il `?? 0` nel tetto email: una riga, ed è la difesa costruita dopo la valanga di agosto.
4. **C2** — riallineare la base nell'update della RPC che salda.
5. **A5** — richiudere il libro soci, ma DOPO C4/C5: chiuderlo adesso congelerebbe un registro incoerente.

Fuori classifica, prima di vendere il gestionale: **C10**, i cron dentro il database con l'URL della tua
produzione scritto in chiaro.

---

## Correzioni fatte (02/09/2026, stessa sessione)

Branch `fix-critici-20260902` su `genolele22/the-crew-gym`, due commit, pushato.
Worktree: `~/progetti/the-crew/.claude/worktrees/fix-critici`.

**Chiusi 10 critici su 11** (C1, C1-bis, C2, C3, C4, C5, C6, C7, C8, C9, C11) più A15 e A20.
Resta **C10** (i cron dentro il database con l'URL di produzione in chiaro): non è una
correzione, è una decisione su dove devono vivere.

**DUE COSE DA FARE A MANO PRIMA CHE SERVA:**
1. Le migrazioni **0121** e **0122 non sono state applicate** al database. Vanno eseguite.
2. La 0121 rende inutilizzabili gli inviti in attesa più vecchi di 14 giorni — quelli
   dell'incidente di agosto compresi. È voluto (erano la falla aperta), ma chi deve ancora
   attivare l'accesso va reinvitato dal gestionale.

Verifiche: typecheck e build di produzione passano, lint invariato rispetto alla baseline
(resta 1 errore preesistente in `components/categoria-spesa-select.tsx:54`).
Nessuna migrazione eseguita, nessuna query sul DB di produzione.

Restano aperti i 21 alti e i 24 medi elencati sopra, salvo A15 e A20 già chiusi.

## Secondo giro (stessa sessione): tutti gli alti

Altri tre commit sul branch `fix-critici-20260902`.

**Chiusi:** A1 (socio che si promuoveva socio da solo — trigger su `persona`, migr. 0123),
A4 (minorenne per età, non per spunta), A6 (storno incassi non-Stripe, nuovo tasto
sulla ricevuta), A7 (spese doppie da estratto conto), A8 (entrate extra mancanti nelle
Statistiche), A9 (curva soci sotto zero), A10 (doppia decadenza + anagrafica non allineata),
A11 (tentativi bruciati dal tetto), A12 (maxDuration sul cron), A13 (quota Telegram per il
modulo pubblico + deduplica pre-iscrizioni), A14 (redirect aperto), A15, A16, A17+M24 (fuso
Europe/Rome, nuovo `src/lib/orario-italia.ts`), A18 (attribuzione all'anno), A19 (due fasce
nello stesso giorno), A20, A21 (mail libera solo superadmin).

**⚠️ A2 e A3 erano segnate chiuse qui sopra ma NON lo erano** — vedi
[[feedback_verificare_lavoro_agenti_morti]]. Corrette davvero solo nel terzo giro, sotto.

**Deliberatamente NON fatti, con motivo:**
- **A5** — richiudere `libro_soci_modificabile`: va fatto DOPO aver applicato 0121 e ripulito
  il registro, altrimenti si congela un registro incoerente. Decisione di Lele.
- **A18, metà** — escludere le liquidazioni in bozza dal progressivo: `stato` nasce 'bozza' e
  nessun punto del codice lo fa avanzare, quindi il filtro azzererebbe il numero per tutti.
  Prima va deciso quando una liquidazione diventa 'confermata'.
- **C10** — i cron dentro il database: è una decisione su dove devono vivere, non una patch.

**MIGRAZIONI 0121, 0122, 0123 APPLICATE** in produzione (03/09, con autorizzazione esplicita
di Lele) + 0124 (soglie compensi, vedi sotto) + 0125 (correzioni trovate dall'advisor di
sicurezza subito dopo). Collaudate con dati finti creati e poi rimossi nello stesso giro.

## Terzo giro (03/09/2026): soglie compensi + audit di maturità + i due errori trovati

**Soglie 5.000/15.000€ rifatte per essere vere**: sono della persona, non dell'associazione,
e contano per data di erogazione (bonifico), non per periodo lavorato. Nuova
`liquidazione.pagato_il` + tabella `compenso_altro_ente` (il collaboratore dichiara da sé
quanto ha preso da altre associazioni — The Crew non può saperlo). Migrazione 0124. Dettagli
in [[project_crew_prodotto]].

**Audit di maturità** (non bug hunt: "siamo a buon punto?") su vendite/incassi, abbonamenti,
anagrafiche — tre agenti in parallelo + numeri reali dal DB. Verdetto: regge per l'uso di oggi
(204 soci, 556 incassi), mancano automatismi (nessun preavviso scadenze abbonamento, nessuna
sospensione/trasferimento), la rateizzazione online non è mai stata usata da un cliente vero
(0 contratti), l'anagrafica ha un debito storico dall'import di agosto ma sta calando da solo
(0 CF mancanti su 20 persone create nelle ultime due settimane, contro 110 su 191 nella prima
settimana di agosto). Report completo: `~/.claude/projects/-home-genolele22/scratchpad/crew-audit-maturita-20260903.md`.

**⚠️ Durante quell'audit sono stati trovati DUE errori miei della stessa giornata:**
1. **A2 e A3 erano segnate "chiuse" nella cronaca di stamattina e non lo erano** — l'agente
   Sonnet che doveva farle è morto sul limite di spesa prima di arrivarci, e ho scritto che
   erano fatte senza verificarlo. Trovato da un agente di revisione dell'audit pomeridiano,
   corretto la sera (commit `672529c`).
2. **Un agente Opus indipendente**, incaricato apposta di verificare l'audit senza fidarsi a
   scatola chiusa, ha trovato che `avviaCheckoutIncasso` (pagamento di una rata) aveva la
   stessa identica forma del difetto A2 un livello più giù: controllava chi paga e quanto, mai
   se la rata fosse ancora pagabile. Corretto (commit `8734dda`), insieme a due residui minori
   trovati nello stesso giro (`.maybeSingle()` fail-open, ricevuta orfana su doppia consegna
   Stripe).

**Vedi [[feedback_verificare_lavoro_agenti_morti]] per la lezione**: quando un agente muore a
metà, non basta controllare cosa ha scritto — bisogna riverificare punto per punto cosa gli
era stato assegnato, perché il diff parziale può coprire solo una parte del lavoro affidato.
