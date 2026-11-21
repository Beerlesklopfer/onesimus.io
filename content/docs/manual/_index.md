---
title: "User manual"
description: "How to work with the Onesimus GUI: connecting, jobs, clients, volumes, restore, schedules, ACLs and the 3-2-1 check."
weight: 20
---

The Onesimus GUI is a Qt6 desktop application for Linux, Windows and macOS. It talks to the
Onesimus Director over gRPC with TLS and to a classic Bareos Director over the Bareos console
protocol (BNET). Most functions work with both; where a function needs the Onesimus Director,
the chapter says so.

The main window has four tabs (**Jobs**, **Clients**, **Storage/Volumes**, **Schedules**), the
**Statistics** dock on the right and the menus **File**, **Edit**, **View**, **Jobs**,
**Clients**, **Storage**, **Schedules**, **Tools** and **Help**.

{{< screenshot name="overview" alt="Main window with the Jobs tab and the statistics dock" >}}

Chapters:

1. [Connecting to a Director](connecting/)
2. [Jobs](jobs/)
3. [Clients](clients/)
4. [Storage and volumes](storage/)
5. [Restore](restore/)
6. [Schedules](schedules/)
7. [ACL matrix](acl-matrix/)
8. [3-2-1 check](check-321/)
9. [Settings](settings/)

The console commands behind the GUI are described in the [command reference](/docs/commands/).
