---
title: "Storage daemon on a NAS"
description: "Run osd on the machine that holds the disks: build, configuration, Director side, limits."
weight: 5
---

The storage daemon belongs on the machine with the disks. `osd` is a single program, and for old
32-bit machines it can be built as a static binary, so it also runs on a small NAS that runs Linux. It writes volumes
in the Bareos format, which `bls` and `bareos-sd` can read.

<div class="note">

There are **no packages for NAS operating systems** (vendor app stores and the like). You need a Linux
on the NAS on which you can run your own program and service: a Debian-based system can take the
`osd` Debian package; otherwise you copy the program and write a service for your init system.

</div>

## What osd can do today

- Backup, restore and verify on **File** devices, also across several volumes.
- Active and passive clients; `ofd` and `odir` over gRPC with TLS, `bareos-fd` and `bareos-dir` over
  the classic protocol.
- Not yet: tape, autochangers, S3, spooling, recycling and `relabel` of volumes. A device serves one
  job at a time, reading or writing; a second job that wants a busy device fails instead of waiting
  as in `bareos-sd`. For parallel jobs, configure several devices.

## Build

On a 64-bit x86 NAS with Debian, build the normal package (see
[Packages, directories and services](../packages/)) and install it with `dpkg -i`.

For an old NAS with a **32-bit x86** CPU and kernel, the repository has a script that builds `osd` as
a static i686 program (musl, OpenSSL linked in) plus an i386 Debian package:

```bash
rustup target add i686-unknown-linux-musl
python3 -m venv ~/.local/zigenv && ~/.local/zigenv/bin/pip install ziglang cargo-zigbuild
cargo install cargo-deb
ZIGENV=~/.local/zigenv scripts/build-osd-i686.sh
```

The static program runs regardless of the C library of the NAS system. Other CPU architectures are not
built or tested yet.

## Configure osd

`osd` reads the Bareos layout under `/etc/bareos/bareos-sd.d`. An existing configuration of a
`bareos-sd` works unchanged. A minimal File device:

```text
# /etc/bareos/bareos-sd.d/device/NasFile.conf
Device {
  Name = NasFile
  Media Type = NasFile
  Archive Device = /srv/backup/bareos     # a directory on the NAS disks, owned by bareos
  Label Media = yes
  Random Access = yes
  Automatic Mount = yes
  Removable Media = no
  Always Open = no
}
```

The Director resource in `bareos-sd.d/director/` holds the name and password of the Director that may
use this storage daemon, as with `bareos-sd`.

Check and start:

```bash
osd -t -c /etc/bareos/bareos-sd.d          # check the configuration, exit code 0 or 1
sudo systemctl enable --now osd            # with the Debian package
```

Without systemd, run `osd -f -c /etc/bareos/bareos-sd.d` from your init system: `osd` stays in the
foreground and does not write a PID file itself.

## The Director side

Add a Storage resource to the Director configuration with the NAS address, the password from
`bareos-sd.d/director/`, and the same device name and media type:

```text
Storage {
  Name = nas
  Address = nas.example.org
  SD Port = 9103
  Password = "<password from the NAS>"
  Device = NasFile
  Media Type = NasFile
}
```

With `odir` the control and data connections can run over gRPC with TLS. `osd` listens on the storage
port + 1000 (default **10103**) and creates a self-signed certificate `onesimus-sd-grpc.crt` in its
working directory at the first start. Copy that certificate to the Director and add to the Storage
resource:

```text
  Grpc Enable = yes
  Grpc CA Certificate File = /etc/bareos/tls/nas-osd.crt
  Grpc Server Name = nas.example.org      # default: Address
```

If gRPC fails, `odir` writes the reason to its log and uses the classic protocol. These directives
are Onesimus-only; `bareos-dir` does not accept them.

## Tips for small machines

- **Memory:** every running job uses a ring buffer in `/dev/shm`, by default 8 slots of 1 MiB
  (8 MiB per job). `Ring Slots` in `/etc/bareos/osd.d/` changes the number of slots per storage or
  device:

  ```text
  # /etc/bareos/osd.d/device/NasFile.conf
  Device {
    Name = NasFile
    Ring Slots = 4
  }
  ```

- **Systems that run from RAM:** keep the working directory (with the gRPC certificate) and the
  configuration on persistent storage. A new certificate at every boot changes its fingerprint, and
  the Director stops trusting it.
- **Firewall:** open TCP 9103 and 10103 from the Director and the clients to the NAS.
