---
title: "Mit einem Director verbinden"
description: "Der Verbindungsassistent, gRPC mit TLS und Zertifikats-Fingerabdruck, BNET für Bareos Directors."
weight: 1
---

Onesimus verwaltet ein oder mehrere **Verbindungsprofile**. Ein Profil nennt den Director, das
Protokoll, den Konsolennamen und (wenn du willst) das Passwort. Du verbindest dich mit
**Datei → Verbinden** (Ctrl+O); **Neu verbinden** (Ctrl+R) öffnet die zuletzt benutzte
Verbindung wieder.

## Zwei Protokolle

- **gRPC (Onesimus Director)**: die typisierte API des Onesimus Directors. Sie ist immer mit TLS
  verschlüsselt. Das Zertifikat des Directors bestätigst du bei der ersten Verbindung, danach ist
  es festgehalten (pinned); du meldest dich mit Konsolenname und Passwort an. Über gRPC kommen
  auch Push-Ereignisse: neue Zeilen eines laufenden Job-Protokolls und Statuswechsel von Jobs
  kommen ohne Nachfragen an. Der Standard-gRPC-Port ist der BNET-Port plus 1000
  (9101 + 1000 = 10101).
- **BNET (Bareos-Konsolenprotokoll)**: das klassische Konsolenprotokoll von Bareos, mit TLS-PSK
  (empfohlen) oder TLS mit Zertifikaten. Du nimmst es für einen reinen Bareos Director oder als
  Rückfallebene. Funktionen, die den Onesimus Director brauchen (Schedules ändern, Katalog-ACL,
  Purge-Vorschau für Volumes), sagen dir, wenn die Verbindung sie nicht kann.

## Der Verbindungsassistent

**Datei → Verbindungsassistent...** legt ein neues Profil Schritt für Schritt an:

1. **Wie möchten Sie die Verbindung erstellen?** *Neue Verbindung von Grund auf erstellen*,
   *Vorlage aus vorhandener Verbindung verwenden* oder *Aus ZIP-Datei importieren* (ein Archiv
   der Director-Konfiguration; daraus wählst du Director und Console).
2. **Wo befindet sich Ihr Bareos Director?** Onesimus Directors melden sich im lokalen Netz
   (mDNS) und stehen unter *Im Netzwerk gefunden*; wähle einen aus, dann sind die Daten
   eingetragen. Oder du trägst **Host**, **Port**, **Server-Betriebssystem** und **Protokoll**
   selbst ein, bei gRPC auch den **gRPC-Port**.
3. **Geben Sie Ihre Zugangsdaten ein**: Director-Name, Konsolenname und Passwort. **Erzeugen**
   erzeugt ein zufälliges Passwort; der MD5-Hash für die Director-Konfiguration wird angezeigt.
4. Bei BNET: **Wie soll die Anmeldung erfolgen?** *TLS-PSK (empfohlen)* oder *TLS mit
   Zertifikaten* (CA, Client-Zertifikat und Schlüssel oder eine PFX-Datei; *Zertifikate
   erzeugen...* und *PEM/DER in PFX umwandeln...* helfen dabei).
5. **Vorschau der Serverkonfiguration**: die Console-Ressource (bei gRPC nur sie; eine Zeile
   `Grpc Port = N` für die Director-Ressource nur, wenn der gRPC-Port nicht BNET-Port + 1000 ist)
   zum Einfügen in die Konfiguration des Directors, dazu
   eine Konfiguration für Kommandozeilen-Konsolen (`bconsole`, `oconsole`). *In die
   Zwischenablage kopieren*, *.conf speichern* oder *ZIP speichern*.
6. **Verbindung testen** verbindet einmal und meldet jeden Schritt.
7. **Diese Verbindung benennen**, auf Wunsch *Als Standard festlegen* und *Jetzt verbinden*.

{{< screenshot name="connect" alt="Verbindungsassistent: Director und Protokoll wählen" >}}

## Der Zertifikats-Fingerabdruck (gRPC)

Bei der ersten gRPC-Verbindung zeigt Onesimus den Dialog **Serverzertifikat vertrauen?** mit dem
*SHA-256-Fingerabdruck des Serverzertifikats*. Vergleiche ihn mit dem Fingerabdruck des
gRPC-Zertifikats des Directors, den du vom Administrator des Directors bekommst oder auf dem
Director selbst abliest, bevor du auf **Zertifikat vertrauen** klickst. Wurde derselbe
Fingerabdruck im lokalen Netz (mDNS) angekündigt, sagt der Dialog das, aber das beweist nichts:
jedes Gerät im Netz kann so eine Ankündigung senden. Passt der Fingerabdruck nicht zur
Ankündigung, erscheint eine Warnung.

Ändert sich das Zertifikat später, zeigt der Dialog **Serverzertifikat geändert** den alten und
den neuen Fingerabdruck. Das ist zu erwarten, wenn das Zertifikat auf dem Director neu erzeugt
wurde; sonst hört vielleicht jemand die Verbindung ab.

Unter **Einstellungen → Verbindung** zeigt ein Profil seinen festgehaltenen Fingerabdruck;
**Zertifikat vergessen** entfernt ihn, und die nächste Verbindung fragt wieder.

## Meine Berechtigungen

**Hilfe → Meine Berechtigungen** fragt den Director, welche Befehle deine Console benutzen darf,
gruppiert nach Backup & Restore, Job-Steuerung, Administration und Medien, mit den Details zum
Restore (where=, client=, replace=).
