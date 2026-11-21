---
title: "Clients"
description: "The Clients tab: last backup, stale clients and client details."
weight: 3
---

The **Clients** tab lists the File Daemons of the Director with Name, Address, Port, Last
Backup, Operating System, Version, Last Connection, Jobs and Total Data.

{{< screenshot name="clients" alt="The Clients tab with the status of each client" >}}

## Recent, stale, never

The filter **Last backup** sorts the clients into:

- **Recent**: the last backup or contact is younger than the limit in the settings,
- **Stale**: it is older than that limit,
- **Never**: no known backup or contact,
- **Unknown**: the time of the last backup cannot be read.

The limit is *Client backup is stale after* in **Settings → Behavior** (in hours). The value
comes from the job history; it is not a live connection check. The *Statistics* box above the
table counts the clients in each group. **Filter by client...** narrows the list by name, and
**Auto** refreshes it automatically.

## Client details

A double click or **Clients → Show Client Details** (also *Details / Export...* in the context
menu) opens *Client Details* with general and connection information, the retention policies
(Auto Prune, File Retention, Job Retention), the recent jobs of the client and their
statistics (total, successful and failed jobs, total data and files).

**Clients → Add New Client...** creates a Client resource on the Director.
