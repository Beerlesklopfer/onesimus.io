---
title: "Onesimus vs. Bareos"
description: "What the Onesimus Director adds to Bareos, where it behaves differently on purpose, and what Bareos can do that Onesimus cannot do yet."
---

Onesimus grew out of Bareos and stays compatible with it: the Onesimus Director `odir` reads the
Bareos 25 configuration, uses the Bareos PostgreSQL catalog and speaks the Bareos protocols to
`bconsole`, file daemons and storage daemons. This page lists only differences that can be checked
in the source code. Where Bareos is ahead, it says so.

<div class="note">

**Status:** Onesimus is not yet as established as Bareos. Bareos is a mature project with many years of production
use and commercial support. If you need something from the last section of this page, stay with
Bareos, or keep `bareos-dir` installed as your way back (see
[Migrating from Bareos](/docs/install/migrate-from-bareos/)).

</div>

## What the Onesimus Director adds

| Feature | Bareos Director 25 | Onesimus Director |
|---|---|---|
| Change and delete resources from the console | `configure` knows `add` and `export` | adds `configure update` (change directives), `configure delete` (only unreferenced resources) and `configure read` (raw text of a resource) |
| API for programs | console protocol; JSON output with `.api 2` | additionally a typed gRPC API with TLS: one RPC per command with structured Protobuf answers, the same ACLs as the console |
| Live events | job messages are read by polling (`messages`, `list joblog`) | gRPC push events: job status, job messages, file and storage daemon connects, each filtered by the console's ACLs |
| Live job log in the GUI | — | yes, from the push events (the GUI polls when it talks to Bareos) |
| ACLs per console without editing files | ACLs live in the configuration files | catalog ACLs per console with `.acl list/set/delete/clear/copy`; the effective right is file ACL **and** catalog ACL, and a console can only narrow its own rights |
| Purge many volumes at once | no command; `purge volume pool=…` opens a selection | `purge volume all pool=<p>\|allpools [volstatus=…] dryrun\|yes`: `dryrun` previews and changes nothing, `yes` purges each volume with the same checks as a single `purge volume` |
| Console grammar | — (`.help`) | `.grammar` returns every command the console may run with its keywords and value sources; it drives completion in `oconsole`, the man pages and the [command reference](/docs/commands/) |
| Browsing backup contents | BVFS (`.bvfs_*`) with cache tables | BVFS unchanged, plus OVFS (`.ovfs_*`): a PostgreSQL extension; without it the Director computes the same result itself |
| Service discovery | — | announces itself via mDNS/DNS-SD (`_onesimus-dir._tcp`), which the GUI uses to find Directors |
| AI assistants | — | `oconsole --mcp` serves the Director as MCP tools; the assistant is a console of its own with restricted rights (by default read and configuration, no ACLs) and cannot read backup contents |

## Where Onesimus behaves differently on purpose

These are decisions, not gaps. Each keeps the configuration readable by `bareos-dir`; there are no
extra directives in `bareos-dir.d` that would block the way back.

| Topic | Bareos Director 25 | Onesimus Director |
|---|---|---|
| Process model | one thread per job | one process per job that talks to a daemon: a crashing job does not take the Director down |
| Latest backup of a client | protected only by `prune jobs`/AutoPrune, only for configured jobs | the latest successful Full chain of every client and FileSet is never pruned or purged, and the volumes holding it are not recycled, truncated or deleted |
| Waiting for a volume without `Max Wait Time` | waits forever | 600 s, then the job is cancelled; set `ONESIMUS_DEFAULT_MEDIA_WAIT` or `Max Wait Time` to change it |
| Failed batch insert of file records | job ends `T`, files are missing from the catalog | job ends with a fatal error: no silently missing files in the restore tree |
| Purge of jobs and files | no transaction, errors ignored | one transaction, errors are reported |
| Secrets in command lines | RunScript commands appear in full in the job log and in `show` | passwords, tokens and URL credentials are replaced by `***` in every message and in `show` |
| `configure add console` | creates a console with any ACL directives | only with profiles that do not allow more than the creating console has; `configure add profile/user` is refused |
| Catalog schema | Bareos tables only | Bareos tables stay untouched in `public`; Onesimus views, functions and the catalog ACL table live in their own schema `onesimus`, which never blocks a Bareos schema upgrade |

## What Bareos has that Onesimus does not have yet

| Area | Bareos | Onesimus today |
|---|---|---|
| Device types of the storage daemon | File, Tape, autochangers, FIFO, S3/object storage and more | `osd` writes to **File** devices only; tape and S3 are planned. `bareos-sd` keeps working with `odir`. |
| Storage daemon features | recycling, `relabel`, spooling, autochanger commands, SD-to-SD copy | not in `osd` yet |
| NDMP | supported | not supported |
| Plugins | Director and file daemon plugins, including Python plugins | no Director plugins and no Python plugins; file daemon plugins are being built as signed Rust/WebAssembly components |
| Packages and platforms | official packages for many distributions, Windows and macOS clients | Debian packages built from source for the Rust daemons; the GUI runs on Linux, Windows and macOS |
| Maturity and support | many years in production, commercial support | young project, not yet as established |

Something missing or wrong on this page? Open an issue on
[GitHub](https://github.com/Beerlesklopfer/Onesimus/issues).
