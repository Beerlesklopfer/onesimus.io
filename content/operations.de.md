---
title: "Betriebsbericht"
description: "Wo Onesimus heute läuft, was damit wiederhergestellt wurde und was noch nicht getestet ist."
---

<div class="note">

**Stand: 23. November 2026.** Diese Seite nennt nur, was sich aus dem Katalog, den Testprotokollen und den
Repositories belegen lässt. Es ist die eigene Installation des Maintainers, nicht der Betrieb Dritter.
Backup-Software bewährt sich über Monate und bei Wiederherstellungen; der Bericht wird mit der Zeit fortgeschrieben.

</div>

## Die Produktivinstallation

- **Director:** Der Onesimus Director `odir` ist spätestens seit dem 17. Oktober 2026 der produktive Director.
  Der erste Job, der ihn im Katalog zeigt, ist der Backup-Job 781 von diesem Tag, mit der Director-Zeile
  `Version: 25.1.2+onesimus.0.2.0`. Davor zeigt der Katalog den Bareos-Director; ein früherer Start von `odir` lässt
  sich daraus nicht ablesen.
- **Clients:** Fünf File Daemons sind eingerichtet; vier davon haben in den letzten 30 Tagen gesichert.
- **Katalog:** der PostgreSQL-Katalog von Bareos. Onesimus ändert die Bareos-Tabellen von seinem Entwurf her nicht
  (Bareos-Schema-Version 2250); eigene Views, Funktionen und Tabellen liegen in einem eigenen Schema `onesimus`.
- **Storage:** Der Haupt-Storage-Daemon ist weiterhin `bareos-sd`. Seit dem 21. November 2026 läuft der Onesimus
  Storage Daemon `osd` auf einem zweiten Rechner im Probebetrieb: als Storage eines Test-Backup-Jobs und seit dem
  23. November 2026 als Ziel der Copy-Jobs.

## Wiederherstellungen mit dem Onesimus Director

Wiederherstellungen im Produktivkatalog:

| Job | Dateien | Daten | Status |
|---|---|---|---|
| 865 | 24.506 | 5,0 GB | OK |
| 936 | 369 | 9,45 GB | OK |
| 884, 885, 886, 887, 888, 891, 935, 988, 990, 991, 1044, 1045, 1046, 1143 | | | OK |
| 851, 852 | | | mit Fehler beendet |
| 866 | | | abgebrochen |

## Außerhalb des Produktivbetriebs getestet

- **File Daemon unter Windows:** `ofd` wurde auf einer virtuellen Windows-11-Maschine mit Volume Shadow Copy und
  UNC-Pfaden getestet. Eine Datei über 4 GiB wurde bitgleich wiederhergestellt. Eine Sicherung von Laufwerk C: ohne
  die Windows-, Programm- und Werkzeugordner (195.895 Dateien, 21,3 GB gelesen, 13,1 GB geschrieben) endete OK und
  ohne Fehler; ihre Wiederherstellung ist nicht getestet.
- **Storage Daemon:** `bls` aus Bareos liest `osd`-Volumes in der Testumgebung. `osd` bringt kein eigenes `bscan` und
  `bextract` mit; die Bareos-Werkzeuge mit `osd`-Volumes sind nicht getestet.
- **Plugins:** Die Broker und die signierten File-Daemon-Plugins sind in der Testumgebung des Repositorys getestet.
- **GUI:** wird bei jedem Push unter Linux und Windows gebaut und getestet, unter macOS gebaut und paketiert.

## Noch nicht getestet

Das sagen wir offen, weil diese Punkte für eine Entscheidung wichtig sind. Für keinen davon haben wir einen Testnachweis:

- **Der Rückweg zu Bareos** mit derselben Datenbank: ein echter `bareos-dir` auf einem Katalog, den `odir` erweitert
  hat, danach eine Wiederherstellung. Er ist so entworfen (kein Onesimus-Objekt hängt von einer Bareos-Tabelle ab)
  und unter [Umstieg von Bareos](/de/docs/install/migrate-from-bareos/) beschrieben, aber nicht belegt.
- **Die Geschwindigkeit von OVFS gegenüber BVFS.** Ein Test vergleicht beide Listen Byte für Byte; wie viel schneller
  OVFS ist, sagen wir erst nach einer Messung.
- **WebAssembly-Plugins im Produktivbetrieb** und ein externes Sicherheits-Review.
- **Der File Daemon unter macOS.**

Korrekturen und Berichte aus deinem eigenen Betrieb sind auf
[GitHub](https://github.com/Onesimus-io/Onesimus/issues) willkommen.
