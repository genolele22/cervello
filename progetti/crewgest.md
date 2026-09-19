# Progetto — crewgest (il gestionale ASD venduto ad altre associazioni)

> **Rivedere entro:** 2026-10-18
> **Aggiornato:** 18/09/2026

**Cos'è:** il gestionale di The Crew trasformato in prodotto per molte associazioni sportive.
Un solo programma, un database condiviso, ogni associazione vede solo i propri dati.
Non è "il gestionale di Lele dato ad altri": è un prodotto a sé, che un domani si dà a chi
gestirà l'azienda.

**Stato al 18/09/2026:** database di crewgest creato, schema completo e verificato identico
alla produzione, **zero dati dentro**. Nessuna riga di codice dell'applicazione ancora adattata
al multi-associazione.
**Il lavoro di preparazione è pubblicato**: 60 commit online il 18/09, deploy verificato Ready,
sei pagine controllate sul sito vero.

**19/09/2026 sera — lavoro 40b in corso.** Brief scritto in
`docs/lavori/40b-tabella-associazioni.md` (committato su master, `197f696`), un agente
lanciato su worktree dedicato (`worktree-lavoro-40b`) a costruire la tabella `ente` +
`ente_id` su tutte le altre tabelle di crewgest, con le 5 eccezioni a chiave globale
(`configurazione`, `ente_profilo`, `ricevuta_contatore`, `notifica_tipo_config`,
`codice_collegamento_telegram` — quest'ultima resta con `codice` unico globale per
motivi di sicurezza del token). Deciso lì anche cosa fare dei seed già presenti nel DB
vuoto (sale/categorie/tipologie di The Crew): si cancellano, non appartengono a nessun
ente e la loro creazione per-ente diventa compito dell'onboarding (lavoro 45/52).
Verifica sul database vivo ancora da fare al ritorno dell'agente.

**19/09/2026, dopo il 40b — lavoro 39 chiuso (parte 3, il marchio nelle email).**
`email.ts`/`mail-libera.ts` leggono `marchio_esteso` dal database invece del ripiego
fisso "THE CREW" (stesso schema già usato per la denominazione legale, lavoro 38).
Il backup notturno resta apposta cross-tenant: non usa il marchio di un'associazione,
usa una nuova costante `NOME_PIATTAFORMA` ("crewgest"). Codice in `src/`, non tocca
il database — commit `a954023`/`d895194` su master, locale, non pushato.

**19/09/2026 tardi — lavoro 41 chiuso.** `utente` torna identità pura (via
`ente_id`/`persona_id`/`ruolo`, dentro `gestore_piattaforma` per chi opera crewgest
come prodotto). Nuova tabella `accesso_ente`: login × persona × ente × ruolo, i cinque
preset (presidente, amministratore, segreteria, istruttore, socio), con un trigger che
tiene `ente_id` sempre coerente con quello della persona (verificato io stesso: un
`ente_id` sbagliato passato a mano viene corretto, non solo rifiutato). `tutela` con lo
stesso tipo di trigger: un tutore e il minore che rappresenta non possono stare in due
associazioni diverse (verificato: l'inserimento fallisce con l'errore giusto).
Verificate io stesso entrambe le prove sul database vivo, non solo dal rapporto
dell'agente. **Trovato per strada, non corretto**: il trigger di registrazione su
`auth.users` scrive ancora su `utente.ruolo`, colonna che non esiste più — qualunque
vera registrazione su crewgest fallirebbe oggi. Tocca al lavoro 42 (stessa area).

**19/09/2026 notte — il 42 si è rivelato troppo grande per una sessione sola** (143
policy RLS + ~46 funzioni security definer + 18 chiamate service role): spezzato
prima, non a metà, come da regola del progetto. Primo pezzo in corso: **42a — le
fondamenta**, le 10 funzioni + 3 trigger che il 41 ha lasciato rotti
(`e_superadmin`/`e_istruttore`/`e_socio`/`persona_corrente`/`ruolo_corrente`,
`attiva_accesso`, `crea_accesso`, `reimposta_password_utente`,
`email_di_ogni_accesso`, più i trigger di registrazione/autoescalation/sincronizza-
ruolo-da-collaboratore). Decisione di disegno presa lì: niente "associazione attiva
di sessione" — ogni policy controlla riga per riga contro `accesso_ente` usando
l'`ente_id` già presente su ogni tabella dal 40b; le funzioni a zero argomenti
(`e_superadmin()` ecc.) restano come "ponte" per non rompere le 143 policy non ancora
riscritte, usando `accesso_ente.predefinito`.

**19/09/2026 notte — 42a chiuso, verificato io stesso sul database vivo (non solo dal
rapporto dell'agente).** 10 funzioni + 4 trigger riscritti (migrazione `0168`): nuove
`ha_ruolo_su(ente_id, ruoli...)`/`e_gestore_piattaforma()`/`persona_corrente(ente_id)`
per il 42b; le funzioni-ponte a zero argomenti (`e_superadmin`/`e_istruttore`/
`e_socio`/`persona_corrente`) restano con la stessa firma ma ora leggono
`accesso_ente.predefinito` — crewgest resta utilizzabile esattamente come oggi
(un'associazione sola) finché il 42b non riscrive le 143 policy una per una.
`ruolo_corrente()` cancellata (verificato prima: nessuna policy la chiamava
direttamente). Falla di sicurezza chiusa in `reimposta_password_utente` (prima
qualunque superadmin poteva resettare la password di QUALUNQUE utente, senza
controllo di appartenenza all'associazione). Rifatte io stesso 2 delle 4 prove sul
database vivo, stesso esito dell'agente.

**19-20/09/2026 notte — 42b, prima parte, chiusa (fatta direttamente da me, non da
un agente: era abbastanza meccanica da scriverla e verificarla di persona).** 81
delle 143 policy avevano `qual = e_superadmin()` senza nessun controllo sulla riga:
un amministratore di UNA associazione vedeva/scriveva TUTTE le righe di TUTTE le
associazioni. Verificato con una query che fossero davvero tutte identiche (zero
eccezioni), riscritte in blocco con un DO SQL invece che a mano una per una — meno
rischio di trascrizione su 81 policy. Collaudato sulla policy vera (non sulla
funzione isolata): due associazioni finte, un amministratore dell'una non vede una
riga dell'altra, verificato con una query reale come quell'utente.

**Cosa resta, elenco preciso** (in `STATO.md` del repo il dettaglio completo):
- **13 policy pubbliche** (sito, letto da `anon`) senza nessun filtro per
  associazione — bloccate dal lavoro 48 (un anonimo non sa ancora "su quale sito
  associativo sono"), non un rischio nuovo di stanotte.
- **~48 policy di autoaccesso** (`persona_id = persona_corrente()` e simili) —
  riviste e giudicate già corrette (una persona appartiene già a una sola
  associazione), ma non collaudate una per una come le 81.
- Le altre ~36 funzioni `security definer`, le 18 chiamate service role.

**19-20/09/2026, oltre mezzanotte — lavoro 43 (collaudo a campione) fatto.** Non il
generatore sistematico per le 74 tabelle (resta da fare), ma un collaudo reale: due
associazioni finte con persone/corsi/incassi/ricevute/spese/documenti/verbali/
contratti, 16 tabelle, interrogate come amministratore e come socio **con la
policy vera**, non la funzione isolata. 9 tabelle isolate correttamente anche in
scrittura (un UPDATE cross-associazione tocca 0 righe); un socio vede solo le
proprie 1/1/1 righe, non le 2 che esisterebbero contando l'altra associazione.
`sala`/`tipologia_ingresso`/`corso` **perdono davvero** — conferma dal vivo delle
13 policy pubbliche già note dal 42b (bloccate dal lavoro 48, non un rischio
nuovo).

**Trovati per strada e corretti, non di sicurezza ma di integrità dei dati**: 10
vincoli `unique` rimasti globali dopo il lavoro 40b invece che per associazione —
il più serio, `persona.codice_fiscale` globale, avrebbe reso impossibile per la
stessa persona reale essere socia di due associazioni diverse (proprio il caso che
il lavoro 41 presuppone possibile). Non toccato `ente_requisito.codice`
(referenziato per codice da `bando_requisito` — probabile catalogo condiviso,
domanda di disegno aperta e segnalata, non decisa di testa mia).

**20/09/2026, secondo giro della stessa notte — le ~48 policy di autoaccesso
collaudate dal vivo**, non più solo per ragionamento. Coperti tutti gli schemi
diversi trovati fra le 143 policy: `persona_id` diretto (promemoria),
`collaboratore_id = collaboratore_corrente_id()` (compenso_regola, mese_compenso —
copre per estensione anche liquidazione/documento_collaboratore/documento_rimborso_
spese/scadenza_legge_collaboratore, stessa espressione), sottoquery istruttore su
`responsabile_persona_id` (lezione, presenza, iscrizione_corso — copre anche
`persona_istruttore_vede_propri_allievi`), `persone_gestite()` fra persone diverse
(tutela: un socio-tutore vede il proprio minore, non quello dell'altra
associazione). Zero fughe su tutti. Nessuna migrazione, solo verifica.

**20/09/2026, terzo giro della stessa notte — 42b chiuso quasi per intero.** Riviste
tutte le ~48 funzioni `security definer` rimaste, **9 bug reali trovati e
corretti** (non teorici — molte avrebbero fallito subito con un errore SQL al
primo utilizzo con due associazioni: numerazione ricevute, config letta per
chiave ambigua, contratti rateali/liquidazioni scritti senza `ente_id`). Il più
serio: `leggi_documento_giudiziario()` (unico cancello per dati giudiziari, art.
10 GDPR) lasciava un amministratore leggere documenti di un'altra associazione —
corretto e collaudato. Resta solo: le 18 chiamate service role in `src/` (tocca
l'app, deliberatamente fuori da stanotte).

**20/09/2026, quarto giro — visto funzionare dal vivo, non solo in teoria.**
Adattati i 4 file da cui dipende ogni pagina riservata (`utente-corrente.ts`,
`proxy.ts`, `login/page.tsx`, i tipi in `database.ts` aggiunti a mano). Creata
per davvero un'associazione finta "ASD Demo Palestra" (presidente/istruttore/
socio, login veri — password `Crewgest2026!`, un corso, un'iscrizione). Server
locale puntato su crewgest **senza toccare `.env.local`** (variabili passate
solo al comando `npm run dev`, resta puntato alla produzione). **Verificato nel
browser**: login → cruscotto gestionale coi dati veri → elenco soci → scheda
socio → sito pubblico con il corso visibile. Tutto funziona, zero errori.

**Trovato un buco vero preparando la prova, corretto subito**: `ente` e
`accesso_ente` (tabelle nuove del 41) erano rimaste con **RLS disattivata** —
`anon` aveva accesso pieno in lettura/scrittura, mai notato perché nessuna
delle 143 policy del 42b le riguardava. Migrazione `0181`, collaudato che un
anonimo veda zero righe.

Resta per il resto dell'app: ~9 file che leggono ancora `utente.ruolo`/
`persona_id` direttamente (accessi, verbali, notifiche, Telegram, compensi
altri enti), le 18 chiamate service role, le 21 letture di `configurazione`
da controllare una per una.

**20/09/2026, quinto giro — il gestionale neutro esisteva già.** Lele ha
notato che la demo era identica a The Crew vera. Il tema neutro (lavoro 31,
18/09) c'era già — logo a testo, palette grigia, banner "Ambiente demo" —
solo mai riacceso dopo la cancellazione della vecchia demo. Bastato
`configurazione.modalita_demo = true` sull'associazione finta: nessun
codice, scattato da solo. Corretti in più 3 punti rimasti sul ripiego
statico "THE CREW" (login, pagina d'errore, titolo scheda browser) che il
tema demo da solo non copriva. Non toccato `manifest.ts` (icona PWA):
richiede un'icona neutra vera, è lavoro 49.

**DA DOVE SI RIPARTE**, in ordine:
1. **Il resto di `src/`** — i ~9 file rimasti, uno alla volta, stesso schema
   della correzione di stanotte (leggere da `accesso_ente`, non da `utente`).
2. **43, generatore sistematico** — le stesse verifiche fatte a campione ma per
   tutte le 74 tabelle, e le 18 chiamate service role.
3. **Lavoro 48** (dominio per associazione) sblocca le 13 policy pubbliche
   rimaste, e la domanda aperta su `ente_requisito`.
4. **Lavoro 49** (aspetto per associazione) — icona PWA neutra, upload logo,
   scelta tema: quello che resta per rendere il pacchetto vendibile davvero,
   oltre a quanto già c'era.

**Priorità (18/09/2026):** massima, **in parallelo con The Crew** — diventeranno lo stesso
sistema, quindi non sono due progetti in competizione ma due metà dello stesso.

**Il concorrente è Golee**: costa caro per avere tutto, ed è brutto e complicato. Crew è
l'anti-Golee, e questo non è uno slogan ma **il criterio con cui si decide** quando una scelta
è in bilico: a parità di tutto vince l'opzione con meno voci, meno passaggi, meno da capire.
Chi aggiunge un'opzione deve spiegare perché non si poteva evitare.

---

## PRIMA DI TOCCARE QUALUNQUE COSA — dove sta la verità

Questo file è l'indice, non il contenuto. **Non ricostruire niente a memoria**: ogni cosa ha
un posto solo dove è vera, e sono questi.

| Cosa | Dove |
|---|---|
| **La coda dei lavori**, con cosa è fatto e cosa no | `docs/lavori/QUEUE-prodotto.md` nel repo |
| **Il piano con i numeri veri** | `docs/MULTICLIENTE.md` |
| **Il percorso completo, decisioni e perché** | `~/cervello/progetti/the-crew-processo-prodotto.md` |
| **Il diario di ogni sessione** | `STATO.md` nel repo (in cima le più recenti) |
| **Le 18 chiamate privilegiate, una per una** | `docs/CENSIMENTO_SERVICE_ROLE.md` |
| **Com'è nato lo schema di crewgest** | `docs/SCHEMA_CREWGEST.md` |
| **Come si popola un ambiente dimostrativo** | `docs/lavori/QUEUE-demo.md` |
| **Cosa si racconta ai betatester** | https://claude.ai/artifact/TwZBMREgi3a68ZT7GkPsSD |
| **Chi entra da dove, i tre casi e i tre ruoli** | https://claude.ai/artifact/QRZRfYVR93VZxe9CBbEDDX |
| **Il report tecnico per il confronto esterno** | https://claude.ai/artifact/LJEbfNviLd1WAry8zkrBor |

## I codici e gli indirizzi

```
crewgest (nuovo, vuoto)      aznlqhlivcvktxgvqlfl    Francoforte, Postgres 17.6
The Crew (produzione, viva)  ppxgnvwgryutrleefgjw    Francoforte, Postgres 17.6
```

Repo: `/home/genolele22/progetti/the-crew`, ramo `master`, remote SSH `genolele22/the-crew-gym`.
**Per ora il repo è uno solo per tutti e due** — vedi il punto fermo sul codice unico.

Vercel: progetto `the-crew` → thecrewgym.com. Il progetto `the-crew-demo` **è stato cancellato
il 18/09** insieme al suo database; al suo posto ci sarà un'associazione fittizia dentro crewgest.

Dominio del prodotto: **`crewgest.it`, ancora da comprare** (era libero il 18/09). Solo dominio,
DNS e una casella di posta: niente hosting, niente SSL, niente pacchetti — quelle cose ci sono già.

---

## I PUNTI FERMI — decisi, non si ridiscutono

Ognuno è costato una discussione. Si riaprono solo con un fatto nuovo, mai con un'opinione.

**1. Un codice solo, due installazioni. Mai due programmi.**
Crewgest e thecrewgym.com sono lo stesso identico programma con database diversi. Il giorno che
diventano due codici che si assomigliano, ogni funzione si costruisce due volte e dopo sei mesi
sono due prodotti a metà.

**2. Le associazioni entrano da un indirizzo solo** (`crewgest.it`). **Ma i soci e gli istruttori
restano sul dominio della loro associazione** e non vedono mai la parola crewgest. Il presidente
impara volentieri un indirizzo nuovo, il socio di settant'anni no.

**3. Si registrano da sole, ma Lele approva.** L'associazione nasce spenta e viene accesa a mano.

**4. Un accesso solo per persona**, anche se sta in due associazioni: sceglie dopo il login.
È la decisione più costosa da cambiare dopo — cambiarla significa rifare gli accessi di tutti.

**5. I pagamenti online sono nella prima versione.** Ma Stripe Connect pretende che la
piattaforma sia una **persona giuridica**: Lele non può esserlo da dipendente pubblico, quindi
dev'essere la società del commercialista. **È un prerequisito legale di una funzione, non una
pratica da sbrigare.** Finché non è risolto, quel lavoro è fermo — solo quello.

**6. La guida guida, non blocca.** Percorso guidato pagina per pagina, a scomparsa, per prendere
le ASD gestite da chi non è pratico. Ma nessuno sbarramento all'ingresso: se un'associazione è in
regola o no è affare suo. Unica eccezione da segnalare con un avviso (mai un blocco): il numero
da cui ripartono le ricevute, perché senza quello il sistema stampa documenti sbagliati.

**7. Chi smette di pagare si contatta, caso per caso.** Niente blocco automatico alla scadenza:
un interruttore che decide Lele. *«Siamo un'azienda solidale.»* E i dati non si cancellano mai.

**8. Chi carica cosa.** Lele carica **l'elenco soci** (una volta sola, da un file qualunque) e
imposta **il contatore ricevute** (l'unico dato che non può essere sbagliato). L'associazione
carica abbonamenti, corsi, quote, contabilità e foglio della banca, dopo una dimostrazione.
Non per risparmiare fatica: **se caricano loro, imparano il gestionale.** Se glielo riempiamo
noi resta una scatola che non sanno aprire, e chiamano alla prima quota nuova — che è
esattamente il carico di assistenza che il modello non può permettersi.

**9. La migrazione dei soci funziona già** e non va reinventata: il presidente dice ai soci dove
andare e cosa compilare, il sistema fa il match sul **codice fiscale**, e prima di scrivere
controlla che coincida con quello della persona a cui lo si collega. Nessun link di massa da
mandare in giro: il sessantacinquenne non deve cliccare niente che non sappia cliccare.

**10. Il gestionale funziona anche se nessun socio ha un account.** Gli accessi tolgono lavoro
al presidente, non sono un requisito. In The Crew sono 65 su 239, e gli altri 174 sono gestiti
benissimo. È la frase che toglie l'ansia più grossa a un presidente.

**11. La demo è un'associazione fittizia dentro crewgest**, non un ambiente separato. Così la
demo è **la stessa cosa che compra il cliente**. Nel frattempo si mostra il gestionale vero di
The Crew: *«è la pubblicità migliore»*.

**12. Il pannello aziendale sta nello stesso programma**, in un'area riservata
(`admin.crewgest.it`), pensata per essere data a chi gestirà l'azienda.

**13. The Crew entra dentro crewgest più avanti.** Conseguenza da tenere presente: finché non
entra, **il gestionale di Lele non riceve funzioni nuove** — correzioni sì, novità no, perché
nascono sulla forma multi-associazione. Più corta è quella finestra, meno costa.

---

## LE REGOLE DI LAVORO — perché non si perda un minuto

Ognuna nasce da una cosa che è costata davvero, la notte del 17-18/09.

**Ogni agente fa `git merge master` prima di cominciare.** Il worktree può nascere da un master
più vecchio: è successo a tre agenti su cinque, e due hanno segnalato come "discrepanze" cose
che su master erano a posto.

**Si committa a gruppi, mai tenendo il lavoro in testa.** Un agente fermato da un limite di
spesa ha perso mezza sessione di censimento. Ripreso con l'ordine di scrivere man mano, ha fatto
dieci commit e non ha perso niente. *Un rapporto finale perfetto che non arriva mai vale zero.*

**I numeri di migrazione si assegnano prima di lanciare.** Due agenti che scelgono lo stesso
numero fanno un disastro silenzioso. **Ultima usata: `0159`.**

**`package.json` a un agente solo per volta**, e va detto esplicitamente.

**Due agenti in parallelo solo se toccano file diversi.** Il 35 e il 36 hanno convissuto bene; il
33 e il 35 si sono scontrati sulle email e i conflitti sono stati sciolti a mano.

**Il coordinatore verifica sul database vivo, non dal rapporto dell'agente.** È così che sono
saltati fuori quattro backup notturni persi che nessuno stava cercando, e il buco di sicurezza
sulle funzioni interne.

**Niente service role key in locale** (è vuota ed è bloccata dal sandbox): si passa dal tool MCP
Supabase. **Collaudo con dati finti, poi rimossi**, e si verifica che non restino residui.

**Niente push e niente deploy senza Lele.** Attenzione: **sul progetto il push su `master` fa
partire il deploy da solo.** Non sono due gesti, è uno.

---

## IL REGISTRO — cosa è stato fatto davvero

### 17-18 settembre 2026

| | Lavoro | Commit |
|---|---|---|
| 33 | Sentinella quotidiana sulla coda email, trasporto posta pronto per un servizio vero | `ec6b612` |
| 34 | Impalcatura delle prove e guardia anti-produzione | `089f157` |
| 35 | Via "The Crew" dal codice: ente, registro, privacy, marchio diventano dati | `6871136` |
| 36 | Il backup non perde più la notte per una tabella (tre esiti, ritentativi) | `c2b507c` |
| 37 | Censimento delle chiamate privilegiate + il recinto + il controllo in CI | `88a6485` |
| 38 | Le chiamate per conto di un'associazione passano dal modulo unico | mergiato |
| 39 | Pulizie: via `imapflow`, guardia sulle nove colonne della vista pubblica | `f5cfa95` |
| 40a | Lo schema completo portato su crewgest, verificato identico alla produzione | `d7546c7` |

**Due correzioni nate dal confronto fra i due database**, e sono il vero guadagno di aver
costruito crewgest da zero:

- **`0158`** — le funzioni interne erano chiamabili da un anonimo su un progetto nuovo.
  `assegna_numero_ricevuta` gira con privilegi elevati, non ha controlli dentro, ed era
  raggiungibile con la chiave pubblica che sta nel JavaScript di ogni pagina: bruciare numeri di
  ricevuta significa fare buchi in una numerazione che per legge non deve averne. La produzione
  era chiusa solo perché qualcuno l'aveva fatto **a mano**, e non era mai diventato un file.
- **`0159`** — tolta la modalità di sola lettura della vecchia demo: 48 trigger che scattavano a
  ogni scrittura per leggere una colonna che nessuno avrebbe valorizzato. Era della forma
  sbagliata: a crewgest serve sospendere **una singola associazione**, non l'intero database.

**Verificato di persona sul database vivo**, non dai rapporti: schema identico (103 trigger per
parte), zero residui di collaudo, il recinto che rompe davvero la build se qualcuno aggiunge una
chiamata fuori posto.

**Non pubblicato:** 59 commit locali. Il sito gira ancora sulla versione del 17/09 mattina.

---

## COSA ASPETTA LELE

1. **Comprare `crewgest.it`** — senza, non c'è l'indirizzo unico.
2. **Chiedere al commercialista chi è la persona giuridica della piattaforma** per i pagamenti.
   È l'unico lavoro fermo del piano.
3. **Confermare la sede legale** che compare sull'informativa privacy: *via Guglielmo Marconi 28,
   Asigliano Vercellese*. È un documento legale con l'indirizzo dell'associazione sopra.
4. **Decidere se pubblicare** i 59 commit fermi.
5. **Il progetto Supabase di prova non esiste ancora**: due prove restano sospese finché non c'è.

## I RISCHI NOTI

**Il travaso di The Crew dentro crewgest** (lavoro 53) ha una condizione dura: **gli account
devono traslocare senza che nessuno debba rifare la password.** Sono 65 persone, molte non
pratiche. Va provato su un'associazione finta prima, non scoperto il giorno stesso. E dipende dal
lavoro 48: senza il riconoscimento del dominio, quel giorno thecrewgym.com resta senza niente da
mostrare.

**L'appello non è mai stato usato**: 1 lezione e 0 presenze da sempre. Se un cliente lo usa, lo
collauda lui su persone vere.

**La promessa del canale corre più veloce del prodotto.** Il commercialista sta già dicendo che
il gestionale automatizza la burocrazia del presidente, mentre i verbali d'assemblea hanno zero
righe. Prima che un cliente pagante senta quella frase, al canale va data una versione che regge
oggi.

---

## COME SI TIENE AGGIORNATO QUESTO FILE

A fine di ogni sessione che tocca crewgest: si aggiorna **lo Stato** in cima, si aggiunge la riga
al **Registro** con il commit, e si sposta quello che è stato risolto da *Cosa aspetta Lele*.

Se una decisione cambia, si **riscrive il punto fermo** e si scrive la data — non si aggiunge una
nota sotto che lo contraddice. Due versioni della stessa decisione nello stesso file è il modo
più veloce di perdere una giornata.
