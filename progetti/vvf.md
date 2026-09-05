# Progetto — vvf (bot + gestionale)

> **Rivedere entro:** 2026-12-05

**Cos'è:** bot Telegram + gestionale web per il Comando Provinciale VVF di Genova — richieste ferie/permesso/malattia/infortunio/missione, foglio di servizio, ODT, agenda, scambio turni.
**Stato:** LIVE, in produzione, 4 turni (A/B/C/D) sullo stesso gestionale.
**Priorità:** 2ª nella classifica del 22/08/2026 (dopo ASD/Crew) — sostanzialmente finito, si lima in seguito.

**Stack:** bot Python (python-telegram-bot) su Fly.io (`vvf-ferie-bot`), gestionale PHP su Fly.io (`vvf-gestionale`), DB condiviso TiDB Cloud.
**Repo:** `/home/genolele22/vvf-ferie-bot` e `/home/genolele22/vvf-gestionale` (quest'ultimo lavora sul branch `logbook`, che di fatto è il trunk — `master` è indietro di 185 commit, da sistemare prima o poi. Dal 22/08/2026 entrambi hanno un remote GitHub privato via SSH — `genolele22/vvf-ferie-bot` e `genolele22/vvf-gestionale` — ma i commit locali **non** vengono pushati in automatico: va fatto a mano a fine sessione).

**Betatester principale:** Andrea Molinari ("Moli") — segnala bug e richieste nel Logbook interno al gestionale (`/logbook`), tenuto vivo finché il bot resta in beta.

## Stato

Stato: in corso — 05/09/2026: chiusa #257 (composizione squadra: "Autista 2"
  diventa "Autista 2/3/4", una patente più grande copre il ruolo più piccolo,
  la 1 no; l'Autista 3/4 resta a 3-4 e i due ruoli non li copre la stessa
  persona. Capo partenza Cr **o** Cs era già corretto in codice, solo etichette).
  Fatti i punti 1 e 2 di #259 (integrazione a #255): l'avviso "ha già ricevuto
  conferma per questo turno di ferie" non dipende più dalla mail già inviata
  (via il controllo su `bot_outbox`) e scatta anche col vicino `pending`; lo
  stesso popup ora esce anche togliendo una ferie da richiesta **dal Foglio**
  (`rimuovi_assenza`), dove il furiere non può sapere la storia del vigile.
  `feriaVicinoGiaConfermato()` è ora in `includes/ferie_vicino_confermato.php`,
  condivisa tra Agenda e Foglio.
Deciso: 05/09/2026 — il punto 3 di #259 ("negare dal Foglio deve avere lo stesso
  effetto del visto spezza ferie in Agenda") **non** è stato implementato: due
  letture possibili (solo l'effetto automatico del blocco spezzato, oppure
  `spezza_dopo=1` sul turno precedente). Lele chiede chiarimento a Moli.
Prossimo passo: risposta di Moli sul punto 3 di #259; #259 resta aperta nel
  logbook. Aperte anche #253 (Stili & Colori), #256 (celle vuote ODT), #258
  (*** STR *** nelle Variazioni).

---

## Stato al 01/09/2026

Stato: in corso — chiusa #254 (Moli, urgente): popup di avviso sul Foglio
  quando un vigile ha 2+ turni di ferie NON estive consecutive, ai tasti
  Invia/Scarica .odt/anteprima.
Deciso: 01/09/2026 — corretto lo stesso giorno: l'impostazione era nata come
  una chiave sola per tutti e 4 i turni invece che una per turno (stesso
  schema già in uso per mail_furiera_* e Stili&Colori) — spegnerla su un
  turno la spegneva ovunque. Ora 4 caselle indipendenti in Amministrazione.
Prossimo passo: nessuno aperto da questo giro.

---

## Stato al 27/08/2026

Stato: in corso — giro di logbook a gruppi paralleli (26-27/08/2026), 8 note
  chiuse in una notte con tre agenti Opus lanciati a 2h di distanza.
Deciso: quando le note del logbook sono tante, si dividono **per area di file**
  (Agenda / ODT / Amministrazione), un agente per area, sfalsati nel tempo per
  non incrociare i limiti di token. Nessun conflitto sui file, ogni gruppo
  chiude con commit + deploy + verifica del timestamp del deployment.
Prossimo passo: chiuse #229 (icona Patenti: la 🪪 non veniva disegnata dal
  browser, sostituita con 🚗), #232+#233 (Agenda: missione e permesso
  giornaliero come riga **per turno** e non per giorno, navigazione mese
  duplicata in fondo — deploy v235), #216+#231+#235 (ODT: asterisco sul
  permesso orario, grassetto residuo tolto **dal modello .odt** come da
  regola, apostrofo tipografico spostato nel punto di passaggio obbligato
  `setText()` — deploy v236), #213+#214 (calendari di Amministrazione:
  estetica del calendario ferie sulle assenze **senza** perdere la
  selezionabilità di tutti i giorni solari, riga tipo che non fa più saltare
  la pagina — deploy v237). Tutto pushato su `logbook`.
  Sul logbook restano 4 note aperte, nessuna di questo giro.
  Le tre code corte lasciate a Lele sono state **chiuse subito dopo (deploy
  v238)**: asterisco ODT esteso alle visite mediche (non dentro la casella 5A,
  che si chiama già "Visita Medica") e a capo/vice servizio in intestazione,
  badge "🔒 registrata" rimesso su missione e permesso in Agenda.
Deciso: **capo e vice servizio sono vigili come gli altri e vanno trattati
  come tali sull'ODT** — il vice all'occorrenza fa il capo partenza, quindi
  può trovarsi in permesso orario o in visita come chiunque. Vale come
  criterio generale, non solo per l'asterisco.

---

## Stato al 25/08/2026

Stato: in corso — sessione lunga di limatura logbook (25/08/2026), non ferma
  come lasciava intendere il "sostanzialmente finito" del 22/08.
Deciso: la composizione minima di squadra (capo/autista/abilitazioni) è
  per-turno, non globale — nuova tabella `posizione_composizione` + pagina
  admin dedicata `composizione_squadra.php` (stesso schema di
  `regole_squadra.php`), non più campi sull'anagrafica mezzi condivisa.
Prossimo passo: chiuse 26 voci di logbook (bug di correttezza, agenda,
  foglio, composizione squadra per-turno, password fureria gestibile da
  admin con Fernet compatibile col bot). Tutto deployato e verificato nei
  log. Restano aperte solo per scelta esplicita di Lele: #220 (restyling
  colori ODT), #183/#207/#216 (ODT: ordine nomi, oltre 5 malati), tasto
  "Spec." sul foglio (comportamento mai definito).

---

## Stato al 22/08/2026

Stato: in corso — di fatto in limatura, non più in costruzione
Deciso: 22/08/2026 — vvf scende al 2° posto della classifica. Motivo dichiarato da
  Lele: "vvf è sostanzialmente finito e limabile in seguito, Crew serve ora e ha
  ancora margine di crescita. Non è inerzia, è una scelta."
Prossimo passo: backup remoto **risolto il 22/08** (repo privato
  `genolele22/vvf-gestionale`, tre branch pushati). Stesso giorno, fix ODT
  logbook #208 (VP Morello spariva dal foglio 20/08: match testuale troppo
  largo scambiava cognomi con "ore" nel nome per il placeholder della data)
  — deployato, verificato in prod, nota lasciata aperta: la chiude Moli
  quando l'ha controllata lui. Resta solo coda ordinaria, da riprendere
  quando Crew lascia spazio: logbook (2 riparametrizzazioni grosse + una
  decina di voci minori), ODT ordine nomi, ODT oltre 5 malati, anagrafica
  turno C, rimozione delle 15 funzioni morte del bot.

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

- ~~Logbook: 2 voci grosse di riparametrizzazione~~ — fatte il 25/08/2026
  (composizione squadra per-turno #172/#218/#163, credenziali fureria da
  admin #92/#136).
- **ODT — ordine nomi disallineato**: serve un foglio concreto dove è successo per riprodurre il bug prima di intervenire. Deliberatamente saltato il 25/08 ("vai dritto alle grosse").
- **ODT — oltre 5 malati spariscono dalla lista**: la soluzione proposta (accodare a capo come già fatto per i mezzi) non va bene per Lele, da ripensare insieme. Deliberatamente saltato il 25/08.
- **ODT — restyling colori/stili (#220)**: rimandato il 25/08, "un'altra volta".
- **Tasto "Spec." sul foglio (#226)**: icona e posizione fatte, comportamento al click mai definito — lasciato da parte apposta il 25/08.
- **15 funzioni morte nel bot**: individuate, tenute finché non dai l'ok a toglierle.
- **Anagrafica turno C**: unico turno senza dati completi.
- ~~Push su GitHub dei commit~~ — fatto il 22/08/2026, entrambi i repo hanno un remote privato.

Dettagli tecnici e cronologia delle sessioni: memoria auto-gestita del secondo cervello (progetti `vvf_*` nell'indice memoria) — non qui, questa scheda resta la vista d'insieme.
