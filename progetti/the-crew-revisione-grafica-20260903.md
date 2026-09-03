# The Crew — revisione grafica e di usabilità (03/09/2026)

Guardato con gli occhi, in produzione, da superadmin: gestionale (Da fare, Soci, scheda socio, Pagamenti), area socio, sito pubblico. Confronto con App Palestre (ShaggyOwl), il vecchio gestionale, esplorato la notte prima.

---

## Il problema di fondo: sono due prodotti diversi

Il **sito pubblico** ha un'identità vera: fondo scuro, titolo condensato pesante ("COMBATTI. BALLA. RESPIRA."), giallo che risalta, logo grande, barra a tutta larghezza. Sembra una palestra da combattimento.

Il **gestionale** è beige chiaro, carattere di sistema, contenuto stretto in una colonna centrale con due fasce vuote ai lati, e del marchio resta solo un logo piccolo — quando si carica. L'unica cosa in comune col sito è il giallo dei pulsanti.

Non è che il gestionale sia brutto: è che non sembra lo stesso prodotto. Chi passa dal sito al pannello ha la sensazione di cambiare software.

---

## Cosa confonde (usabilità)

1. **Il giallo vuole dire quattro cose diverse.** È il pulsante principale ("Registra incasso", "Iscrivi", "Carica"), ma è anche un'etichetta informativa non cliccabile ("Quota associativa · in regola fino al 31/12/2026", con bordo scuro identico a un pulsante), è la zona di caricamento file ("Scatta una foto o scegli un file", giallo pallido), ed è il tasto flottante del logbook. Quando tutto è giallo, il giallo non indica più l'azione da fare.

2. **La stessa azione ha pesi opposti in due punti.** "Registra incasso" è il pulsante giallo grande della dashboard, ma dentro la scheda socio, sulla riga dell'iscrizione, è un link testuale sottolineato — mentre "Aggiorna" (che cambia solo uno stato) lì è un pulsante bordato. L'azione che vale soldi pesa meno di quella che non ne vale.

3. **Azione e navigazione vestite uguali.** Nella pagina Pagamenti ci sono cinque riquadri identici in fila: il primo ("Registra un incasso") è un'azione, gli altri quattro ("Rate e solleciti", "Tutti i pagamenti", "Ricevute", "Contatore ricevute") sono voci di menu. Stessa forma, significato diverso.

4. **I menu non dicono dove sono le cose.**
   - "Soci" sta in *Ogni giorno*, "Libro soci" in *Associazione*: le due voci che si somigliano di più sono nei due menu più lontani.
   - "Consuntivo annuale" sta in *Impostazioni* — non è un'impostazione, è il bilancio. E "Statistiche" sta in *Ogni giorno*: le due pagine dei conti sono in menu diversi (ed è esattamente la coppia che ieri dava due totali diversi).
   - "Notifiche" sta in *Attività*.
   - *Ogni giorno* contiene Spese, Estratto conto e Statistiche, che di quotidiano non hanno niente.
   - La parola **"Abbonamenti" non esiste** nel menu dello staff: si chiama "Tipologie di ingresso", in *Impostazioni*. Nell'area socio la stessa cosa si chiama "I miei abbonamenti" — il nome buono ce l'ha il socio, non tu.

5. **Due modi di navigare nello stesso software.** Il gestionale ha quattro menu a tendina; l'area socio ha link piatti in fila. Stessa barra, stesso colore, comportamento diverso.

6. **Stati ambigui.** Nelle "Ricevute recenti" i filtri per tipologia: due sono grigi chiari e uno ha il bordo scuro. Non si capisce se i grigi siano disattivati o solo non selezionati.

---

## Cosa non va (cura e coerenza visiva)

1. **Il logo non c'è.** Su `/gestionale/soci`, `/gestionale/pagamenti` e `/socio` al suo posto resta un rettangolo crema vuoto (verificato aspettando 5 secondi, non è lentezza). Sulla home del gestionale e sul sito pubblico si vede. È il marchio che manca proprio nelle pagine che usi tutto il giorno.

2. **Spazio sprecato e informazioni mancanti insieme.** Il contenuto sta in ~1000 px dentro una finestra da 1568: due fasce vuote ai lati. Intanto l'elenco soci mostra solo N., Cognome e nome, Qualifica, Scadenza quota, Stato — **niente telefono, niente abbonamento attivo, niente certificato**. App Palestre, nello stesso spazio, mostrava cellulare, abbonamenti attivi, data iscrizione e scadenza del certificato medico: si capiva tutto senza aprire nessuno. Qui per sapere qualsiasi cosa di una persona bisogna entrare nella sua scheda.

3. **La colonna "Qualifica" è vuota per tutti** (206 trattini). Occupa spazio e non dice niente.

4. **Niente intestazioni fisse.** L'elenco soci è una pagina unica da 206 righe: dopo venti righe perdi intestazioni di colonna, ricerca, filtri e menu. In App Palestre la barra laterale restava sempre lì.

5. **Il muro rosso.** 151 soci su 206 sono segnalati in rosso o ambra. Quando l'allarme è la norma, smette di essere un allarme: l'occhio si abitua e non distingue più il caso urgente.

6. **Formati di data mescolati, a volte nella stessa riga.** "24/03/2026 · … Periodo dal 24-03-2026 al 23-06-2026": barre e trattini nella stessa frase.

7. **Le righe delle ricevute sono stringhe, non dati.** "24/03/2026 · Sala Pesi trimestrale (storico) — SALA PESI TRIMESTRALE corris - Periodo dal … · 115,00 €": tre separatori diversi (·, —, -), il nome ripetuto due volte di cui una in maiuscolo, e l'importo in fondo alla frase invece che in una colonna allineata a destra. Non si riesce a scorrere una colonna di importi con l'occhio.

8. **Tre trattamenti diversi per le sezioni nella stessa pagina** (scheda socio): riquadro bordato richiudibile ("Modifica anagrafica", "Scrivi a…"), titolo con triangolino senza riquadro ("Iscrizioni", "Certificato medico"), e ancora titolo con triangolino ma chiuso ("Carta salvata", "Storia nel libro soci"). Nulla distingue a colpo d'occhio una sezione aperta da una che si può aprire.

9. **Pulsanti di altezze e larghezze diverse nella stessa fila.** In cima a Soci: "Verifica decadenze" e "Import massivo" bordati e più bassi, "Nuova domanda di adesione" giallo e molto più grande. Non sono allineati.

10. **Il modulo prima del contenuto.** Nella scheda socio, sotto "Iscrizioni", compare prima il modulo per iscrivere e poi l'elenco delle iscrizioni esistenti. Si vede come aggiungere prima di vedere cosa c'è.

11. **Due livelli di testo di aiuto impilati** nella sezione certificato ("Lo vedete solo tu e il socio…" + "Dato sanitario riservato per legge (GDPR art. 9)"): due grigi diversi, molto peso per un campo solo.

12. **Etichette simpatiche ma poco chiare**: "File (facoltativo qui, obbligatorio prima o poi)". Prima o poi quando?

13. **Pagine quasi vuote.** "Pagamenti" è per il 90% spazio bianco: cinque riquadri e la riga "Nessuna rata scaduta al momento". È una pagina di menu travestita da pagina di contenuto.

---

## Dove The Crew è già meglio di App Palestre

Da dire, perché non è tutto da rifare:

- **La dashboard "Da fare"** è nettamente superiore: attività ordinate per urgenza, con frasi in italiano vero che spiegano *perché* conta ("il socio si allena senza copertura assicurativa CSEN"). App Palestre in home aveva riquadri statistici vuoti con l'invito a comprare un piano superiore.
- **I filtri con i conteggi** ("Certificato scaduto (2)", "Quota da rinnovare (151)") sono più chiari dei filtri a icone del vecchio sistema.
- **Nessuna pubblicità del fornitore dentro i tuoi dati.** App Palestre ti mette in home, in rosso, il promemoria di rinnovare l'abbonamento *a loro*.
- **Il linguaggio.** Ovunque frasi normali invece di gergo. È la cosa migliore del prodotto e va difesa.

## Dove App Palestre è meglio, e vale copiarlo

- **Barra laterale sempre visibile**: non perdi mai la navigazione, nemmeno in fondo a una lista lunga.
- **Elenco clienti che dice tutto**: contatti, abbonamento attivo, scadenze, tutto in riga.
- **Lista a sinistra + dettaglio a destra**: si passano dieci schede socio senza tornare indietro ogni volta.
- **Schede a tab dentro il cliente** invece di una pagina unica che scorre.

---

## Proposta di lavoro, in ordine

1. **Il logo mancante** — è un bug, non un tema di design. Mezz'ora.
2. **Disciplinare il giallo**: un solo significato (azione principale). Badge e zone di caricamento diventano altro.
3. **Rifare l'elenco soci**: colonne che servono (telefono, abbonamento attivo, certificato), intestazioni fisse, larghezza piena.
4. **Sistemare i menu**: Abbonamenti come voce vera, Consuntivo fuori da Impostazioni, Soci e Libro soci vicini.
5. **Uniformare date, separatori e righe ricevuta** (importi in colonna, allineati a destra).
6. **Un solo modo di fare le sezioni** nella scheda socio, e lista prima del modulo.
7. **Avvicinare il gestionale al sito**: stessa famiglia di caratteri per i titoli, stessa larghezza della barra, il marchio più presente.

I punti 1-3 cambiano la giornata di chi lavora. Il 7 è quello che fa sembrare tutto un prodotto solo.
