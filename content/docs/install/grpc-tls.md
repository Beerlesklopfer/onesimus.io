---
title: "gRPC and TLS between GUI and Director"
description: "How the GUI connects to the Onesimus Director: port, certificate, fingerprint, login and firewall."
weight: 4
---

The Onesimus Director offers two interfaces at the same time:

- the **classic console port** (9101), for `bconsole`, `oconsole` and the GUI in Bareos mode;
- **gRPC with TLS** on the console port + 1000 (default **10101**), for the GUI and
  `oconsole --grpc`. It carries the typed API, configuration changes and the push events (live job
  log, job status).

gRPC is on by default and needs no directive in the configuration.

## The certificate

gRPC always uses TLS. If you do not give a certificate, `odir` creates a self-signed one at the first
start in its working directory (`/var/lib/bareos/onesimus-grpc.crt` and `.key`) and keeps it.
Clients **pin its SHA-256 fingerprint** on first use: the GUI shows the fingerprint and asks you to
confirm it, and warns if it does not match the fingerprint announced in the network.

Compare the fingerprint with the one on the server:

```bash
openssl x509 -in /var/lib/bareos/onesimus-grpc.crt -noout -fingerprint -sha256
```

To use your own certificate, give it to `odir` on the command line, with a systemd drop-in:

```ini
# systemctl edit odir
[Service]
ExecStart=
ExecStart=/usr/sbin/odir -c /etc/bareos/bareos-dir.d -f --grpc-cert /etc/bareos/tls/dir.crt --grpc-key /etc/bareos/tls/dir.key
```

The key must be readable by the user `bareos`. Other options: `--grpc-port <port>` and
`--disable-grpc` (classic port only).

## Logging in

The GUI logs in with a **console name and its password**, like `bconsole`: by challenge and response,
so the password itself is never sent. Every later call carries a session token. The console's ACLs
apply to everything the GUI does, including the push events: a console only receives events for jobs,
clients and storages it may see.

Failed logins are slowed down per source address and per console (from 1 second up to 5 minutes);
there is no permanent lock-out.

For the GUI, create a console of its own with a profile instead of using the Director password. On
the Onesimus Director you can do this from the GUI's ACL matrix, or on the console:

```text
configure add console name=gui-admin password=<secret> profile=<profile>
```

## Finding the Director

`odir` announces itself by mDNS/DNS-SD as `_onesimus-dir._tcp` with its gRPC port and certificate
fingerprint. The connection wizard of the GUI lists the Directors it finds. Check from a shell:

```bash
avahi-browse -rt _onesimus-dir._tcp
```

mDNS only works within the local network segment; across networks enter the address in the wizard.

## Firewall

Open TCP **10101** (or your gRPC port) from the workstations running the GUI to the Director, in
addition to 9101 if you still use `bconsole` remotely. Check on the Director:

```bash
ss -ltnp | grep -E '9101|10101'
```

## Daemons over gRPC

`ofd` and `osd` can also talk gRPC with TLS to `odir`, with the classic protocol as fallback. This is
switched on per Client or Storage resource in the Director's configuration (`Grpc Enable = yes`,
`Grpc Port`, `Grpc CA Certificate File`, `Grpc Server Name`). These directives are unknown to
`bareos-dir`: remove them before you switch back (see
[Migrating from Bareos](../migrate-from-bareos/#switching-back-to-bareos)).
