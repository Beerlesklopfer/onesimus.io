---
title: "Jobs"
description: "Die Job-Liste, Filter und Statistik, Job-Details, das Live-Job-Protokoll, Jobs starten, wiederholen und abbrechen."
weight: 2
---

Der Reiter **Jobs** listet die Jobs aus dem Katalog: Job-ID, Name, Client, Startzeit, Endzeit,
Dauer, Typ, Level, Dateien, Größe und Status. Über gRPC liefert der Onesimus Director eine
typisierte Job-Liste mit Start- und geplanter Zeit.

{{< screenshot name="overview" alt="Der Reiter Jobs mit der Job-Liste und dem Statistik-Dock" >}}

## Filter und Aktualisieren

**Filter** blendet den Filterbereich ein oder aus:

- *Grundfilter*: **Job-Name**, **Client** und die Statusfelder Erfolgreich (T), Warnung (W),
  Fehlgeschlagen (F), Fehler (E), Läuft (R) und Abgebrochen (A), dazu **Null Bytes** (nur Jobs,
  die nichts übertragen haben).
- **Backup-Stufe**, **Datumsbereich** (*Datumsfilter aktivieren*, Von, Bis) und **Job-Details**
  (FileSet, Storage, Pool). **Filter zurücksetzen** leert sie.

Filter bleiben über einen Neustart erhalten. Ist ein Filter aus der letzten Sitzung aktiv, sagt
das eine Warnzeile über der Tabelle, damit dich eine leere Tabelle nicht überrascht.

**Aktualisieren** (Ctrl+Shift+J) lädt die Liste neu; **Automatisch aktualisieren** lädt sie alle
5 s, 10 s, 30 s, 1 min oder 5 min. Bei vielen Jobs lässt sich die Liste seitenweise anzeigen
(*Seitenweise Anzeige aktivieren*, *Einträge pro Seite*).

Das Dock **Statistik** (Ansicht → Statistik anzeigen) fasst die Jobs der Liste zusammen: Jobs
gesamt, ausgewählt, erfolgreich, Warnungen, fehlgeschlagen, Dateien, Größe und Zeitraum.

## Kontextmenü

Ein Rechtsklick auf einen Job bietet **Details anzeigen...**, **Job wiederholen**, **Job
abbrechen**, **Job löschen**, **Protokoll anzeigen...**, **Dateien wiederherstellen...**, **Als
JSON exportieren...**, **Als CSV exportieren...** und die Auswahlbefehle. Alles, was etwas
ändert, fragt vorher.

- **Job wiederholen** startet den Job nach der Frage *Job erneut ausführen* noch einmal.
- **Job abbrechen** bricht einen laufenden Job nach einer Bestätigung ab.
- **Job löschen** hat zwei Modi: *Nur Job-Eintrag löschen* (der Katalogeintrag geht, die Daten
  auf den Volumes bleiben) oder *Prune* (abgelaufene Jobs gemäß Aufbewahrungsrichtlinie
  entfernen). Hängen an einem Full-Backup noch Incremental- oder Differential-Jobs, warnt der
  Dialog, dass sie für einen Restore unbrauchbar werden können.
- **Dateien wiederherstellen...** öffnet den [Wiederherstellungsassistenten](../restore/).

## Job-Details

**Details anzeigen...** öffnet die *Job-Details*: Job-ID, Name, Client, Typ, Level, FileSet,
Schedule, Startzeit, Dauer, gesicherte Dateien, Datenmenge und Job-Status, mit Reitern für die
Dateien und das Protokoll des Jobs.

## Das Live-Job-Protokoll

Das Feld **Job-Protokoll** unter der Liste (Ansicht → Job-Protokoll anzeigen, Ctrl+Shift+L)
zeigt das Protokoll des gewählten Jobs; der Reiter **Messages** daneben die Meldungen des
Directors. Die Kopfzeile nennt den Job, seine ID und die Zahl der Zeilen, solange er läuft mit
dem Zusatz, dass er läuft.

Während ein Job läuft, wächst das Protokoll von selbst:

- über **gRPC** schickt der Onesimus Director jede neue Zeile, sobald sie entsteht;
- über **BNET** fragt die GUI alle paar Sekunden den Katalog.

Endet der Job, wird das Protokoll noch einmal aus dem Katalog geladen, damit es vollständig ist.
Du kannst im Protokoll suchen, Zeilen kopieren und über *Verlauf* zu früher geladenen
Protokollen zurückgehen.

{{< screenshot name="job-log" alt="Ein laufender Job mit seinem Live-Job-Protokoll" >}}

## Einen Job starten

**Jobs → Job ausführen** öffnet *Backup-Job ausführen*: wähle den **Job** und bei Bedarf
**Client**, **Level**, **FileSet**, **Pool**, **Storage**, **Priorität** und **Wann** (Startzeit
als YYYY-MM-DD HH:MM:SS, leer für sofort). *Erweitert* enthält Bootstrap- und Ersetzungsoptionen.
Die **Befehlsvorschau** zeigt genau den `run`-Befehl, der gesendet wird; **Schätzen** fragt den
Director vorher nach der erwarteten Zahl der Dateien und der Größe. **Job ausführen** sendet ihn
nach einer letzten Bestätigung.
