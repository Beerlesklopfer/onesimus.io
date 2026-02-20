---
title: "Getting Started"
description: "Install and run Onesimus on your platform in under 5 minutes."
weight: 1
---

## Prerequisites

Onesimus requires **Qt 6.8+**, **CMake 3.16+**, and a C++17 compiler. OpenSSL is included as a static submodule — no separate installation needed.

## Linux

Install dependencies and build:

```bash
sudo apt-get install build-essential cmake git qt6-base-dev qt6-tools-dev qt6-tools-dev-tools perl
git clone https://github.com/Beerlesklopfer/Onesimus.git
cd Onesimus
./build.sh
```

The binary will be in `build/onesimus`.

## Windows

Requires **Visual Studio 2022** with C++ Desktop Development workload:

```powershell
git clone https://github.com/Beerlesklopfer/Onesimus.git
cd Onesimus
.\build-windows.ps1
```

## macOS

```bash
brew install qt@6 cmake
git clone https://github.com/Beerlesklopfer/Onesimus.git
cd Onesimus
./build.sh
```

## First Connection

1. Launch Onesimus
2. The **Connection Wizard** will start automatically
3. Enter your Bareos Director address and credentials
4. Choose TLS-PSK or Certificate authentication
5. Save the connection profile

You're ready to manage your backups.

## Build Options

| Option | Description |
|--------|-------------|
| `-t Debug` | Debug build with symbols |
| `-s` | Use system OpenSSL instead of static |
| `-c` | Clean rebuild |
| `-j4` | Parallel build with 4 jobs |

See the full build documentation on [GitHub](https://github.com/Beerlesklopfer/Onesimus).
