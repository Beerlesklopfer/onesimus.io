---
title: "gRPC und TLS zwischen Oberfläche und Director"
description: "Wie sich die Oberfläche mit dem Onesimus Director verbindet: Port, Zertifikat, Fingerabdruck, Anmeldung und Firewall."
weight: 4
---

Der Onesimus Director bietet zwei Schnittstellen gleichzeitig an:

- den **klassischen Konsolen-Port** (9101) für `bconsole`, `oconsole` und die Oberfläche im
  Bareos-Modus;
- **gRPC mit TLS** auf dem Konsolen-Port + 1000 (Vorgabe **10101**) für die Oberfläche und
  `oconsole --grpc`. Darüber laufen die typisierte API, Konfigurationsänderungen und die
  Push-Ereignisse (Live-Job-Log, Job-Status).

gRPC ist ab Werk eingeschaltet und braucht keine Direktive in der Konfiguration.

## Das Zertifikat

gRPC nutzt immer TLS. Gibst du kein Zertifikat an, erzeugt `odir` beim ersten Start ein
selbstsigniertes in seinem Arbeitsverzeichnis (`/var/lib/bareos/onesimus-grpc.crt` und `.key`) und
behält es. Clients **merken sich beim ersten Kontakt seinen SHA-256-Fingerabdruck**: Die Oberfläche
zeigt den Fingerabdruck und lässt ihn dich bestätigen, und sie warnt, wenn er nicht zu dem im Netz
angekündigten passt.

Vergleiche den Fingerabdruck mit dem auf dem Server:

```bash
openssl x509 -in /var/lib/bareos/onesimus-grpc.crt -noout -fingerprint -sha256
```

Ein eigenes Zertifikat gibst du `odir` auf der Kommandozeile mit, über ein systemd-Drop-in:

```ini
# systemctl edit odir
[Service]
ExecStart=
ExecStart=/usr/sbin/odir -c /etc/bareos/bareos-dir.d -f --grpc-cert /etc/bareos/tls/dir.crt --grpc-key /etc/bareos/tls/dir.key
```

Der Schlüssel muss für den Benutzer `bareos` lesbar sein. Weitere Optionen: `--grpc-port <port>` und
`--disable-grpc` (nur der klassische Port).

## Anmeldung

Die Oberfläche meldet sich mit **Console-Namen und Passwort** an, wie `bconsole`: per Challenge und
Response, das Passwort selbst wird nie übertragen. Jeder weitere Aufruf trägt ein Sitzungs-Token. Die
ACLs der Console gelten für alles, was die Oberfläche tut, auch für die Push-Ereignisse: Eine Console
bekommt nur Ereignisse zu Jobs, Clients und Storages, die sie sehen darf.

Fehlgeschlagene Anmeldungen werden je Quelladresse und je Console gebremst (von 1 Sekunde bis zu
5 Minuten); eine dauerhafte Sperre gibt es nicht.

Leg für die Oberfläche eine eigene Console mit Profil an, statt das Director-Passwort zu benutzen. Am
Onesimus Director geht das in der ACL-Matrix der Oberfläche oder auf der Konsole:

```text
configure add console name=gui-admin password=<geheim> profile=<profil>
```

## Den Director finden

`odir` meldet sich per mDNS/DNS-SD als `_onesimus-dir._tcp` mit seinem gRPC-Port und dem
Fingerabdruck des Zertifikats. Der Verbindungsassistent der Oberfläche listet die gefundenen
Directors. Prüfen in der Shell:

```bash
avahi-browse -rt _onesimus-dir._tcp
```

mDNS funktioniert nur im lokalen Netzsegment; über Netzgrenzen hinweg gibst du die Adresse im
Assistenten ein.

## Firewall

Öffne TCP **10101** (oder deinen gRPC-Port) von den Arbeitsplätzen mit der Oberfläche zum Director,
dazu 9101, wenn du `bconsole` weiter aus der Ferne nutzt. Prüfen auf dem Director:

```bash
ss -ltnp | grep -E '9101|10101'
```

## Daemons über gRPC

Auch `ofd` und `osd` können gRPC mit TLS zu `odir` sprechen, mit dem klassischen Protokoll als
Rückfall. Das schaltest du je Client- oder Storage-Ressource in der Konfiguration des Directors ein
(`Grpc Enable = yes`, `Grpc Port`, `Grpc CA Certificate File`, `Grpc Server Name`). `bareos-dir`
kennt diese Direktiven nicht: Entferne sie, bevor du zurückwechselst (siehe
[Umstieg von Bareos](../migrate-from-bareos/#zurück-zu-bareos)).
