---
title: "Storage and volumes"
description: "Pools and volumes, when a volume can be reused, and the database cleanup with the purge preview."
weight: 4
---

The **Storage/Volumes** tab lists the volumes of the Director: Volume, Pool, Status, Used,
Limit, Jobs, Last Written, Retention, **Reusable From** and **Reason**. Filter by **Pool** and
**Status**; the *Statistics* box counts the volumes and the space used. The tab refreshes itself
when you open it; **Refresh** (Ctrl+Shift+V) reloads it any time.

{{< screenshot name="storage" alt="The Storage/Volumes tab with pools and volumes" >}}

## When is a volume reused?

*Reusable From* is the earliest date from which Bareos may reuse a volume. Bareos does so only
when its pool needs a volume, so this is the earliest date, not the day of recycling. The
*Reason* column explains the date in words, for example:

- Append volumes: open until full, or until the end of the use duration, then the volume
  retention;
- Purged: no job needs it any more, reusable now;
- Archived, Disabled, Read-Only or Error: Bareos never prunes or recycles such a volume (an
  Error volume keeps its space until its status is changed);
- Recycle = no: the volume is never reused.

Enter or a double click opens *Volume Details* with all values of the volume (media type,
storage, errors, first and last written, labeled, volume retention, use duration, recycle pool,
times recycled and more).

## Database cleanup and purging volumes

**Tools → Database Cleanup...** removes old data from the catalog in two steps: **Analyze**
shows what would be removed, **Cleanup** does it after a confirmation. Options:

- *Remove old full backups*: keep the last *n* full backups per client, job and FileSet; a full
  backup that incremental or differential backups still depend on is kept;
- *Remove successful jobs with no files*;
- *Remove failed jobs older than* a number of days;
- *Prune volumes*: apply the retention periods to all volumes.

The analysis looks at the jobs currently loaded in the job list. Every command and every answer
of the Director is written to the log of the dialog.

### Purge volumes (preview first)

With the Onesimus Director, set *Prune volumes* to the action **Prune and purge**: the panel
**Purge volumes** appears in the same dialog. It purges whole volumes: all job and file records
of the chosen volumes are removed from the catalog, whatever their retention periods say. The
purge is not part of *Cleanup*; it has its own preview and button.

1. Choose the **Pool** (or *All pools*) and the **Volume status** values.
2. **Preview** asks the Director which volumes it would purge; nothing is changed. The table
   shows each volume with its jobs, files, size and the result *Would purge* or *Skipped* (with
   the reason).
3. **Purge** purges the volumes of the preview after a confirmation that shows the exact
   command. If you change the selection, you have to run the preview again.

The Director selects the volumes again when it purges; volumes that changed since the preview
are purged or skipped according to their state then. The preview uses the Onesimus extension
`purge volume all ... dryrun|yes` (see [`purge`](/docs/commands/purge/)). A plain Bareos
Director has no command that purges all volumes at once; there *Prune and purge* cannot be
selected.

{{< screenshot name="purge" alt="The purge panel with the preview of the volumes" >}}
