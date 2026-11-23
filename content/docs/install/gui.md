---
title: "Install the GUI"
description: "Build the Onesimus GUI on Linux, Windows or macOS and make the first connection."
weight: 1
---

The GUI is a Qt6/C++17 application. It needs **Qt 6.8 or newer**, **CMake 3.16 or newer** and a
C++17 compiler. OpenSSL is built from a Git submodule unless you ask for the system OpenSSL.

## Linux

```bash
sudo apt-get install build-essential cmake git perl imagemagick libssl-dev libxkbcommon-dev \
    qt6-base-dev qt6-base-private-dev qt6-tools-dev qt6-tools-dev-tools \
    qt6-grpc-dev   # Qt GRPC and Qt Protobuf, for the connection to the Onesimus Director
git clone https://github.com/Onesimus-io/Onesimus.git
cd Onesimus
./build.sh
```

The program is `build/onesimus`. Package names for Fedora, Arch and openSUSE are in
[BUILD_LINUX.md](https://github.com/Onesimus-io/Onesimus/blob/development/BUILD_LINUX.md).
`cpack -G DEB` in the build directory makes a Debian package.

## Windows

Install **Visual Studio 2022** with the workload "Desktop development with C++" and Qt 6, then:

```powershell
git clone https://github.com/Onesimus-io/Onesimus.git
cd Onesimus
.\build-windows.ps1
```

Details: [BUILD_WINDOWS.md](https://github.com/Onesimus-io/Onesimus/blob/development/BUILD_WINDOWS.md).

## macOS

```bash
brew install qt@6 cmake
git clone https://github.com/Onesimus-io/Onesimus.git
cd Onesimus
./build.sh
```

Details: [BUILD_OSX.md](https://github.com/Onesimus-io/Onesimus/blob/development/BUILD_OSX.md).

## gRPC support

The connection to the Onesimus Director uses Qt's gRPC modules. CMake turns it on
(`ENABLE_GRPC=ON`) when it finds **Qt Protobuf**, **Qt Protobuf Well-Known Types** and **Qt GRPC**
and the `proto/` submodule. Without them the GUI still builds and talks to Bareos Directors over the
classic protocol; the gRPC entry is then greyed out, and its tool tip says "This build of Onesimus has no
gRPC support".

## Build options of build.sh

| Option | Meaning |
|---|---|
| `-t Debug` | debug build with symbols |
| `-s` | use the system OpenSSL instead of the bundled one |
| `-c` | clean rebuild |
| `-j4` | build with 4 parallel jobs |

## First connection

1. Start Onesimus. The **connection wizard** opens on the first start.
2. It searches the local network for Onesimus Directors (mDNS). Pick one, or enter the address
   yourself.
3. Choose the protocol:
   - **gRPC (Onesimus Director)**: TLS on the BNET port + 1000 (default 10101). See
     [gRPC and TLS](../grpc-tls/).
   - **Classic console protocol** for a Bareos Director: TLS-PSK or certificates, as with `bconsole`.
4. Enter the console name and password, and save the profile.
