---
title: "Migrating from Bareos (and back)"
description: "Replace bareos-dir with odir on the same configuration and catalog, step by step, and switch back if you need to."
weight: 3
---

`odir` is a drop-in replacement for `bareos-dir` 25: same configuration directory, same PostgreSQL
catalog, same clients and storage daemons, same console port for `bconsole`. The way back to
`bareos-dir` stays open: keep the package `bareos-director` installed.

## Before you start

- **Back up the catalog** (for example with `pg_dump`). `odir` adds objects in its own schema
  `onesimus`, prunes according to your retention like Bareos, and protects more than Bareos does,
  but a backup is your safety net.
- Pick a moment when no job is running.
- Make sure the catalog user may create the schema `onesimus` (see
  [The catalog](../packages/#the-catalog)).

## Switch the Director

Installing the package `odir` starts it right away, and systemd stops `bareos-dir`.

```bash
# 1. Install: odir starts, bareos-dir stops
sudo dpkg -i odir_*.deb oconsole_*.deb

# 2. Check that odir reads your configuration (changes nothing)
sudo -u bareos /usr/sbin/odir -t -c /etc/bareos/bareos-dir.d; echo $?

# 3. Look at the start in the journal
journalctl -u odir -b

# 4. Talk to it with the console you already have
echo "status director" | bconsole
```

Exit code 0 of `odir -t` means the configuration is fine; 42 is a configuration error. At the first
start `odir` creates its schema objects in the catalog; the journal says
`applied N schema migration(s)` or `schema up to date`.

Your file daemons and storage daemons do not change: `odir` talks to `bareos-fd` and `bareos-sd` over
the classic protocol.

## Things that behave differently

`odir` follows Bareos closely, but a few decisions differ (details on the
[comparison page](/compare/)):

- A job without `Max Wait Time` waits **600 seconds** for a volume, then it is cancelled. Bareos
  waits forever. Set `ONESIMUS_DEFAULT_MEDIA_WAIT` or `Max Wait Time` in the job.
- The latest successful Full chain of every client and FileSet is never pruned or purged, and the
  volumes that hold it are not recycled. If a pool only has such volumes, a job waits for a volume as
  with a full pool: label a new volume or raise `Maximum Volumes`.

## Replace the file daemon and storage daemon (optional)

- **`ofd`** replaces `bareos-fd` on a client. The package `ofd` **replaces the package
  `bareos-filedaemon`** and reads the existing `/etc/bareos/bareos-fd.d`. It talks gRPC with TLS to
  `odir` when the Director's Client resource has `Grpc Enable = yes`, and falls back to the classic
  protocol otherwise.
- **`osd`** replaces `bareos-sd` and reads the existing `/etc/bareos/bareos-sd.d`. The package
  installs the service without enabling it. Stop the Bareos storage daemon first, then start `osd`:

  ```bash
  sudo systemctl disable --now bareos-storage
  sudo systemctl enable --now osd
  ```

  `osd` writes to File devices only; if you use tape or other device types, keep `bareos-sd`.

## Switching back to Bareos

1. Remove the Onesimus-only directives from `/etc/bareos/bareos-dir.d`, if you added any:
   - in the Director resource: `gRPC Port`, `gRPC TLS Certificate`, `gRPC TLS Key`,
     `mDNS Advertise`;
   - in Client and Storage resources: `Grpc Enable`, `Grpc Port`, `Grpc CA Certificate File`,
     `Grpc Server Name`.

   `bareos-dir` does not know them and would refuse to start.
2. Check the configuration with Bareos: `sudo -u bareos bareos-dir -t`.
3. Start Bareos; systemd stops `odir`:

   ```bash
   sudo systemctl disable --now odir
   sudo systemctl enable --now bareos-director
   ```

The catalog stays usable for `bareos-dir`: the Bareos tables and the Bareos schema version are
unchanged, the Onesimus objects sit in the schema `onesimus` and do not disturb it. What you lose
while `bareos-dir` runs: the catalog ACLs set with `.acl` are not applied (the entries stay in the
catalog), and the GUI falls back to the classic protocol.

For a file daemon, install the package `bareos-filedaemon` again (it replaces `ofd`). For a storage
daemon, `systemctl disable --now osd`, then `systemctl enable --now bareos-storage`.
