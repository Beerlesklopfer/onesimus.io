---
title: "Konfigurationsreferenz"
description: "Alle Direktiven der Director-Konfiguration: Bedeutung, Standardwerte, Fallstricke und Beispiele, mit den Onesimus-Erweiterungen."
weight: 35
---

Die Konfigurationsreferenz gibt es auf Englisch, so wie die Direktiven selbst englisch sind.

Der Onesimus Director liest die Konfiguration des Bareos-25-Directors: dieselben Ressourcen,
Direktiven und dieselbe Syntax in denselben Dateien. Was als *Onesimus* markiert ist, gibt es nur
im Onesimus Director. Die meisten Direktiven kannst du auch in der Konsole mit
[`configure`](/docs/commands/configure/) oder in der Onesimus GUI ändern.

Jede Seite beginnt mit vollständigen Beispielen, dann folgen eine Übersicht und ein Abschnitt je
Direktive mit Typ, Standardwert, Erklärung und Beispiel.

- [Director](/docs/config/director/), [Client](/docs/config/client/),
  [Storage](/docs/config/storage/), [Catalog](/docs/config/catalog/)
- [Job](/docs/config/job/), [JobDefs](/docs/config/jobdefs/), [FileSet](/docs/config/fileset/)
  (mit Include, Exclude und Options), [Schedule](/docs/config/schedule/) (mit der Syntax der
  Run-Zeilen), [Pool](/docs/config/pool/)
- [Messages](/docs/config/messages/), [Counter](/docs/config/counter/)
- [Profile](/docs/config/profile/), [Console](/docs/config/console/), [User](/docs/config/user/)
