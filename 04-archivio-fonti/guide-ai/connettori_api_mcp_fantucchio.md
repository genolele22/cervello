# Connettori, API e MCP — Le vene del cervello AI
*Andrea Fantucchio, maggio 2026 — Parte 2 di 7*

## Il concetto in una riga
Un cervello AI senza connettori lavora solo sul passato.
Le API e gli MCP gli danno accesso ai dati che cambiano in tempo reale.

## I 5 passi per un uso sicuro dei connettori
1. Parti dai permessi di lettura — non di scrittura
2. Chiedi sempre fonti e limiti espliciti
3. Fai preparare bozze, non invii automatici
4. Approva ogni azione che modifica qualcosa
5. Collega un nuovo strumento solo quando sai perché ti serve

## Prompt pronti per i connettori nativi di Claude

### Gmail — trova cosa richiede azione
"Guarda le email degli ultimi 7 giorni e trova solo quelle che richiedono
una mia azione. Raggruppale per progetto, indica mittente, data,
cosa viene richiesto e prossima azione consigliata."

### Gmail + Calendar — riepilogo settimanale
"Prepara un riassunto sintetico di prossime scadenze e urgenze.
Usa i connettori di Gmail e Google Calendar.
Dividi la risposta in: cose successe, decisioni da prendere,
attività da chiudere entro venerdì.
Se una fonte non è collegata, dimmelo chiaramente."

### Test connettori — verifica che funzionino davvero
"Voglio capire se i miei connettori funzionano davvero.
Usa solo le fonti collegate in questa chat.
Restituiscimi:
1. quali connettori sei riuscito a usare
2. quali informazioni hai trovato
3. da quale fonte arrivano
4. quali azioni potresti fare ma non farai senza mia conferma
5. quali limiti hai incontrato
Non creare, modificare, inviare o cancellare nulla."

### Configurazione guidata
"Voglio collegare le mie applicazioni principali alla mia AI.
Fammi prima 5 domande per capire quali strumenti uso davvero.
Quando hai tutte le informazioni, proponimi una configurazione
minima in ordine di priorità.
Per ogni connettore spiega: perché mi serve, quali permessi richiede,
quali rischi devo valutare, un primo prompt sicuro per testarlo,
cosa non devo autorizzare se non sono sicuro."

## Gemini — connettore nativo Google Workspace
Zero configurazione, zero MCP, zero terminale.
Si connette nativamente a Gmail, Docs, Drive, Calendar, Tasks e Keep.
Limite: non può inviare email al posto tuo. Solo lettura e riassunti su Gmail.
Complementare a Claude, non sostitutivo.

## Caso studio: lancio corso con Claude + Vercel + Analytics
Modello applicabile al lancio di The Raven.
Stack usato: Claude + Vercel (landing) + link UTM + Stripe.

Formato link UTM:
https://tuolink.it/?utm_source=substack&utm_medium=newsletter&utm_campaign=nome-lancio

Prompt per analisi dati post-lancio:
"Analizza i dati del lancio di [PRODOTTO].
Dimmi: quante vendite/iscrizioni, da quali canali, quali dati sono sicuri
e quali stimati, cosa ha funzionato, cosa no, errori operativi, cosa cambiare.
Non inventare dati mancanti. Se una fonte non è leggibile, segnalalo."

## Per strumenti non nativi: Zapier, Make, n8n
Prima di scegliere lo strumento, chiediti:
"Quale informazione aggiornata vorrei che la mia AI avesse senza doverla copiare ogni volta?"

- Pagamenti e ordini → Stripe
- Risposte utenti → Google Forms, Typeform
- CRM e lead → HubSpot, Notion
- Community → Circle, Slack
