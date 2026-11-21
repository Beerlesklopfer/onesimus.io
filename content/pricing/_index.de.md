---
title: "Preise"
description: "1 TB pro Monat frei für jeden Haushalt. Early-Bird-Preise für alle, die vor v1.0.0 reservieren."
layout: "pricing"
label: "Preise"
headline: "1 TB im Monat ist frei.<br>Du zahlst erst, wenn du mehr brauchst."
subtitle: "Onesimus ist Open Source unter der AGPL-3.0. Jede Edition hat alle Funktionen; sie unterscheiden sich nur darin, wie viel der Director im Monat schreiben darf, und im Support. Preise je Director und Jahr: Home Plus inklusive Umsatzsteuer, die Business-Editionen zuzüglich Umsatzsteuer."
badge: "Early Bird"
earlybird: "**Early Bird bis v1.0.0:** Reserviere jetzt per E-Mail eine Lizenz und behalte den Early-Bird-Preis, solange dein Abo ohne Unterbrechung läuft. Vor dem Release von v1.0.0 zahlst du nichts; dann bekommst du deine Lizenzdatei."
tiers:
  - name: "Free"
    price: "0 €"
    limit: "1 TB geschrieben pro Monat"
    desc: "Für Haushalte: Fotos, Dokumente und ein paar Rechner, mit monatlichem Full und täglichen Incrementals."
    features:
      - "Alle Funktionen der GUI und des Rust-Stacks"
      - "Bareos bleibt dein Rückweg"
      - "Community-Support auf GitHub"
    button: "Installieren"
    url: "/de/docs/install/"
  - name: "Home Plus"
    price: "29 €"
    per: "/ Jahr inkl. USt."
    regular: "Early Bird, später <s>39 €</s>"
    limit: "5 TB geschrieben pro Monat"
    desc: "Für große Mediensammlungen und Homelabs."
    features:
      - "Alles aus Free"
      - "Signierte Lizenzdatei"
      - "Support per E-Mail"
    button: "Reservieren"
    url: "mailto:contact@onesimus.io?subject=Onesimus%20Home%20Plus%20Early%20Bird"
    featured: true
  - name: "Small Business"
    price: "199 €"
    per: "/ Jahr zzgl. USt."
    regular: "Early Bird, später <s>290 €</s>"
    limit: "25 TB geschrieben pro Monat"
    desc: "Für Büros, Praxen und kleine Firmen."
    features:
      - "Alles aus Home Plus"
      - "Hilfe beim Umstieg von Bareos"
      - "Support per E-Mail, Antwort an Werktagen"
    button: "Reservieren"
    url: "mailto:contact@onesimus.io?subject=Onesimus%20Small%20Business%20Early%20Bird"
  - name: "Business"
    price: "690 €"
    per: "/ Jahr zzgl. USt."
    regular: "Early Bird, später ab <s>990 €</s>"
    limit: "unbegrenzt"
    desc: "Für Firmen, die vereinbarte Reaktionszeiten brauchen."
    features:
      - "Alles aus Small Business"
      - "Vereinbarte Reaktionszeiten"
      - "Hilfe bei Installation und Betrieb"
    button: "Reservieren"
    url: "mailto:contact@onesimus.io?subject=Onesimus%20Business%20Early%20Bird"
---

## Fragen

### Was zählt zum Limit?
Die Bytes, die der Director in einem Kalendermonat schreibt: jeder Full-, Differential- und
Incremental-Job mit seiner ganzen Größe. Restores zählen nie. Die GUI zeigt den Verbrauch des Monats in
ihrer Statuszeile, zusammen mit den Bytes der Jobs, die gerade laufen:

{{< screenshot name="statusbar-usage" variant="strip" alt="Statuszeile der Onesimus-GUI: Verbrauch des Monats von 1 TB, neben der Verbindung" >}}

Ab 80 % des Limits ist der Verbrauch hervorgehoben, damit du ihn kommen siehst, bevor das Limit erreicht
ist:

{{< screenshot name="statusbar-near" variant="strip" alt="Statuszeile mit hervorgehobenem Verbrauch: 860.6 GB von 1 TB" >}}

Mit Lizenz warnt die Statuszeile ab 30 Tagen vor dem Ende der Jahreslizenz, in der letzten Woche in Rot:

{{< screenshot name="statusbar-licence" variant="strip" alt="Statuszeile: die Lizenz endet in 12 Tagen, neben dem Verbrauch des Monats" >}}

### Was passiert am Limit?
Ab v1.0.0 startet die freie Edition keine neuen Backup-Jobs mehr, sobald das Terabyte des Monats
geschrieben ist; laufende Jobs laufen zu Ende, Restores gehen immer, und am Monatsersten beginnt die
Zählung neu. Deine Daten werden nie gelöscht.

### Warum ein Limit, wenn der Code offen ist?
Onesimus ist freie Software unter der AGPL-3.0 und bleibt es. Das Limit gehört zu den offiziellen
Paketen; die Lizenz bezahlt signierte Pakete, Updates und Support.

### Was, wenn mein Abo endet?
Der Director fällt auf die freie Edition mit ihrem Terabyte pro Monat zurück. Nichts geht verloren, und
jedes Backup lässt sich weiter zurückspielen.
