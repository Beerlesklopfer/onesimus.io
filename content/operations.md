---
title: "Operations report"
description: "Where Onesimus runs today, what has been restored with it, and what has not been tested yet."
---

<div class="note">

**As of 23 November 2026.** This page lists only what can be shown from the catalog, the test records and the
repositories. It is the maintainer's own installation, not the operation of third parties. Backup software proves
itself over months and through restores; this report is updated as that time passes.

</div>

## The production installation

- **Director:** the Onesimus Director `odir` has been the production Director since 17 October 2026 at the latest.
  The first job that shows it in the catalog is backup job 781 of that day, with the Director line
  `Version: 25.1.2+onesimus.0.2.0`. Before, the catalog shows the Bareos Director; an earlier start of `odir` cannot
  be read from it.
- **Clients:** five file daemons are configured; four of them ran backups in the last 30 days.
- **Catalog:** the Bareos PostgreSQL catalog. By design, Onesimus does not change the Bareos tables (Bareos schema
  version 2250); its own views, functions and tables live in a separate schema `onesimus`.
- **Storage:** the main storage daemon is still `bareos-sd`. Since 21 November 2026 the Onesimus storage daemon `osd`
  runs on a second machine in trial operation: as the storage of a test backup job and, since 23 November 2026, as the
  target of copy jobs.

## Restores with the Onesimus Director

Restores in the production catalog:

| Job | Files | Data | Status |
|---|---|---|---|
| 865 | 24,506 | 5.0 GB | OK |
| 936 | 369 | 9.45 GB | OK |
| 884, 885, 886, 887, 888, 891, 935, 988, 990, 991, 1044, 1045, 1046, 1143 | | | OK |
| 851, 852 | | | ended with an error |
| 866 | | | failed |

## Tested outside production

- **File daemon on Windows:** `ofd` was tested on a Windows 11 virtual machine with Volume Shadow Copy and UNC paths.
  A file larger than 4 GiB was restored bit for bit. A backup of drive C: without the Windows, program and tool
  folders (195,895 files, 21.3 GB read, 13.1 GB written) ended OK without errors; a restore of it was not tested.
- **Storage daemon:** Bareos' `bls` reads `osd` volumes in the test environment. `osd` brings no own `bscan` or
  `bextract`; using the Bareos tools on `osd` volumes has not been tested.
- **Plugins:** the brokers and signed file daemon plugins are tested in the test environment of the repository.
- **GUI:** built and tested on every push on Linux and Windows, built and packaged on macOS.

## Not tested yet

We say this openly, because these points matter for a decision. For each of them we have no record of a test:

- **The way back to Bareos** with the same database: a real `bareos-dir` on a catalog that `odir` has extended,
  followed by a restore. It is designed for (no Onesimus object depends on a Bareos table) and described in
  [Migrating from Bareos](/docs/install/migrate-from-bareos/), but not proven.
- **Speed of OVFS against BVFS.** A test compares both listings byte for byte; how much faster OVFS is, we will only
  state after a measurement.
- **WebAssembly plugins in production**, and an external security review.
- **The file daemon on macOS.**

Corrections and reports from your own operation are welcome on
[GitHub](https://github.com/Onesimus-io/Onesimus/issues).
