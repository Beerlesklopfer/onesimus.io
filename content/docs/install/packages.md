---
title: "Packages, directories and services"
description: "Build the Debian packages of odir, ofd, osd and oconsole; where they keep their configuration; how the systemd units behave."
weight: 2
---

The Rust stack lives in the repository
[onesimus-director](https://github.com/Beerlesklopfer/onesimus-director). There is no public package
repository yet: you build the Debian packages yourself with
[cargo-deb](https://crates.io/crates/cargo-deb) and install them with `dpkg -i`.

## Build the packages

```bash
git clone https://github.com/Beerlesklopfer/onesimus-director.git
cd onesimus-director
cargo build --release -p odir -p ofd -p oconsole \
    --no-default-features --features oconsole/mcp-production
for p in odir ofd oconsole; do cargo deb -p $p --no-build; done
cargo build --release -p osd-daemon && cargo deb -p osd-daemon --no-build
ls target/debian/
```

The `mcp-production` feature builds `oconsole` with the production MCP policy (the assistant's
restricted rights, read-only over HTTP); the Debian packages always use it.

## The packages

| Package | Program | Service | After installation |
|---|---|---|---|
| `odir` | `/usr/sbin/odir` | `odir.service` | enabled and started |
| `ofd` | `/usr/sbin/ofd` | `ofd.service` (alias `bareos-fd.service`) | enabled and started; **replaces the package `bareos-filedaemon`** |
| `osd` | `/usr/sbin/osd` | `osd.service` (alias `bareos-storage.service`) | installed, but neither enabled nor started |
| `oconsole` | `/usr/bin/oconsole` | — | — |

`odir` and `bareos-director` can be installed side by side. Because installing `odir` starts it,
and `odir.service` conflicts with `bareos-director.service`, **installing `odir` stops a running
`bareos-dir`**. Read [Migrating from Bareos](../migrate-from-bareos/) before you install it on a
machine that runs Bareos.

## Directories

The packages use the Bareos layout, so Onesimus and Bareos daemons read the same files.

| Path | Used by | Content |
|---|---|---|
| `/etc/bareos/bareos-dir.d/` | `odir` | Director configuration, one file per resource as in Bareos |
| `/etc/bareos/bareos-fd.d/` | `ofd` | file daemon configuration |
| `/etc/bareos/bareos-sd.d/` | `osd` | storage daemon configuration |
| `/etc/bareos/osd.d/` | `osd` | optional Onesimus additions to resources of `bareos-sd.d` (same layout, same names) |
| `/etc/bareos/oconsole.conf` | `oconsole` | console configuration; without it `oconsole` reads `/etc/bareos/bconsole.conf` |
| `/var/lib/bareos/` | all daemons | working directory; also the self-signed gRPC certificates |
| `/var/lib/bareos/storage/` | `osd` | directory the `osd` package creates for File volumes |
| `/var/log/bareos/` | all daemons | logs |
| `~/.config/oconsole/known_directors` | `oconsole --grpc` | trusted Director certificates |

An existing configuration is never overwritten. Only when a directory has no `.conf` files does the
package copy a default configuration and generate random passwords. All daemons run as the user
`bareos`, except `ofd`, which runs as `root` (group `bareos`) to read every file.

## systemd units

The units copy the behaviour of the Bareos units:

- A configuration error (exit code 42) or wrong arguments (41) are **not** restarted. Other failures
  are restarted after 30 seconds, at most 10 times a day (`systemctl reset-failed odir` resets the
  count).
- `systemctl reload odir` first checks the configuration with `odir -t` and only then sends SIGHUP:
  a broken configuration is not loaded.
- `odir.service` has `Conflicts=bareos-director.service` and `osd.service` has
  `Conflicts=bareos-sd.service`: starting one stops the other.

Check the configuration before a restart (reads the catalog, changes nothing):

```bash
sudo -u bareos /usr/sbin/odir -t -c /etc/bareos/bareos-dir.d; echo $?
```

## Settings outside the configuration

`odir` has no directives that `bareos-dir` does not know, so the configuration stays readable by
Bareos. Its own settings are environment variables, set with a drop-in (`systemctl edit odir`):

| Variable | Effect | Default |
|---|---|---|
| `ONESIMUS_DEFAULT_MEDIA_WAIT` | seconds a job without `Max Wait Time` waits for a volume before it is cancelled | 600 |
| `PGTZ` | time zone of the catalog session | server setting |
| `RUST_LOG` | log filter | `info` |

```ini
# systemctl edit odir
[Service]
Environment=ONESIMUS_DEFAULT_MEDIA_WAIT=3600
```

`ONESIMUS_DEFAULT_MEDIA_WAIT` is read at start: use `systemctl restart odir`, not `reload`.

## The catalog

`odir` uses the Bareos PostgreSQL catalog. At start it adds its own objects (views, functions and
the table of the catalog ACLs) in a separate PostgreSQL schema `onesimus`; the Bareos tables in
`public` and the Bareos schema version stay as they are, so `bareos-dir` keeps opening the catalog.
For this the catalog user needs the right to create a schema:

```sql
GRANT CREATE ON DATABASE bareos TO bareos;
-- or, as superuser in the database bareos:
CREATE SCHEMA onesimus AUTHORIZATION bareos;
```

Without that right `odir` still runs, without catalog ACLs, and tries again at the next start.
Use the database and user names of your Catalog resource.
