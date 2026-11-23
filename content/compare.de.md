---
title: "Onesimus und Bareos im Vergleich"
description: "Was der Onesimus Director zu Bareos hinzufügt, wo er sich bewusst anders verhält und was Bareos kann, das Onesimus noch nicht kann."
---

Onesimus ist aus Bareos hervorgegangen und bleibt mit ihm kompatibel: Der Onesimus Director `odir`
liest die Bareos-25-Konfiguration, nutzt den PostgreSQL-Katalog von Bareos und spricht die
Bareos-Protokolle mit `bconsole`, File Daemons und Storage Daemons. Diese Seite nennt nur
Unterschiede, die sich im Quellcode nachprüfen lassen. Wo Bareos vorn liegt, steht das auch da.

<div class="note">

**Stand:** Onesimus ist noch nicht so etabliert wie Bareos. Bareos ist ein ausgereiftes Projekt mit vielen Jahren
Produktionseinsatz und kommerziellem Support. Brauchst du etwas aus dem letzten Abschnitt dieser
Seite, bleib bei Bareos, oder lass `bareos-dir` als Rückweg installiert (siehe
[Umstieg von Bareos](/de/docs/install/migrate-from-bareos/)). Wo Onesimus heute läuft und was noch nicht getestet
ist: [Betriebsbericht](/de/operations/).

</div>

## Was der Onesimus Director hinzufügt

| Funktion | Bareos Director 25 | Onesimus Director |
|---|---|---|
| Ressourcen auf der Konsole ändern und löschen | `configure` kennt `add` und `export` | dazu `configure update` (Direktiven ändern), `configure delete` (nur nicht referenzierte Ressourcen) und den Rohtext einer Ressource mit `.config read type=… name=…` auf der Konsole oder `ReadResource` über gRPC (`configure read` liefert nur eine kurze Zusammenfassung) |
| Schnittstelle für Programme | Konsolenprotokoll; JSON-Ausgabe mit `.api 2` | zusätzlich eine typisierte gRPC-API mit TLS: eine RPC je Befehl mit strukturierten Protobuf-Antworten, dieselben ACLs wie auf der Konsole |
| Live-Ereignisse | Job-Meldungen werden abgefragt (`messages`, `list joblog`) | gRPC-Push-Ereignisse: Job-Status, Job-Meldungen, Verbindungen von File und Storage Daemons, jeweils nach den ACLs der Console gefiltert |
| Live-Job-Log in der Oberfläche | — | ja, aus den Push-Ereignissen (an Bareos fragt die Oberfläche regelmäßig ab) |
| ACLs je Console ohne Dateien zu bearbeiten | ACLs stehen in den Konfigurationsdateien | Katalog-ACLs je Console mit `.acl list/set/delete/clear/copy`; wirksam ist Datei-ACL **und** Katalog-ACL, eine Console kann die eigenen Rechte nur enger machen |
| Viele Volumes auf einmal purgen | kein Befehl; `purge volume pool=…` öffnet eine Auswahl | `purge volume all pool=<p>\|allpools [volstatus=…] dryrun\|yes`: `dryrun` zeigt eine Vorschau und ändert nichts, `yes` purgt jedes Volume mit denselben Prüfungen wie ein einzelnes `purge volume` |
| Grammatik der Konsole | — (`.help`) | `.grammar` liefert jeden Befehl, den die Console ausführen darf, mit Schlüsselwörtern und Wertequellen; daraus entstehen die Vervollständigung in `oconsole`, die Man-Pages und die [Befehlsreferenz](/de/docs/commands/) |
| Backup-Inhalte durchsuchen | BVFS (`.bvfs_*`) mit Cache-Tabellen | BVFS unverändert, dazu OVFS (`.ovfs_*`): eine PostgreSQL-Erweiterung; ohne sie rechnet der Director dasselbe Ergebnis selbst aus |
| Dienstsuche im Netz | — | meldet sich per mDNS/DNS-SD (`_onesimus-dir._tcp`), darüber findet die Oberfläche Directors |
| [KI-Assistenten](/de/docs/install/mcp/) | — | `oconsole --mcp` stellt den Director als MCP-Werkzeuge bereit; der Assistent ist eine eigene Console (`<name>-mcp`, Profil `assistant`: lesen und Konfiguration); ACL-Änderungen und direktes SQL verweigert ihm der Director immer, und kein Werkzeug liefert Backup-Inhalte |

## Wo sich Onesimus bewusst anders verhält

Das sind Entscheidungen, keine Lücken. Jede lässt die Konfiguration für `bareos-dir` lesbar; es gibt
keine zusätzlichen Direktiven in `bareos-dir.d`, die den Rückweg versperren würden.

| Thema | Bareos Director 25 | Onesimus Director |
|---|---|---|
| Prozessmodell | ein Thread je Job | ein Prozess je Job, der mit einem Daemon spricht: ein abstürzender Job reißt den Director nicht mit |
| Jüngstes Backup eines Clients | nur bei `prune jobs`/AutoPrune geschützt, nur für konfigurierte Jobs | die jüngste erfolgreiche Full-Kette jedes Clients und FileSets wird nie gepruned oder gepurgt, die Volumes mit ihr werden nicht recycelt, `truncate`d oder gelöscht |
| Warten auf ein Volume ohne `Max Wait Time` | unbegrenzt | 600 s, danach wird der Job abgebrochen; ändern mit `ONESIMUS_DEFAULT_MEDIA_WAIT` oder `Max Wait Time` |
| Gescheiterter Batch-Insert der File-Zeilen | Job endet mit `T`, Dateien fehlen im Katalog | Job endet mit einem fatalen Fehler: keine still fehlenden Dateien im Restore-Baum |
| Purge von Jobs und Dateien | ohne Transaktion, Fehler werden ignoriert | eine Transaktion, Fehler werden gemeldet |
| Geheimnisse in Befehlszeilen | RunScript-Befehle stehen vollständig im Job-Log und in `show` | Passwörter, Tokens und Zugangsdaten in URLs werden in jeder Meldung und in `show` durch `***` ersetzt |
| `configure add console` | legt eine Console mit beliebigen ACL-Direktiven an | nur mit Profilen, die nicht mehr erlauben als die anlegende Console hat; `configure add profile/user` wird abgelehnt |
| Katalog-Schema | nur Bareos-Tabellen | die Bareos-Tabellen in `public` bleiben unberührt; Onesimus-Views, -Funktionen und die Tabelle der Katalog-ACL liegen im eigenen Schema `onesimus`, das ein Bareos-Schema-Upgrade nie blockiert; nur die Versionstabelle `bareos_schema_version` von odir bleibt in `public` |

## Was Bareos hat und Onesimus noch nicht

| Bereich | Bareos | Onesimus heute |
|---|---|---|
| Gerätearten des Storage Daemons | File, Band, Autochanger, FIFO, S3/Objektspeicher und mehr | `osd` schreibt nur auf **File**-Devices; Band und S3 sind geplant. `bareos-sd` funktioniert weiter mit `odir`. |
| Funktionen des Storage Daemons | Recycling, `relabel`, Spooling, Autochanger-Befehle, Kopie von SD zu SD | noch nicht in `osd` |
| NDMP | unterstützt | nicht unterstützt |
| Plugins | Director- und File-Daemon-Plugins, auch in Python | keine Director-Plugins und keine Python-Plugins; Plugins für den File Daemon entstehen als signierte Rust/WebAssembly-Komponenten |
| Pakete und Plattformen | offizielle Pakete für viele Distributionen, Clients für Windows und macOS | Debian-Pakete, aus den Quellen gebaut, für die Rust-Daemons; die Oberfläche läuft auf Linux, Windows und macOS |
| Reife und Support | viele Jahre im Produktionseinsatz, kommerzieller Support | junges Projekt, noch nicht so etabliert |

Fehlt etwas oder stimmt etwas nicht? Eröffne ein Issue auf
[GitHub](https://github.com/Onesimus-io/Onesimus/issues).
