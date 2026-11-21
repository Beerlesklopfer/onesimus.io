---
title: "Umstieg von Bareos (und zurück)"
description: "bareos-dir Schritt für Schritt durch odir ersetzen, mit derselben Konfiguration und demselben Katalog, und bei Bedarf zurückwechseln."
weight: 3
---

`odir` ist ein Drop-in-Ersatz für `bareos-dir` 25: dasselbe Konfigurationsverzeichnis, derselbe
PostgreSQL-Katalog, dieselben Clients und Storage Daemons, derselbe Konsolen-Port für `bconsole`. Der
Rückweg zu `bareos-dir` bleibt offen: Lass das Paket `bareos-director` installiert.

## Bevor du anfängst

- **Sichere den Katalog** (zum Beispiel mit `pg_dump`). `odir` legt Objekte in einem eigenen Schema
  `onesimus` an, prunt nach deiner Retention wie Bareos und schützt mehr als Bareos, aber eine
  Sicherung ist dein Netz.
- Wähle einen Zeitpunkt, an dem kein Job läuft.
- Sorge dafür, dass der Katalog-Benutzer das Schema `onesimus` anlegen darf (siehe
  [Der Katalog](../packages/#der-katalog)).

## Den Director wechseln

Die Installation des Pakets `odir` startet ihn sofort, und systemd stoppt `bareos-dir`.

```bash
# 1. Installieren: odir startet, bareos-dir stoppt
sudo dpkg -i odir_*.deb oconsole_*.deb

# 2. Prüfen, ob odir deine Konfiguration liest (ändert nichts)
sudo -u bareos /usr/sbin/odir -t -c /etc/bareos/bareos-dir.d; echo $?

# 3. Den Start im Journal ansehen
journalctl -u odir -b

# 4. Mit der Konsole sprechen, die du schon hast
echo "status director" | bconsole
```

Exit-Code 0 von `odir -t` heißt, die Konfiguration ist in Ordnung; 42 ist ein Konfigurationsfehler.
Beim ersten Start legt `odir` seine Schema-Objekte im Katalog an; im Journal steht
`applied N schema migration(s)` oder `schema up to date`.

Deine File Daemons und Storage Daemons ändern sich nicht: `odir` spricht mit `bareos-fd` und
`bareos-sd` über das klassische Protokoll.

## Was sich anders verhält

`odir` folgt Bareos genau, ein paar Entscheidungen weichen aber ab (Einzelheiten im
[Vergleich](/de/compare/)):

- Ein Job ohne `Max Wait Time` wartet **600 Sekunden** auf ein Volume, dann wird er abgebrochen.
  Bareos wartet unbegrenzt. Setze `ONESIMUS_DEFAULT_MEDIA_WAIT` oder `Max Wait Time` im Job.
- Die jüngste erfolgreiche Full-Kette jedes Clients und FileSets wird nie gepruned oder gepurgt, und
  die Volumes mit ihr werden nicht recycelt. Hat ein Pool nur noch solche Volumes, wartet ein Job auf
  ein Volume wie bei einem vollen Pool: Label ein neues Volume oder erhöhe `Maximum Volumes`.

## File Daemon und Storage Daemon ersetzen (optional)

- **`ofd`** ersetzt `bareos-fd` auf einem Client. Das Paket `ofd` **ersetzt das Paket
  `bareos-filedaemon`** und liest das vorhandene `/etc/bareos/bareos-fd.d`. Es spricht gRPC mit TLS
  zu `odir`, wenn die Client-Ressource des Directors `Grpc Enable = yes` hat, sonst das klassische
  Protokoll.
- **`osd`** ersetzt `bareos-sd` und liest das vorhandene `/etc/bareos/bareos-sd.d`. Das Paket
  installiert den Dienst, ohne ihn zu aktivieren. Stoppe zuerst den Storage Daemon von Bareos, dann
  starte `osd`:

  ```bash
  sudo systemctl disable --now bareos-storage
  sudo systemctl enable --now osd
  ```

  `osd` schreibt nur auf File-Devices; nutzt du Band oder andere Gerätearten, behalte `bareos-sd`.

## Zurück zu Bareos

1. Entferne die Onesimus-eigenen Direktiven aus `/etc/bareos/bareos-dir.d`, falls du welche
   eingetragen hast:
   - in der Director-Ressource: `gRPC Port`, `gRPC TLS Certificate`, `gRPC TLS Key`,
     `mDNS Advertise`;
   - in Client- und Storage-Ressourcen: `Grpc Enable`, `Grpc Port`, `Grpc CA Certificate File`,
     `Grpc Server Name`.

   `bareos-dir` kennt sie nicht und würde nicht starten.
2. Prüfe die Konfiguration mit Bareos: `sudo -u bareos bareos-dir -t`.
3. Starte Bareos; systemd stoppt `odir`:

   ```bash
   sudo systemctl disable --now odir
   sudo systemctl enable --now bareos-director
   ```

Der Katalog bleibt für `bareos-dir` benutzbar: Die Bareos-Tabellen und die Bareos-Schemaversion sind
unverändert, die Onesimus-Objekte liegen im Schema `onesimus` und stören nicht. Was dir fehlt, solange
`bareos-dir` läuft: Die mit `.acl` gesetzten Katalog-ACLs gelten nicht (die Einträge bleiben im
Katalog), und die Oberfläche nutzt das klassische Protokoll.

Für einen File Daemon installierst du das Paket `bareos-filedaemon` wieder (es ersetzt `ofd`). Für
einen Storage Daemon: `systemctl disable --now osd`, dann `systemctl enable --now bareos-storage`.
