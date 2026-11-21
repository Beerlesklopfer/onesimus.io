---
title: "Oberfläche installieren"
description: "Die Onesimus-Oberfläche unter Linux, Windows oder macOS bauen und die erste Verbindung einrichten."
weight: 1
---

Die Oberfläche ist eine Qt6/C++17-Anwendung. Sie braucht **Qt 6.8 oder neuer**, **CMake 3.16 oder
neuer** und einen C++17-Compiler. OpenSSL wird aus einem Git-Submodul gebaut, außer du verlangst das
OpenSSL des Systems.

## Linux

```bash
sudo apt-get install build-essential cmake git perl imagemagick libssl-dev libxkbcommon-dev \
    qt6-base-dev qt6-base-private-dev qt6-tools-dev qt6-tools-dev-tools \
    qt6-grpc-dev   # Qt GRPC und Qt Protobuf, für die Verbindung zum Onesimus Director
git clone https://github.com/Beerlesklopfer/Onesimus.git
cd Onesimus
./build.sh
```

Das Programm liegt danach in `build/onesimus`. Paketnamen für Fedora, Arch und openSUSE stehen in
[BUILD_LINUX.md](https://github.com/Beerlesklopfer/Onesimus/blob/development/BUILD_LINUX.md).
`cpack -G DEB` im Build-Verzeichnis baut ein Debian-Paket.

## Windows

Installiere **Visual Studio 2022** mit der Arbeitslast „Desktopentwicklung mit C++“ und Qt 6, dann:

```powershell
git clone https://github.com/Beerlesklopfer/Onesimus.git
cd Onesimus
.\build-windows.ps1
```

Einzelheiten: [BUILD_WINDOWS.md](https://github.com/Beerlesklopfer/Onesimus/blob/development/BUILD_WINDOWS.md).

## macOS

```bash
brew install qt@6 cmake
git clone https://github.com/Beerlesklopfer/Onesimus.git
cd Onesimus
./build.sh
```

Einzelheiten: [BUILD_OSX.md](https://github.com/Beerlesklopfer/Onesimus/blob/development/BUILD_OSX.md).

## gRPC-Unterstützung

Die Verbindung zum Onesimus Director nutzt die gRPC-Module von Qt. CMake schaltet sie ein
(`ENABLE_GRPC=ON`), wenn es **Qt Protobuf**, **Qt Protobuf Well-Known Types** und **Qt GRPC** sowie
das Submodul `proto/` findet. Ohne sie baut die Oberfläche trotzdem und spricht mit Bareos Directors
über das klassische Protokoll; der Eintrag gRPC ist dann ausgegraut, und sein Tooltip sagt „This build of
Onesimus has no gRPC support“.

## Optionen von build.sh

| Option | Bedeutung |
|---|---|
| `-t Debug` | Debug-Build mit Symbolen |
| `-s` | OpenSSL des Systems statt des mitgelieferten |
| `-c` | sauber neu bauen |
| `-j4` | mit 4 parallelen Jobs bauen |

## Erste Verbindung

1. Starte Onesimus. Beim ersten Start öffnet sich der **Verbindungsassistent**.
2. Er sucht im lokalen Netz nach Onesimus Directors (mDNS). Wähle einen aus oder gib die Adresse
   selbst ein.
3. Wähle das Protokoll:
   - **gRPC (Onesimus Director)**: TLS auf dem BNET-Port + 1000 (Vorgabe 10101). Siehe
     [gRPC und TLS](../grpc-tls/).
   - **Klassisches Konsolenprotokoll** für einen Bareos Director: TLS-PSK oder Zertifikate, wie bei
     `bconsole`.
4. Gib Console-Namen und Passwort ein und speichere das Profil.
