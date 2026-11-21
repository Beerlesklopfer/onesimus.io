---
title: "Restore"
description: "The restore wizard: scope, file selection, options, command preview."
weight: 5
---

A restore starts from a job: right click it in the **Jobs** tab and choose **Restore
Files...**. The *Restore Wizard* has these steps:

1. **Restore Conditions**: the source job, client and FileSet. Restore scope: *All related
   backups (full restore chain)*, optionally only before a date, or *Only this specific job*.
2. **Select Files**: browse the backed-up file tree and tick files and directories. The
   counter shows how many directories and files are selected.
3. **Restore Options**: **Target Client**, **Restore Where** (the path on the target) and the
   **Replace Policy**:
   - *Always*: always overwrite existing files on the target,
   - *Never*: skip files that already exist,
   - *If Newer*: overwrite only if the backed-up file is newer,
   - *If Older*: overwrite only if the backed-up file is older.
4. **Command Preview**: the commands that will be sent to the Director, a summary (selection,
   estimated size, target client, path, replace policy) and **Permission Checks**: whether your
   console may run the restore, use the target client and the where path.
5. **Execute Restore**: the wizard sends the commands one after the other and shows each of them
   in a log. When the Director accepts the restore job, its Job ID is shown; follow its progress
   in the Jobs tab.

If the Director refuses the where path, the wizard explains that the console's **Where ACL**
restricts it and which path to ask your administrator for.

{{< screenshot name="restore" alt="The restore wizard with the file tree" >}}
