---
title: "3-2-1-Prüfung"
description: "Prüft für jeden Backup-Job, ob es 3 Kopien der Daten auf 2 Medientypen gibt, davon 1 extern."
weight: 8
---

**Werkzeuge → 3-2-1-Prüfung...** prüft für jeden Backup-Job, ob es **3** Kopien der Daten auf
**2** Medientypen gibt, davon **1** extern. Die Prüfung liest nur: sie ändert nichts auf dem
Director.

{{< screenshot name="check-321" alt="Der Dialog der 3-2-1-Prüfung" >}}

## Die Tabelle

Eine Zeile je Backup-Job: Job, Client, **Kopien**, **Medientypen**, **Extern**, **Bewertung** und
**Grund**.

- *Kopien* zählt die Kopien der Daten, die ein Restore benutzen würde: die Kette (das Backup mit
  den Jobs, von denen es abhängt), ihre vollständigen Kopien (Copy-Jobs) und, wenn eingestellt,
  die Originaldaten.
- *Medientypen* zählt die verschiedenen Media Types der Volumes der Kette und ihrer vollständigen
  Kopien.
- *Extern* zählt Kopien an einem anderen Standort, nach deiner Markierung der Storages oder einer
  Location des Volumes.

Unter der Tabelle listet **Kette und Kopien** die Jobs, die ein Restore benutzen würde, und ihre
Kopien samt Volumes; **Warum, und was tun** gibt Gründe, Vorschläge und Hinweise zum gewählten
Job.

## Einstellungen der Prüfung

- **Originaldaten als Kopie zählen**: die 3-2-1-Regel wird meist als Produktivdaten plus 2
  Backups formuliert. Aus: es braucht 3 Backups.
- **Externe Storages**: Bareos merkt sich nicht, wo ein Storage steht. Kreuze die Storages an,
  die an einem anderen Standort stehen.
- **Nicht markierte Storages sind vor Ort**: ohne diese Option gilt ein nicht angekreuzter
  Storage als *unbekannt*, nicht als vor Ort.

**Aktualisieren** lädt die Jobs, die Volumes der Jobs und die Volume-Liste neu.
