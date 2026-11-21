---
title: "Storage und Volumes"
description: "Pools und Volumes, wann ein Volume wiederverwendet wird, und die Datenbankbereinigung mit der Purge-Vorschau."
weight: 4
---

Der Reiter **Storage/Volumes** listet die Volumes des Directors: Volume, Pool, Status, belegt,
Grenze, Jobs, zuletzt geschrieben, Aufbewahrung, **Wiederverwendbar ab** und **Grund**. Du kannst
nach **Pool** und **Status** filtern; der Kasten *Statistik* zählt die Volumes und den belegten
Platz. Der Reiter aktualisiert sich beim Öffnen; **Aktualisieren** (Ctrl+Shift+V) lädt ihn
jederzeit neu.

{{< screenshot name="storage" alt="Der Reiter Storage/Volumes mit Pools und Volumes" >}}

## Wann wird ein Volume wiederverwendet?

*Wiederverwendbar ab* ist der früheste Tag, ab dem Bareos ein Volume wiederverwenden darf. Bareos
tut das erst, wenn sein Pool ein Volume braucht; es ist also der früheste Tag, nicht der Tag des
Recyclings. Die Spalte *Grund* erklärt das Datum in Worten, zum Beispiel:

- Append-Volumes: offen bis voll oder bis zum Ende der Use Duration, danach die Volume Retention;
- Purged: kein Job braucht es mehr, sofort wiederverwendbar;
- Archive, Disabled, Read-Only oder Error: Bareos pruned oder recycelt so ein Volume nie (ein
  Volume im Status Error behält seinen Platz, bis sein Status geändert wird);
- Recycle = no: das Volume wird nie wiederverwendet.

Enter oder ein Doppelklick öffnet die *Volume-Details* mit allen Werten des Volumes (Media Type,
Storage, Fehler, zuerst und zuletzt geschrieben, gelabelt, Volume Retention, Use Duration,
Recycle Pool, wie oft recycelt und mehr).

## Datenbankbereinigung und Volumes purgen

**Werkzeuge → Datenbankbereinigung...** entfernt alte Daten aus dem Katalog in zwei Schritten:
**Analysieren** zeigt, was entfernt würde, **Bereinigen** tut es nach einer Bestätigung.
Optionen:

- *Alte Full-Backups entfernen*: die letzten *n* Full-Backups je Client, Job und FileSet bleiben;
  ein Full-Backup, von dem noch Incremental- oder Differential-Backups abhängen, bleibt auch;
- *Erfolgreiche Jobs ohne Dateien entfernen*;
- *Fehlgeschlagene Jobs entfernen, älter als* eine Zahl von Tagen;
- *Volumes prunen*: die Aufbewahrungsfristen auf alle Volumes anwenden.

Die Analyse betrachtet die Jobs, die gerade in der Job-Liste geladen sind. Jeder Befehl und jede
Antwort des Directors steht im Protokoll des Dialogs.

### Volumes purgen (erst die Vorschau)

Mit dem Onesimus Director stellst du bei *Volumes prunen* die Aktion **Prune und Purge** ein:
dann erscheint im selben Dialog der Bereich **Volumes purgen**. Er purged ganze Volumes: alle
Job- und Datei-Einträge der gewählten Volumes werden aus dem Katalog entfernt, egal was die
Aufbewahrungsfristen sagen. Der Purge gehört nicht zu *Bereinigen*; er hat seine eigene Vorschau
und seinen eigenen Knopf.

1. Wähle den **Pool** (oder *Alle Pools*) und die Werte für **Volume-Status**.
2. **Vorschau** fragt den Director, welche Volumes er purgen würde; nichts wird geändert. Die
   Tabelle zeigt jedes Volume mit Jobs, Dateien, Größe und dem Ergebnis *Würde gepurged* oder
   *Übersprungen* (mit Grund).
3. **Purge** purged die Volumes der Vorschau nach einer Bestätigung, die den genauen Befehl
   zeigt. Änderst du die Auswahl, brauchst du eine neue Vorschau.

Der Director wählt die Volumes beim Purge noch einmal aus; Volumes, die sich seit der Vorschau
geändert haben, werden nach ihrem dann gültigen Zustand gepurged oder übersprungen. Die Vorschau
nutzt die Onesimus-Erweiterung `purge volume all ... dryrun|yes` (siehe
[`purge`](/docs/commands/purge/)). Ein reiner Bareos Director hat keinen Befehl, der alle Volumes
auf einmal purged; dort lässt sich *Prune und Purge* nicht auswählen.

{{< screenshot name="purge" alt="Der Purge-Bereich mit der Vorschau der Volumes" >}}
