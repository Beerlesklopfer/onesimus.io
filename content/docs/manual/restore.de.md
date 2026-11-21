---
title: "Restore"
description: "Der Wiederherstellungsassistent: Umfang, Dateiauswahl, Optionen, Befehlsvorschau."
weight: 5
---

Ein Restore beginnt bei einem Job: Rechtsklick im Reiter **Jobs** und **Dateien
wiederherstellen...**. Der *Wiederherstellungsassistent* hat diese Schritte:

1. **Wiederherstellungsbedingungen**: der Quell-Job, Client und FileSet. Umfang: *Alle
   zugehörigen Backups (vollständige Wiederherstellungskette)*, auf Wunsch nur vor einem Datum,
   oder *Nur dieser bestimmte Job*.
2. **Dateien auswählen**: den gesicherten Dateibaum durchsuchen und Dateien und Verzeichnisse
   ankreuzen. Ein Zähler zeigt, wie viele Verzeichnisse und Dateien gewählt sind.
3. **Wiederherstellungsoptionen**: **Ziel-Client**, **Wiederherstellen nach** (der Pfad auf dem
   Ziel) und die **Ersetzungsrichtlinie**:
   - *Immer*: vorhandene Dateien auf dem Ziel immer überschreiben,
   - *Nie*: vorhandene Dateien überspringen,
   - *Wenn neuer*: nur überschreiben, wenn die gesicherte Datei neuer ist,
   - *Wenn älter*: nur überschreiben, wenn die gesicherte Datei älter ist.
4. **Befehlsvorschau**: die Befehle, die an den Director gehen, eine Zusammenfassung (Auswahl,
   geschätzte Größe, Ziel-Client, Pfad, Ersetzungsrichtlinie) und **Berechtigungsprüfungen**: ob
   deine Console den Restore, den Ziel-Client und den Pfad benutzen darf.
5. **Wiederherstellung ausführen**: der Assistent sendet die Befehle nacheinander und zeigt jeden
   in einem Protokoll. Nimmt der Director den Restore-Job an, siehst du seine Job-ID; den
   Fortschritt verfolgst du im Reiter Jobs.

Lehnt der Director den Zielpfad ab, erklärt der Assistent, dass die **Where ACL** der Console ihn
einschränkt und welchen Pfad du bei deinem Administrator erfragen solltest.

{{< screenshot name="restore" alt="Der Wiederherstellungsassistent mit dem Dateibaum" >}}
