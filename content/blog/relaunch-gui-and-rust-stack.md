---
title: "Onesimus today: a modern GUI and a Rust backup stack"
date: 2026-11-21
author: "Beerlesklopfer"
description: "Onesimus is no longer only a desktop UI for Bareos: it is a GUI plus a Rust Director, file daemon, storage daemon and console that drop in for Bareos 25."
tags: ["announcement", "bareos", "rust", "grpc"]
---

When we started Onesimus in early 2026, it was a desktop interface for Bareos. Since then the project
has grown into a complete backup stack. This post explains where it stands and what is next.

## Two parts, one product

**The GUI** (Qt 6, Linux, Windows, macOS, six languages) manages jobs, clients, storage and volumes,
schedules, restores and console permissions. It talks to a classic Bareos Director over the Bareos
console protocol, and to the Onesimus Director over gRPC with TLS.

**The Rust stack** replaces the Bareos daemons one by one:

- `odir`, the Director: reads the Bareos 25 configuration, uses the Bareos PostgreSQL catalog and
  speaks the Bareos protocols to `bconsole`, file daemons and storage daemons;
- `ofd`, the file daemon, and `osd`, the storage daemon (File devices for now);
- `oconsole`, the console, with completion from the Director's own command grammar.

Bareos stays your way back: the configuration keeps Bareos syntax, and `bareos-dir` can take over
again at any time (see [Migrating from Bareos](/docs/install/migrate-from-bareos/)).

## Why a new Director?

Stability first. Each job that talks to a daemon runs in its own process, so a crashing job does not
take the Director down. The latest successful Full chain of every client is never pruned or purged.
A failed batch insert of file records ends the job with an error instead of silently missing files.

And we finish what the console leaves half done: `configure update` and `configure delete`,
catalog ACLs per console (`.acl`), `purge volume all … dryrun` to preview a bulk purge, and a typed
gRPC API with push events, which gives the GUI its live job log. The full list, including what Bareos
can do that Onesimus cannot do yet, is on the [comparison page](/compare/).

## What the GUI shows on top

- **Schedules:** a timeline of the night with measured durations and the waits between jobs, an
  editor grid, and a proposal that staggers start times on a 15-minute grid.
- **ACL matrix:** every console's rights at a glance, editable through the catalog ACLs.
- **3-2-1 check:** whether your data has enough copies on enough media.

## Status

Onesimus is in early access. Packages of the current version will be published through the
[GitHub repository](https://github.com/Onesimus-io/Onesimus); the first public release will be
**v1.0.0**. Until then you can build it from source ([installation](/docs/install/)) and read the
[manual](/docs/manual/), the [command reference](/docs/commands/) and the
[configuration reference](/docs/config/).
