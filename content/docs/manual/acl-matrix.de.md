---
title: "ACL-Matrix"
description: "Welche Console welchen Job, Client, Storage, Schedule, Pool, welches FileSet, welchen Katalog und welchen Befehl benutzen darf: Consoles nebeneinander, Katalog-ACLs, neue Consoles und Profil-Vorschläge."
weight: 7
---

**Werkzeuge → ACL-Matrix der Konsolen...** zeigt die ACLs aller Consoles nebeneinander: eine
Spalte je Console, eine Zeile je Ressource (Jobs, Clients, Storages, Schedules, Pools, FileSets,
Kataloge und Befehle). Sie braucht den Onesimus Director, der den Befehl
[`.acl`](/docs/commands/dot-acl/) bereitstellt.

{{< screenshot name="acl-matrix" alt="ACL-Matrix: Ressourcen je Console" >}}

## Zwei Stufen von ACLs

Die ACL-Direktiven der Console- und Profile-Ressourcen in der Konfiguration des Directors (die
*Datei-ACL*) sind der äußere Rahmen. Der Onesimus Director ergänzt je Console eine *Katalog-ACL*,
die im Katalog liegt und diesen Rahmen nur weiter einengen kann. Eine Console darf, was beide
erlauben.

Die Zellen:

| Zeichen | Bedeutung |
|---|---|
| ✓ | erlaubt |
| ✗ | durch einen Eintrag mit "!" verboten |
| · | nicht erlaubt |
| ⊘ | von der Datei-ACL erlaubt, von der Katalog-ACL eingeschränkt |
| — | Console gesperrt (ihre Katalog-ACL lässt sich nicht lesen) |

Der Tooltip einer Zelle sagt warum; der Tooltip einer Console zeigt ihre Profile, ihre
Katalog-ACL und ihre Where- und Plugin-Options-ACLs. **Ressourcen filtern** grenzt die Zeilen
ein, **Nur Zeilen, in denen sich die Konsolen unterscheiden** blendet den Rest aus,
**Aktualisieren** liest alle ACLs neu.

## Die Katalog-ACL ändern

Im Reiter **Konsolen** verbietet ein Doppelklick (oder die Leertaste) auf ✓ die Ressource über
die Katalog-ACL; auf ⊘ erlaubt er sie wieder. Geänderte Zellen sind unterstrichen, bis sie
angewendet sind. **Anwenden...** zeigt jede Änderung einmal (jetzt / neu je Console und ACL-Typ)
und sendet sie nach deiner Bestätigung als `.acl set` / `.acl delete`; die erste Änderung, die
der Director ablehnt, stoppt den Rest. **Verwerfen** vergisst nicht angewendete Änderungen. Was
die Datei-ACL verbietet, lässt sich hier nicht erlauben; das ändert man in der Konfiguration.

## Neue Consoles

**Neue Konsole...** legt auf dem Director eine Console-Ressource mit Namen, erzeugtem Passwort
und Profil an (`configure add console`). Die ACLs des Profils sind der Rahmen der neuen Console;
die Matrix kann sie danach weiter einengen. Kopiere das Passwort sofort: wer die Console benutzt,
braucht es, und es lässt sich hier nicht wieder auslesen. Die Console erscheint als neue Spalte.

## Profil-Vorschläge

Der Reiter **Profile** zeigt die ACLs der Profile-Ressourcen. Profile stehen nur in den
Konfigurationsdateien des Directors, deshalb schreibt die GUI sie nie: ein Doppelklick ändert
eine Zelle in einem *Vorschlag*, und **Konfigurationstext...** zeigt den neuen Text jedes
geänderten Profils. **Neues Profil...** fügt ein vorgeschlagenes Profil als neue Spalte hinzu,
leer oder als Kopie eines vorhandenen.

Setz den vorgeschlagenen Text an die Stelle der Profile-Ressource in ihrer Datei (der angezeigte
Pfad ist ein Vorschlag), prüf ihn mit dem Test des Directors (`-t`) und lade den Director neu;
dann zeigt **Aktualisieren** den neuen Stand. Kommentare der alten Ressource sind nicht im
vorgeschlagenen Text.
