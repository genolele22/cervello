# Progetto — vvf (bot + gestionale)

**Cos'è:** bot Telegram + gestionale web per il Comando Provinciale VVF di Genova — richieste ferie/permesso/malattia/infortunio/missione, foglio di servizio, ODT, agenda, scambio turni.
**Stato:** LIVE, in produzione, 4 turni (A/B/C/D) sullo stesso gestionale.
**Priorità:** massima tra i progetti di Lele — da finire.

**Stack:** bot Python (python-telegram-bot) su Fly.io (`vvf-ferie-bot`), gestionale PHP su Fly.io (`vvf-gestionale`), DB condiviso TiDB Cloud.
**Repo:** `/home/genolele22/vvf-ferie-bot` e `/home/genolele22/vvf-gestionale` (quest'ultimo lavora sul branch `logbook`, che di fatto è il trunk — `master` è indietro di 185 commit, da sistemare prima o poi. Nessun remote configurato su `vvf-gestionale`; `vvf-ferie-bot` ha un remote GitHub ma i commit locali non vengono pushati in automatico).

**Betatester principale:** Andrea Molinari ("Moli") — segnala bug e richieste nel Logbook interno al gestionale (`/logbook`), tenuto vivo finché il bot resta in beta.

---

## Stato al 17/08/2026

Sessione lunga sul gestionale, tutto deployato su Fly.io (commit locali, non pushati):

- **Caricamento assenze da admin completato** (chiudeva logbook #142, aperto dal 14/07): `admin/ferie_simulate.php` ora copre anche il Permesso (giornaliero e orario, selezione oraria a ore piene), nuovo `admin/assenze_simulate.php` copre Missione/Malattia/Infortunio (selezione a intervallo stile booking, voci auto-approvate). Entrambi con avviso (mai blocco) se c'è uno scambio salto attivo sullo stesso turno.
- **Regola "il salto vince"**: scoperto che questi tool potevano creare ferie/permesso su un giorno in cui il vigile era già sul proprio salto turno (riposo compensativo personale, diverso da vigile a vigile anche nello stesso turno) — es. Barbieri 2 il 25/08. Aggiunto un blocco vero (non solo avviso) nel tool, e ripuliti **19 casi già presenti in produzione** da giugno a settembre.
- **`reset_foglio` risincronizza dall'Agenda tutti i tipi di assenza**, non solo le ferie come prima (richiesta esplicita di Lele dopo il caso Barbieri).
- **Logbook: tasto rapido "Qui non va"** su ogni pagina del gestionale (stesso concetto di The Crew), nota + link alla pagina di origine, pagina completa invariata nelle funzioni esistenti.
- **ODT**: controllati tutti i punti aperti nel logbook su file .odt (6 voci), sistemati colore personale esterno/specialisti, apostrofo tipografico, evidenziatore ferie estive/d'ufficio; sostituito `templates/modello.odt` con la versione B0 caricata da Lele (verificato che non cambia nulla di funzionale). Restano in sospeso: ordine nomi a volte disallineato tra gestionale e odt (serve un caso concreto da riprodurre), oltre 5 malati che spariscono dall'odt (soluzione proposta scartata da Lele, da ripensare).

## Aperto per Lele

- **Logbook**: restano 2 voci grosse di riparametrizzazione (pagina admin per i parametri oggi nel codice del bot, credenziali fureria gestibili da admin invece che da anagrafica vigile) più una decina di voci foglio/anagrafica non ancora affrontate — priorità da dare tu.
- **ODT — ordine nomi disallineato**: serve un foglio concreto dove è successo per riprodurre il bug prima di intervenire.
- **ODT — oltre 5 malati spariscono dalla lista**: la soluzione proposta (accodare a capo come già fatto per i mezzi) non va bene per Lele, da ripensare insieme.
- **15 funzioni morte nel bot**: individuate, tenute finché non dai l'ok a toglierle.
- **Anagrafica turno C**: unico turno senza dati completi.
- **Diagnosi Volpara/Zollo/Pedemonte** (turno A, sempre fuori squadra): analisi pronta, 3 fix proposti, sospesa su tua richiesta.
- Push su GitHub dei commit (per ora restano locali).

Dettagli tecnici e cronologia delle sessioni: memoria auto-gestita del secondo cervello (progetti `vvf_*` nell'indice memoria) — non qui, questa scheda resta la vista d'insieme.
