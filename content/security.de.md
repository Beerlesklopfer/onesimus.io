---
title: "Sicherheit"
description: "Wie du eine Sicherheitslücke in Onesimus meldest und wie wir damit umgehen."
---

Onesimus verwaltet Backups, deshalb geht seine Sicherheit alle an, die es nutzen. Diese Seite beschreibt,
wie wir mit Sicherheitslücken umgehen, wie es der Cyber Resilience Act der EU (Verordnung (EU) 2024/2847)
von Software-Herstellern verlangt. Derselbe Text steht als
[SECURITY.md](https://github.com/Beerlesklopfer/Onesimus/blob/development/SECURITY.md) im Repository.

## Sicherheitslücke melden

Bitte melde sie **vertraulich**, nie in einem öffentlichen Issue:

- auf GitHub: **Security → Report a vulnerability** im
  [Onesimus-Repository](https://github.com/Beerlesklopfer/Onesimus/security/advisories/new), oder
- per E-Mail an [contact@onesimus.io](mailto:contact@onesimus.io?subject=SECURITY) mit dem Betreff `SECURITY`.

Nenne die betroffene Version oder den Commit, die Plattform, die Schritte zum Nachstellen und was ein
Angreifer damit erreicht. Bitte teste nur gegen Systeme, die dir gehören.

Das gilt für die GUI und für den Rust-Backup-Stack (`odir`, `ofd`, `osd`, `oconsole`).

## Wie es weitergeht

1. Wir bestätigen den Eingang innerhalb von **7 Tagen**.
2. Wir bewerten die Meldung und sagen dir, wie schwer wir sie einschätzen.
3. Wir beheben die Lücke in den unterstützten Versionen und stimmen den Veröffentlichungstermin mit dir
   ab; unser Ziel ist eine Korrektur innerhalb von 90 Tagen.
4. Wir veröffentlichen ein GitHub Security Advisory, wo es zutrifft mit CVE, und nennen dich, wenn du
   das möchtest.

Aktiv ausgenutzte Schwachstellen und schwere Sicherheitsvorfälle melden wir den Behörden, wie es
Artikel 14 des Cyber Resilience Act verlangt.

## Unterstützte Versionen

Bis v1.0.0 bekommt nur der neueste Stand des Entwicklungszweigs Sicherheitskorrekturen. Ab v1.0.0 wird
der Unterstützungszeitraum mit jedem Release genannt.

Maschinenlesbarer Kontakt: [/.well-known/security.txt](/.well-known/security.txt) (RFC 9116).
