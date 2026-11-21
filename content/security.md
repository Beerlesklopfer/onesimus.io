---
title: "Security"
description: "How to report a vulnerability in Onesimus, and how we handle it."
---

Onesimus manages backups, so its security matters to everyone who uses it. This page describes how we
handle vulnerabilities, as the EU Cyber Resilience Act (Regulation (EU) 2024/2847) asks of software
manufacturers. The same text is in [SECURITY.md](https://github.com/Beerlesklopfer/Onesimus/blob/development/SECURITY.md)
in the repository.

## Report a vulnerability

Please report it **privately**, never in a public issue:

- on GitHub: **Security → Report a vulnerability** in the
  [Onesimus repository](https://github.com/Beerlesklopfer/Onesimus/security/advisories/new), or
- by e-mail to [contact@onesimus.io](mailto:contact@onesimus.io?subject=SECURITY) with the subject `SECURITY`.

Include the affected version or commit, the platform, the steps to reproduce and what an attacker gains.
Please test only against systems that are yours.

This covers the GUI and the Rust backup stack (`odir`, `ofd`, `osd`, `oconsole`).

## What happens next

1. We confirm receipt within **7 days**.
2. We assess the report and tell you how severe we consider it.
3. We fix it in the supported versions and agree a publication date with you; we aim for a fix within
   90 days.
4. We publish a GitHub Security Advisory, with a CVE where it applies, and credit you unless you prefer
   not to be named.

Actively exploited vulnerabilities and severe incidents are reported to the authorities as Article 14 of
the Cyber Resilience Act requires.

## Supported versions

Until v1.0.0 only the newest state of the development branch receives security fixes. From v1.0.0
each version receives security fixes for 2 years from its release date.

Machine-readable contact: [/.well-known/security.txt](/.well-known/security.txt) (RFC 9116).
