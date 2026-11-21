---
title: "3-2-1 check"
description: "Checks for every backup job whether there are 3 copies of the data, on 2 media types, with 1 copy off site."
weight: 8
---

**Tools → 3-2-1 Verifier...** checks for every backup job whether there are **3** copies of the
data, on **2** media types, with **1** copy off site. The check is read only: it changes nothing
on the Director.

{{< screenshot name="check-321" alt="The 3-2-1 check dialog" >}}

## The table

One row per backup job: Job, Client, **Copies**, **Media Types**, **Off Site**, **Verdict** and
**Reason**.

- *Copies* counts the copies of the data a restore would use: the chain (the backup with the
  jobs it depends on), its complete copies (Copy jobs) and, if set, the original data.
- *Media Types* counts the distinct media types of the volumes of the chain and its complete
  copies.
- *Off Site* counts copies at another site, by your marking of the storages or by a location
  of the volume.

Below the table, **Chain and copies** lists the jobs a restore would use and their copies with
the volumes they lie on, and **Why, and what to do** gives reasons, suggestions and hints for
the selected job.

## Settings of the check

- **Count the original data as a copy**: the 3-2-1 rule is usually stated as the production
  data plus 2 backups. Off: 3 backups are needed.
- **Off-site storages**: Bareos does not record where a storage stands. Tick the storages that
  are at another site.
- **Unmarked storages are on site**: without this, a storage that is not ticked counts as
  *unknown*, not as on site.

**Refresh** reloads the jobs, the volumes of the jobs and the volume list.
