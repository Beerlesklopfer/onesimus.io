---
title: "Clients"
description: "Der Reiter Clients: letztes Backup, veraltete Clients und Client-Details."
weight: 3
---

Der Reiter **Clients** listet die File Daemons des Directors mit Name, Adresse, Port, letztem
Backup, Betriebssystem, Version, letzter Verbindung, Jobs und Datenmenge.

{{< screenshot name="clients" alt="Der Reiter Clients mit dem Zustand jedes Clients" >}}

## Aktuell, veraltet, nie

Der Filter **Letztes Backup** teilt die Clients ein in:

- **Aktuell**: das letzte Backup oder der letzte Kontakt ist jünger als die Grenze in den
  Einstellungen,
- **Veraltet**: älter als diese Grenze,
- **Nie**: kein bekanntes Backup und kein Kontakt,
- **Unbekannt**: die Zeit des letzten Backups lässt sich nicht lesen.

Die Grenze ist *Client-Backup ist veraltet nach* unter **Einstellungen → Verhalten** (in
Stunden). Der Wert kommt aus der Job-Historie; es ist keine Live-Prüfung der Verbindung. Der
Kasten *Statistik* über der Tabelle zählt die Clients jeder Gruppe. **Nach Client filtern...**
grenzt die Liste nach Namen ein, **Auto** aktualisiert sie automatisch.

## Client-Details

Ein Doppelklick oder **Clients → Client-Details anzeigen** (im Kontextmenü auch *Details /
Export...*) öffnet die *Client Details* mit allgemeinen und Verbindungsangaben, den
Aufbewahrungsregeln (Auto Prune, File Retention, Job Retention), den letzten Jobs des Clients und
ihrer Statistik (Jobs gesamt, erfolgreiche und fehlgeschlagene Jobs, Datenmenge und Dateien).

**Clients → Neuen Client hinzufügen...** legt eine Client-Ressource auf dem Director an.
