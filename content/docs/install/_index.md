---
title: "Installation & operation"
description: "Install the GUI and the Rust stack, switch from Bareos and back, connect over gRPC with TLS, run the storage daemon on a NAS."
weight: 3
aliases:
  - /docs/getting-started/
---

Onesimus has two parts that you can install independently:

- **The GUI** (`onesimus`): a Qt6 desktop application for Linux, Windows and macOS. It manages a
  Bareos Director over the classic console protocol, and an Onesimus Director over gRPC with TLS.
- **The Rust stack**: the Director `odir`, the file daemon `ofd`, the storage daemon `osd` and the
  console `oconsole`. Each one reads the Bareos configuration of the daemon it replaces.

You can start with the GUI against your existing Bareos Director and replace the daemons later, one
at a time.

## What is packaged today

| Component | How you get it today |
|---|---|
| GUI | build from source (Linux, Windows, macOS); a `.deb` can be built with CPack. Packages of the current version will be published through the [GitHub repository](https://github.com/Onesimus-io/Onesimus). |
| `odir`, `ofd`, `oconsole`, `osd` | Debian packages built from source with `cargo deb`. There is no public package repository yet. |

<div class="note">

Onesimus is **not yet as established as Bareos**. Try it on a test system or next to your Bareos installation, with
a catalog backup, before you rely on it.

</div>
