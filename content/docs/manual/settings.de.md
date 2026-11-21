---
title: "Einstellungen"
description: "Verbindungsprofile, Sprache, Design, Oberflächen-Zoom und Verhalten."
weight: 9
---

**Datei → Einstellungen** (Ctrl+,) hat vier Seiten: **Verbindung**, **Darstellung**,
**Verhalten** und **Erweitert**. **Anwenden** speichert, **Zurücksetzen** stellt die Standardwerte
wieder her.

{{< screenshot name="settings" alt="Der Einstellungsdialog" >}}

## Verbindung

Die *Verbindungsverwaltung* listet die gespeicherten Verbindungsprofile (**+ Hinzufügen**,
**Bearbeiten**, **Duplizieren**, **Löschen**). Ein Profil enthält Host, Port, Protokoll
(*BNET (Bareos-Konsolenprotokoll)* oder *gRPC (Onesimus Director)*), gRPC-Port,
Server-Betriebssystem, Director- und Konsolennamen und das Passwort. Bei BNET auch die
TLS-Einstellungen (PSK oder x509-Zertifikate); bei gRPC den festgehaltenen Fingerabdruck unter
*Serverzertifikat* mit **Zertifikat vergessen**. Optionen: *Passwort im Profil speichern*, *Beim
Start automatisch verbinden*, *Verbindungs-Timeout*. Profile lassen sich exportieren und
importieren.

## Darstellung

- **Oberflächen-Zoom**: die Schrift folgt der Schrift deines Desktops; dieser Faktor vergrößert
  oder verkleinert sie. Mit der Tastatur geht es genauso: Ctrl++ und Ctrl+- (Ansicht →
  Oberfläche vergrößern / verkleinern), Ctrl+0 setzt zurück.
- **Anwendungssprache**: Englisch, Deutsch, Spanisch, Französisch, Italienisch oder Russisch,
  oder *System*, das der Sprache des Betriebssystems folgt. Eine Änderung wirkt nach einem
  Neustart; Onesimus bietet an, sofort neu zu starten (das Menü **Sprache** tut dasselbe).
- Farben der Statusleiste und der Backup-Levels.

Das **Design** wechselt zwischen dunkel und hell mit **Dunkles/helles Design umschalten**
(Ctrl+Shift+T).

## Verhalten

- Bestätigungen vor dem Abbrechen oder Starten eines Jobs.
- **Automatisch aktualisieren** und das Intervall.
- *Maximale Anzahl Jobs* in der Job-Liste und *Neueste Jobs zuerst anzeigen*.
- *Client-Backup ist veraltet nach* (Stunden): die Grenze für veraltete Clients im Reiter
  [Clients](../clients/).
- *Job-Historie messen über die letzten* (Tage): die Historie, aus der die
  [Schedule-Ansichten](../schedules/) Laufzeiten und Wartezeiten messen.
- *Sichtbare Backup-Levels* im Dialog *Backup-Job ausführen*.

## Erweitert

Protokollierung in Datei (*Protokollierung in Datei aktivieren*, Protokolldatei, maximale Größe)
zur Fehlersuche.
