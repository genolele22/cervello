# Progetto — vvf (bot + gestionale)

**Cos'è:** bot Telegram + gestionale web per il Comando Provinciale VVF di Genova — richieste ferie/permesso/malattia/infortunio/missione, foglio di servizio, ODT, agenda, scambio turni.
**Stato:** LIVE, in produzione, 4 turni (A/B/C/D) sullo stesso gestionale.
**Priorità:** 2ª nella classifica del 22/08/2026 (dopo ASD/Crew) — sostanzialmente finito, si lima in seguito.

**Stack:** bot Python (python-telegram-bot) su Fly.io (`vvf-ferie-bot`), gestionale PHP su Fly.io (`vvf-gestionale`), DB condiviso TiDB Cloud.
**Repo:** `/home/genolele22/vvf-ferie-bot` e `/home/genolele22/vvf-gestionale` (quest'ultimo lavora sul branch `logbook`, che di fatto è il trunk — `master` è indietro di 185 commit, da sistemare prima o poi. Dal 22/08/2026 entrambi hanno un remote GitHub privato via SSH — `genolele22/vvf-ferie-bot` e `genolele22/vvf-gestionale` — ma i commit locali **non** vengono pushati in automatico: va fatto a mano a fine sessione).

**Betatester principale:** Andrea Molinari ("Moli") — segnala bug e richieste nel Logbook interno al gestionale (`/logbook`), tenuto vivo finché il bot resta in beta.

## Stato

Stato: in corso — di fatto in limatura, non più in costruzione
Deciso: 22/08/2026 — vvf scende al 2° posto della classifica. Motivo dichiarato da
  Lele: "vvf è sostanzialmente finito e limabile in seguito, Crew serve ora e ha
  ancora margine di crescita. Non è inerzia, è una scelta."
Prossimo passo: backup remoto **risolto il 22/08** (repo privato
  `genolele22/vvf-gestionale`, tre branch pushati). Resta solo coda ordinaria,
  da riprendere quando Crew lascia spazio: logbook (2 riparametrizzazioni grosse
  + una decina di voci minori), ODT ordine nomi, ODT oltre 5 malati,
  anagrafica turno C, rimozione delle 15 funzioni morte del bot.

---

## Stato al 17/08/2026

Sessione lunga sul gestionale, tutto deployato su Fly.io (commit locali, non pushati):

- **Caricamento assenze da admin completato** (chiudeva logbook #142, aperto dal 14/07): `admin/ferie_simulate.php` ora copre anche il Permesso (giornaliero e orario, selezione oraria a ore piene), nuovo `admin/assenze_simulate.php` copre Missione/Malattia/Infortunio (selezione a intervallo stile booking, voci auto-approvate). Entrambi con avviso (mai blocco) se c'è uno scambio salto attivo sullo stesso turno.
- **Regola "il salto vince"**: scoperto che questi tool potevano creare ferie/permesso su un giorno in cui il vigile era già sul proprio salto turno (riposo compensativo personale, diverso da vigile a vigile anche nello stesso turno) — es. Barbieri 2 il 25/08. Aggiunto un blocco vero (non solo avviso) nel tool, e ripuliti **19 casi già presenti in produzione** da giugno a settembre.
- **`reset_foglio` risincronizza dall'Agenda tutti i tipi di assenza**, non solo le ferie come prima (richiesta esplicita di Lele dopo il caso Barbieri).
- **Logbook: tasto rapido "Qui non va"** su ogni pagina del gestionale (stesso concetto di The Crew), nota + link alla pagina di origine, pagina completa invariata nelle funzioni esistenti.
- **ODT**: controllati tutti i punti aperti nel logbook su file .odt (6 voci), sistemati colore personale esterno/specialisti, apostrofo tipografico, evidenziatore ferie estive/d'ufficio; sostituito `templates/modello.odt` con la versione B0 caricata da Lele (verificato che non cambia nulla di funzionale). Restano in sospeso: ordine nomi a volte disallineato tra gestionale e odt (serve un caso concreto da riprodurre), oltre 5 malati che spariscono dall'odt (soluzione proposta scartata da Lele, da ripensare).
- **Colonne turni/periodo/testo per Missione/Permesso/Malattia/Infortunio nell'ODT** (chiudeva logbook #206): geometria già nel modello B0, mancava il riempimento — stessa logica a blocchi già usata per le ferie, riusata per tutti e quattro i tipi.
- **Amministrazione "Stili & Colori"** (era "Stile Patenti", chiudeva #182): patenti rosso/blu ora a colore RGB libero invece di 3 tinte preimpostate; nuovo colore di sfondo configurabile per straordinario/ferie estive/ferie d'ufficio sull'ODT (prima fisso nel codice), con opzione "nessuna evidenziazione". Solo ODT, il foglio web resta invariato.
- **Bug del modello B0 dopo il collaudo di Lele**: (1) un nome normale (Murru) compariva grassetto+giallo come fosse in straordinario — non un dato sbagliato, ma formattazione residua rimasta nel modello .odt da esempi mai ripuliti in LibreOffice; risolto ripulendo direttamente il file (91 stili su 270 celle), non con un patch nel codice. (2) mancavano le due righe data inizio/fine turno in intestazione: il codice le cercava per un testo d'esempio che il B0 non ha più, ora le trova per posizione. (3) sigla sede (es. "MN") incollata al nome invece che nella cella a fianco su 5 mezzi con colonna nome stretta (CENTR-OP, 1SMZ, ML-1A, GA-1NAU, ML-1NAU) — limite di larghezza nel codice troppo severo, rimosso.

## Aperto per Lele

- **Logbook**: restano 2 voci grosse di riparametrizzazione (pagina admin per i parametri oggi nel codice del bot, credenziali fureria gestibili da admin invece che da anagrafica vigile) più una decina di voci foglio/anagrafica non ancora affrontate — priorità da dare tu.
- **ODT — ordine nomi disallineato**: serve un foglio concreto dove è successo per riprodurre il bug prima di intervenire.
- **ODT — oltre 5 malati spariscono dalla lista**: la soluzione proposta (accodare a capo come già fatto per i mezzi) non va bene per Lele, da ripensare insieme.
- **15 funzioni morte nel bot**: individuate, tenute finché non dai l'ok a toglierle.
- **Anagrafica turno C**: unico turno senza dati completi.
- ~~Push su GitHub dei commit~~ — fatto il 22/08/2026, entrambi i repo hanno un remote privato.

Dettagli tecnici e cronologia delle sessioni: memoria auto-gestita del secondo cervello (progetti `vvf_*` nell'indice memoria) — non qui, questa scheda resta la vista d'insieme.
