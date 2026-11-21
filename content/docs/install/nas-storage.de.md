---
title: "Storage Daemon auf einem NAS"
description: "osd auf dem Rechner mit den Platten betreiben: Bauen, Konfiguration, Director-Seite, Grenzen."
weight: 5
---

Der Storage Daemon gehört auf den Rechner mit den Platten. `osd` ist ein einzelnes Programm und lässt
sich für alte 32-Bit-Rechner als statisches Programm bauen; er läuft also auch auf einem kleinen NAS
mit Linux. Er schreibt Volumes im Bareos-Format, die `bls` und `bareos-sd` lesen können.

<div class="note">

Es gibt **keine Pakete für NAS-Betriebssysteme** (App-Stores der Hersteller und Ähnliches). Du
brauchst auf dem NAS ein Linux, auf dem du ein eigenes Programm und einen Dienst einrichten kannst:
Ein Debian-basiertes System nimmt das Debian-Paket `osd`; sonst kopierst du das Programm und schreibst
einen Dienst für dein Init-System.

</div>

## Was osd heute kann

- Backup, Restore und Verify auf **File**-Devices, auch über mehrere Volumes.
- Aktive und passive Clients; `ofd` und `odir` über gRPC mit TLS, `bareos-fd` und `bareos-dir` über
  das klassische Protokoll.
- Noch nicht: Band, Autochanger, S3, Spooling, Recycling und `relabel` von Volumes. Ein Job belegt
  ein Device; für parallele Jobs richtest du mehrere Devices ein.

## Bauen

Auf einem 64-Bit-x86-NAS mit Debian baust du das normale Paket (siehe
[Pakete, Verzeichnisse und Dienste](../packages/)) und installierst es mit `dpkg -i`.

Für ein altes NAS mit **32-Bit-x86**-CPU und -Kernel hat das Repository ein Skript, das `osd` als
statisches i686-Programm (musl, OpenSSL eingebunden) und dazu ein i386-Debian-Paket baut:

```bash
rustup target add i686-unknown-linux-musl
python3 -m venv ~/.local/zigenv && ~/.local/zigenv/bin/pip install ziglang cargo-zigbuild
cargo install cargo-deb
ZIGENV=~/.local/zigenv scripts/build-osd-i686.sh
```

Das statische Programm läuft unabhängig von der C-Bibliothek des NAS-Systems. Andere
CPU-Architekturen werden noch nicht gebaut oder getestet.

## osd einrichten

`osd` liest den Bareos-Aufbau unter `/etc/bareos/bareos-sd.d`. Die Konfiguration eines vorhandenen
`bareos-sd` funktioniert unverändert. Ein minimales File-Device:

```text
# /etc/bareos/bareos-sd.d/device/NasFile.conf
Device {
  Name = NasFile
  Media Type = NasFile
  Archive Device = /srv/backup/bareos     # ein Verzeichnis auf den NAS-Platten, Eigentümer bareos
  Label Media = yes
  Random Access = yes
  Automatic Mount = yes
  Removable Media = no
  Always Open = no
}
```

Die Director-Ressource in `bareos-sd.d/director/` enthält Name und Passwort des Directors, der diesen
Storage Daemon benutzen darf, wie bei `bareos-sd`.

Prüfen und starten:

```bash
osd -t -c /etc/bareos/bareos-sd.d          # Konfiguration prüfen, Exit-Code 0 oder 1
sudo systemctl enable --now osd            # mit dem Debian-Paket
```

Ohne systemd startest du `osd -f -c /etc/bareos/bareos-sd.d` aus deinem Init-System: `osd` bleibt im
Vordergrund und schreibt selbst keine PID-Datei.

## Die Director-Seite

Leg in der Konfiguration des Directors eine Storage-Ressource mit der Adresse des NAS, dem Passwort
aus `bareos-sd.d/director/` und demselben Device-Namen und Media Type an:

```text
Storage {
  Name = nas
  Address = nas.example.org
  SD Port = 9103
  Password = "<Passwort vom NAS>"
  Device = NasFile
  Media Type = NasFile
}
```

Mit `odir` können Steuer- und Datenverbindungen über gRPC mit TLS laufen. `osd` lauscht auf dem
Storage-Port + 1000 (Vorgabe **10103**) und erzeugt beim ersten Start ein selbstsigniertes Zertifikat
`onesimus-sd-grpc.crt` in seinem Arbeitsverzeichnis. Kopiere dieses Zertifikat auf den Director und
ergänze die Storage-Ressource:

```text
  Grpc Enable = yes
  Grpc CA Certificate File = /etc/bareos/tls/nas-osd.crt
  Grpc Server Name = nas.example.org      # Vorgabe: Address
```

Scheitert gRPC, schreibt `odir` den Grund ins Log und nimmt das klassische Protokoll. Diese
Direktiven gibt es nur bei Onesimus; `bareos-dir` nimmt sie nicht an.

## Tipps für kleine Rechner

- **Speicher:** Jeder laufende Job belegt einen Ringpuffer in `/dev/shm`, ab Werk 8 Fächer zu 1 MiB
  (8 MiB je Job). `Ring Slots` in `/etc/bareos/osd.d/` ändert die Zahl der Fächer je Storage oder
  Device:

  ```text
  # /etc/bareos/osd.d/device/NasFile.conf
  Device {
    Name = NasFile
    Ring Slots = 4
  }
  ```

- **Systeme, die aus dem RAM laufen:** Halte das Arbeitsverzeichnis (mit dem gRPC-Zertifikat) und die
  Konfiguration auf dauerhaftem Speicher. Ein neues Zertifikat bei jedem Start ändert seinen
  Fingerabdruck, und der Director vertraut ihm nicht mehr.
- **Firewall:** Öffne TCP 9103 und 10103 vom Director und von den Clients zum NAS.
