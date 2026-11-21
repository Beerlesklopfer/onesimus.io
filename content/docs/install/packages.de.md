---
title: "Pakete, Verzeichnisse und Dienste"
description: "Die Debian-Pakete von odir, ofd, osd und oconsole bauen; wo sie ihre Konfiguration haben; wie sich die systemd-Units verhalten."
weight: 2
---

Der Rust-Stack liegt im Repository
[onesimus-director](https://github.com/Beerlesklopfer/onesimus-director). Ein öffentliches
Paket-Repository gibt es noch nicht: Du baust die Debian-Pakete selbst mit
[cargo-deb](https://crates.io/crates/cargo-deb) und installierst sie mit `dpkg -i`.

## Pakete bauen

```bash
git clone https://github.com/Beerlesklopfer/onesimus-director.git
cd onesimus-director
cargo build --release -p odir -p ofd -p oconsole \
    --no-default-features --features oconsole/mcp-production
for p in odir ofd oconsole; do cargo deb -p $p --no-build; done
cargo build --release -p osd-daemon && cargo deb -p osd-daemon --no-build
ls target/debian/
```

Das Feature `mcp-production` baut `oconsole` mit der Produktions-Richtlinie für MCP (eingeschränkte
Rechte des Assistenten, über HTTP nur lesend); die Debian-Pakete nutzen es immer.

## Die Pakete

| Paket | Programm | Dienst | Nach der Installation |
|---|---|---|---|
| `odir` | `/usr/sbin/odir` | `odir.service` | aktiviert und gestartet |
| `ofd` | `/usr/sbin/ofd` | `ofd.service` (Alias `bareos-fd.service`) | aktiviert und gestartet; **ersetzt das Paket `bareos-filedaemon`** |
| `osd` | `/usr/sbin/osd` | `osd.service` (Alias `bareos-storage.service`) | installiert, aber weder aktiviert noch gestartet |
| `oconsole` | `/usr/bin/oconsole` | — | — |

`odir` und `bareos-director` lassen sich nebeneinander installieren. Weil die Installation von `odir`
den Dienst startet und `odir.service` mit `bareos-director.service` in Konflikt steht, **stoppt die
Installation von `odir` einen laufenden `bareos-dir`**. Lies [Umstieg von Bareos](../migrate-from-bareos/),
bevor du ihn auf einem Rechner mit Bareos installierst.

## Verzeichnisse

Die Pakete nutzen die Verzeichnisse von Bareos, Onesimus- und Bareos-Daemons lesen also dieselben
Dateien.

| Pfad | Benutzt von | Inhalt |
|---|---|---|
| `/etc/bareos/bareos-dir.d/` | `odir` | Konfiguration des Directors, eine Datei je Ressource wie bei Bareos |
| `/etc/bareos/bareos-fd.d/` | `ofd` | Konfiguration des File Daemons |
| `/etc/bareos/bareos-sd.d/` | `osd` | Konfiguration des Storage Daemons |
| `/etc/bareos/osd.d/` | `osd` | optionale Onesimus-Ergänzungen zu Ressourcen aus `bareos-sd.d` (gleicher Aufbau, gleiche Namen) |
| `/etc/bareos/oconsole.conf` | `oconsole` | Konfiguration der Konsole; ohne sie liest `oconsole` `/etc/bareos/bconsole.conf` |
| `/var/lib/bareos/` | alle Daemons | Arbeitsverzeichnis; dort liegen auch die selbstsignierten gRPC-Zertifikate |
| `/var/lib/bareos/storage/` | `osd` | Verzeichnis, das das Paket `osd` für File-Volumes anlegt |
| `/var/log/onesimus/` | alle Daemons | Logs der Daemons, eine Datei je Daemon: `/var/log/onesimus/<daemon>.log` (`odir.log`, `ofd.log`, `osd.log`) |
| `/var/log/bareos/` | Messages-Ressourcen | nur das, was eine Messages-Ressource dort anhängt (`append = …`) |
| `~/.config/oconsole/known_directors` | `oconsole --grpc` | vertrauenswürdige Director-Zertifikate |

Eine vorhandene Konfiguration wird nie überschrieben. Nur wenn ein Verzeichnis keine `.conf`-Dateien
enthält, kopiert das Paket eine Vorgabe-Konfiguration und erzeugt zufällige Passwörter. Alle Daemons
laufen als Benutzer `bareos`, außer `ofd`, der als `root` (Gruppe `bareos`) läuft, damit er jede Datei
lesen kann.

## systemd-Units

Die Units übernehmen das Verhalten der Bareos-Units:

- Ein Konfigurationsfehler (Exit-Code 42) oder falsche Argumente (41) werden **nicht** neu gestartet.
  Andere Fehler werden nach 30 Sekunden neu gestartet, höchstens 10-mal am Tag
  (`systemctl reset-failed odir` setzt den Zähler zurück).
- `systemctl reload odir` prüft zuerst die Konfiguration mit `odir -t` und schickt erst dann SIGHUP:
  Eine kaputte Konfiguration wird nicht geladen.
- `odir.service` hat `Conflicts=bareos-director.service`: Startet der eine, stoppt der andere.
- Startet `osd`, stoppt `bareos-storage` (auch bekannt als `bareos-sd`), und umgekehrt; beide Pakete
  bleiben installierbar.

Konfiguration vor einem Neustart prüfen (liest den Katalog, ändert nichts):

```bash
sudo -u bareos /usr/sbin/odir -t -c /etc/bareos/bareos-dir.d; echo $?
```

## Einstellungen außerhalb der Konfiguration

`odir` versteht einige optionale Onesimus-Direktiven. Keine davon ist nötig, aber `bareos-dir` kennt sie
nicht: Entferne sie, bevor du zu `bareos-dir` zurückwechselst.

- Director-Ressource: `Grpc Port`, `Grpc TLS Certificate`, `Grpc TLS Key`, `mDNS Advertise`
- Client- und Storage-Ressourcen: `Grpc Enable`, `Grpc Port`, `Grpc CA Certificate File`, `Grpc Server Name`

Seine übrigen Einstellungen sind Umgebungsvariablen, gesetzt mit einem Drop-in (`systemctl edit odir`):

| Variable | Wirkung | Vorgabe |
|---|---|---|
| `ONESIMUS_DEFAULT_MEDIA_WAIT` | Sekunden, die ein Job ohne `Max Wait Time` auf ein Volume wartet, bevor er abgebrochen wird | 600 |
| `PGTZ` | Zeitzone der Katalogsitzung | Einstellung des Servers |
| `RUST_LOG` | Log-Filter | `info` |

```ini
# systemctl edit odir
[Service]
Environment=ONESIMUS_DEFAULT_MEDIA_WAIT=3600
```

`ONESIMUS_DEFAULT_MEDIA_WAIT` wird beim Start gelesen: `systemctl restart odir`, nicht `reload`.

## Der Katalog

`odir` nutzt den PostgreSQL-Katalog von Bareos. Beim Start legt er seine eigenen Objekte (Views,
Funktionen und die Tabelle der Katalog-ACLs) in einem eigenen PostgreSQL-Schema `onesimus` an; die
Bareos-Tabellen in `public` und die Bareos-Schemaversion bleiben, wie sie sind, `bareos-dir` öffnet den
Katalog also weiter. Nur seine Versionstabelle `bareos_schema_version` behält `odir` in `public`. Dafür braucht der Katalog-Benutzer das Recht, ein Schema anzulegen:

```sql
GRANT CREATE ON DATABASE bareos TO bareos;
-- oder als Superuser in der Datenbank bareos:
CREATE SCHEMA onesimus AUTHORIZATION bareos;
```

Ohne dieses Recht läuft `odir` trotzdem, ohne Katalog-ACLs, und versucht es beim nächsten Start
erneut. Nimm die Datenbank- und Benutzernamen aus deiner Catalog-Ressource.
