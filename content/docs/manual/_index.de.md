---
title: "Handbuch"
description: "So arbeitest du mit der Onesimus GUI: Verbinden, Jobs, Clients, Volumes, Restore, Schedules, ACLs und die 3-2-1-Prüfung."
weight: 20
---

Die Onesimus GUI ist eine Qt6-Desktop-Anwendung für Linux, Windows und macOS. Mit dem
Onesimus Director spricht sie gRPC mit TLS, mit einem klassischen Bareos Director das
Bareos-Konsolenprotokoll (BNET). Die meisten Funktionen gehen mit beiden; wo eine Funktion den
Onesimus Director braucht, sagt es das Kapitel.

Das Hauptfenster hat vier Reiter (**Jobs**, **Clients**, **Storage/Volumes**, **Schedules**),
rechts das Dock **Statistik** und die Menüs **Datei**, **Bearbeiten**, **Ansicht**, **Jobs**,
**Clients**, **Storage**, **Schedules**, **Werkzeuge** und **Hilfe**.

{{< screenshot name="overview" alt="Hauptfenster mit dem Reiter Jobs und dem Statistik-Dock" >}}

Kapitel:

1. [Mit einem Director verbinden](connecting/)
2. [Jobs](jobs/)
3. [Clients](clients/)
4. [Storage und Volumes](storage/)
5. [Restore](restore/)
6. [Schedules](schedules/)
7. [ACL-Matrix](acl-matrix/)
8. [3-2-1-Prüfung](check-321/)
9. [Einstellungen](settings/)

Die Konsolenbefehle hinter der GUI beschreibt die [Befehlsreferenz](/de/docs/commands/).
