---
title: "Schedules"
description: "Die Zeitachse der Nacht mit gemessenen Laufzeiten und erwarteten Wartezeiten, der Raster-Editor, der Vorschlag zum Entzerren und der Schedule-Assistent."
weight: 6
---

Der Reiter **Schedules** zeigt, wann deine Jobs laufen, wie lange sie brauchen und wo sie
aufeinander warten. Die Ansicht wechselt zwischen **Zeitachse**, **Raster** und **Gemessene
Wartezeiten**. Links steht die Liste der Schedules, daneben eine Tabelle der Jobs der gewählten
Schedules mit Typ, Client, Storage, FileSet und **Mediane Dauer**.

Schedules ändern, kopieren, umbenennen und löschen geht über die Konfigurationsmethoden des
Onesimus Directors per gRPC. Bei einer BNET-Verbindung sind die Ansichten nur lesbar, und ein
Klick auf eine schreibende Funktion sagt dir, warum sie nicht verfügbar ist.

## Zeitachse

Die Zeitachse zeigt die Läufe eines **Tag**s oder einer **Woche** (**Heute** springt zurück), in
zwei Spuren: **Clients (FD)** und **Storage (SD)**. **Zoom** stellt die Pixel pro Stunde ein,
**Einrasten** das Raster, an dem ein gezogener Balken einrastet.

- Die Länge eines Balkens ist die **mediane Dauer** der gemessenen Läufe des Jobs auf diesem
  Level; eine hellere Verlängerung markiert das 90. Perzentil (neun von zehn Läufen waren bis dahin
  fertig). Die Farbe steht für das Level (Full, Differential, Incremental, Virtual Full).
- Ein blasser, gestrichelter Balken mit "~" ist aus anderen Levels geschätzt; ein gestrichelter
  Umriss mit "?" markiert einen Job, der noch nie lief.
- Eine **Sanduhr** markiert einen Lauf, der warten wird; der schraffierte Streifen ist die
  erwartete Wartezeit, von der geplanten Zeit bis zum erwarteten Start. In der Tagesansicht zeigen
  Pfeile, welcher Lauf auf welchen wartet und wegen welcher Grenze.
- **Gemessene Läufe** fügt unter den Balken eine dünne Spur mit den Läufen vergangener Tage und
  von heute hinzu, so wie die Job-Historie sie gemessen hat, samt der Wartezeit.
- Laufende Jobs erscheinen mit den Zeiten, die der Director meldet; ihr Tooltip sagt *Läuft
  jetzt* oder *Wartet jetzt*.

**Legende** erklärt jedes Zeichen. Die Laufzeiten stammen aus der Job-Historie der letzten Tage;
wie viele Tage, stellst du unter **Einstellungen → Verhalten** ein (*Job-Historie messen über die
letzten*).

{{< screenshot name="schedules" alt="Zeitachse der Nacht mit gemessenen Laufzeiten und Wartezeiten" >}}

### Erwartete Wartezeiten

Die Reiter unter der Zeitachse heißen **Erwartete Wartezeiten**, **Gemessene Historie** und
**Entzerren**. *Erwartete Wartezeiten* listet jeden Lauf, der voraussichtlich wartet oder dessen
Vorhersage unsicher ist, mit geplanter Zeit, erwartetem Start, Wartezeit, gemessener Wartezeit und
Grund. Die Vorhersage spielt die Warteschlange des Directors nach, aus seinen Grenzen (Maximum
Concurrent Jobs von Director, Clients, Storages und Jobs, Prioritäten) und den gemessenen
Laufzeiten. Eine Grenze, die der Director nicht meldet, etwa die parallelen Schreiber eines
Geräts im Storage Daemon, kannst du eintragen; bis dahin gelten die davon abhängigen Läufe als
unsicher. Ein *Rückwärtstest* vergleicht die Vorhersage mit der Historie.

### Einen Lauf verschieben

Zieh einen Balken auf eine andere Zeit, um seine Run-Zeile zu verschieben. Nur diese Zeile wird
neu geschrieben; die anderen Zeilen bleiben, wie sie in der Datei stehen. Benutzen mehrere Jobs
den Schedule, fragt Onesimus: **Schedule ... für alle ... Jobs ändern** oder **Nur Job ...
verschieben**; das legt eine Kopie des Schedules mit dem Lauf zur neuen Zeit an und setzt den
Schedule dieses Jobs darauf.

## Gemessene Wartezeiten

Diese Ansicht listet je Job und Level die gemessenen Läufe, mediane und 90-%-Dauer, mediane und
90-%-Wartezeit und den letzten Lauf. *Wartezeit* ist der Start des Jobs minus seine geplante
Zeit. **Historie aktualisieren** fragt den Director erneut nach den Jobs der letzten Tage.

## Vorschlag zum Entzerren

Jobs, die für denselben Moment geplant sind und eine Grenze teilen (ein Storage, ein Client, die
Job-Plätze des Directors, die parallelen Schreiber eines Geräts), warten aufeinander. **Spätere
Startzeiten vorschlagen** im Reiter *Entzerren* spielt die Warteschlange mit Jobs nach, die
Viertelstunde für Viertelstunde später starten (23:15, 23:30 ...), und behält die kleinsten
Verschiebungen mit der geringsten Wartezeit. Warten auf eine höhere Priorität ist gewollt und
zählt nicht; ein Job niedrigerer Priorität, der einem verschobenen Job folgt, wandert mit.

Die Tabelle zeigt je Job den jetzigen und den vorgeschlagenen Start, wie viel später, die
Wartezeit jetzt und danach und eine Notiz. **Einschränkungen...** hält einen Job fest
(*Fixiert*) oder setzt einen *Spätesten Start*; die Einschränkungen bleiben auf deinem Rechner,
für diesen Director.

**Anwenden...** legt für jeden Job, der später startet, einen eigenen Schedule an, benannt nach
dem alten plus der neuen Startzeit (zum Beispiel `Nightly-2315`), und setzt den Schedule des Jobs
darauf. Alles wird einmal zur Bestätigung gezeigt; der Director prüft jede Ressource, und die
erste, die er ablehnt, stoppt den Rest. Vor deiner Bestätigung ändert sich nichts.

{{< screenshot name="schedule-stagger" alt="Vorschlag zum Entzerren mit Startzeiten im Viertelstundenraster" >}}

## Raster-Editor

Die Ansicht **Raster** zeigt den gewählten Schedule als Raster aus Wochentagen und Stunden,
nach Level eingefärbt.

- **Pinsel**: ein Pinsel ist ein Level, die Minute der Stunde und auf Wunsch Overrides, die
  Einstellungen des Jobs ersetzen (Storage, Pool, Messages, Full/Incremental/Differential/Next
  Pool, Priorität, Spool Data, Accurate, Max Run Sched Time). **Neuer Pinsel...** legt einen an;
  der **Radierer** entfernt Läufe. Im *Malmodus* malt Ziehen sofort; sonst wählst du Zellen aus
  und drückst die Leertaste. *Andere Läufe behalten* fügt einen Pinsel zu einer Zelle hinzu,
  statt ihre Läufe zu ersetzen.
- **Bereiche**: Wochen des Monats und Monate, für die ein Raster gemalt wird, etwa "1st sat at
  21:00". **Bereich hinzufügen** legt einen an; Läufe anderer Bereiche erscheinen schraffiert.
- **Kalenderregeln**: Run-Zeilen nach Tag des Monats oder Woche des Jahres (etwa "on 1 at 21:00")
  gehören zu keinem Wochentag; **Regel hinzufügen...**, **Regel bearbeiten...** und **Regel
  entfernen** verwalten sie.
- **Run-Zeilen** listet die Zeilen des Schedules; wählst du eine, werden ihre Zellen umrandet.
- **Beschreibung** ist die Description des Schedules; sie wird mit den Run-Zeilen gespeichert.
- Rückgängig und Wiederherstellen (Ctrl+Z, Ctrl+Shift+Z) und **Alles zurücksetzen**.

**Speichern...** schreibt die geänderten Run-Zeilen. Der Director prüft sie vorher; die Übersicht
zeigt die Run-Zeilen jetzt und nach dem Schreiben, die Jobs, die den Schedule benutzen, und den
Text nach dem Schreiben, den du noch bearbeiten kannst (*Beim Director prüfen*). Erst **Auf den
Director schreiben** schreibt ihn; Zeilen, die du nicht angefasst hast, bleiben, wie sie in der
Datei stehen. **Löschen...**, **Kopieren...** und **Umbenennen...** arbeiten genauso, mit Prüfung
und Bestätigung. Ein Schedule mit einer Run-Zeile, die die GUI nicht versteht, ist gesperrt und
muss in seiner Konfigurationsdatei geändert werden.

{{< screenshot name="schedule-editor" alt="Schedule-Raster: Wochentage mal Stunden, nach Level gemalt" >}}

## Assistent für neue Schedules

**Schedules → Schedule hinzufügen...** öffnet *Neuer Schedule*: Name, Beschreibung und
*Aktiviert*, dann die auf das Raster gemalten Läufe, dann eine Übersicht der Run-Zeilen, der
Ressource und des Director-Befehls (*Ressource kopieren* kopiert den Text). Am Ende fragt der
Assistent, ob er `configure add` an den Director senden soll; der Director prüft den Schedule und
legt ihn an.
