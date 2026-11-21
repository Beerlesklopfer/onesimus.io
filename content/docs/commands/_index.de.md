---
title: "Befehlsreferenz"
description: "Alle Konsolenbefehle des Onesimus Directors: Syntax, Argumente, Beispiele und welche Befehle Bareos erweitern."
weight: 30
---

Die Befehlsreferenz gibt es nur auf Englisch, denn auch die Konsole spricht Englisch: Befehle,
Argumente und Meldungen des Directors sind englisch.

Der Onesimus Director (`odir`) versteht die Konsolensprache des Bareos Directors. Seine Befehle
folgen denen von `bareos-dir`; manche verhalten sich mit Absicht anders (siehe den
[Vergleich mit Bareos](/de/compare/)), und jede Befehlsseite zeigt den Stand dieses Befehls. Die
Onesimus GUI schickt Befehle über ihre Dialoge. Was als
*Onesimus extension* markiert ist, gibt es nur im Onesimus Director. Die Seiten werden aus der
Grammatik erzeugt, die der Director selbst mit `.grammar` ausgibt.

- [Übersicht aller Befehle](/docs/commands/) (englisch)
- Häufig gebraucht: [`status`](/docs/commands/status/), [`list`](/docs/commands/list/),
  [`run`](/docs/commands/run/), [`restore`](/docs/commands/restore/),
  [`purge`](/docs/commands/purge/), [`configure`](/docs/commands/configure/)
- Onesimus-Erweiterungen: [`.acl`](/docs/commands/dot-acl/) (Katalog-ACLs pro Console),
  [`.grammar`](/docs/commands/dot-grammar/), [`.config`](/docs/commands/dot-config/),
  [`.ovfs_tree`](/docs/commands/dot-ovfs_tree/)
