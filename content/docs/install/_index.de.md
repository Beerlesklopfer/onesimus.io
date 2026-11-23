---
title: "Installation & Betrieb"
description: "Oberfläche und Rust-Stack installieren, von Bareos umsteigen und zurück, über gRPC mit TLS verbinden, den Storage Daemon auf einem NAS betreiben."
weight: 3
---

Onesimus besteht aus zwei Teilen, die du unabhängig voneinander installieren kannst:

- **Die Oberfläche** (`onesimus`): eine Qt6-Desktop-Anwendung für Linux, Windows und macOS. Sie
  verwaltet einen Bareos Director über das klassische Konsolenprotokoll und einen Onesimus Director
  über gRPC mit TLS.
- **Der Rust-Stack**: der Director `odir`, der File Daemon `ofd`, der Storage Daemon `osd` und die
  Konsole `oconsole`. Jeder liest die Bareos-Konfiguration des Daemons, den er ersetzt.

Du kannst mit der Oberfläche an deinem bestehenden Bareos Director anfangen und die Daemons später
einzeln ersetzen.

## Was es heute als Paket gibt

| Teil | So bekommst du ihn heute |
|---|---|
| Oberfläche | aus den Quellen bauen (Linux, Windows, macOS); ein `.deb` lässt sich mit CPack bauen. Pakete der aktuellen Version werden über das [GitHub-Repository](https://github.com/Onesimus-io/Onesimus) veröffentlicht. |
| `odir`, `ofd`, `oconsole`, `osd` | Debian-Pakete, aus den Quellen mit `cargo deb` gebaut. Ein öffentliches Paket-Repository gibt es noch nicht. |

<div class="note">

Onesimus ist **noch nicht so etabliert wie Bareos**. Probier es auf einem Testsystem oder neben deiner
Bareos-Installation aus, mit einer Sicherung des Katalogs, bevor du dich darauf verlässt.

</div>
