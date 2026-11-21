---
title: "Jobs"
description: "The job list, filters and statistics, job details, the live job log, running, rerunning and cancelling jobs."
weight: 2
---

The **Jobs** tab lists the jobs from the catalog: Job ID, Name, Client, Start Time, End Time,
Duration, Type, Level, Files, Size and Status. Over gRPC the Onesimus Director delivers a typed
job list with start and scheduled times.

{{< screenshot name="overview" alt="The Jobs tab with the job list and the statistics dock" >}}

## Filters and refresh

**Filter** shows or hides the filter area:

- *Basic Filters*: **Job Name**, **Client** and the status boxes Successful (T), Warning (W),
  Failed (F), Error (E), Running (R) and Canceled (A), plus **Zero Bytes** (only jobs that
  transferred nothing).
- **Backup Level**, **Date Range** (*Enable Date Filter*, From, To) and **Job Details**
  (FileSet, Storage, Pool). **Reset filter** clears them.

Filters are kept across restarts. When a filter from the last session is active, a warning
line above the table says so, so that an empty table does not surprise you.

**Refresh** (Ctrl+Shift+J) reloads the list; **Auto-Refresh** reloads it every 5 s, 10 s,
30 s, 1 min or 5 min. With many jobs the list can be paged (*Enable Pagination*,
*Items per page*).

The **Statistics** dock (View → Show Statistics) sums up the jobs in the list: Total Jobs,
Selected, Successful, Warnings, Failed, Total Files, Total Size and the date range.

## Context menu

A right click on a job offers **Show Details...**, **Retry Job**, **Cancel Job**,
**Delete Job**, **View Log...**, **Restore Files...**, **Export to JSON...**, **Export to
CSV...** and the selection commands. Every action that changes something asks first.

- **Retry Job** runs the selected job again after the question *Rerun Job*.
- **Cancel Job** cancels a running job after confirmation.
- **Delete Job** offers two modes: *Delete job record only* (the catalog entry goes, the data
  on the volumes stays) or *Prune* (remove expired jobs by retention policy). When a Full
  backup still has dependent Incremental or Differential jobs, the dialog warns that they may
  become unusable for restore.
- **Restore Files...** opens the [restore wizard](../restore/).

## Job details

**Show Details...** opens *Job Details*: Job ID, name, client, type, level, FileSet, schedule,
start time, duration, files backed up, data size and job status, with tabs for the files and
the log of the job.

## The live job log

The **Job Log** panel below the list (View → Show Job Log, Ctrl+Shift+L) shows the log of the
selected job; the **Messages** tab next to it shows the Director's messages. The header shows
the job, its ID and the number of lines, and *job is running* while it runs.

While a job runs, the log grows by itself:

- over **gRPC** the Onesimus Director pushes every new log line as it happens;
- over **BNET** the GUI asks the catalog again every few seconds.

When the job ends, the log is loaded from the catalog once more so that it is complete. You can
search in the log, copy selected lines and go back to logs loaded before with *History*.

{{< screenshot name="job-log" alt="A running job with its live job log" >}}

## Running a job

**Jobs → Run Job** opens *Run Backup Job*: choose the **Job**, and if needed **Client**,
**Level**, **FileSet**, **Pool**, **Storage**, **Priority** and **When** (start time as
YYYY-MM-DD HH:MM:SS, empty for now). *Advanced* has bootstrap and replace options. The
**Command Preview** shows the exact `run` command that will be sent; **Estimate** asks the
Director for the expected number of files and size first. **Run Job** sends it after a final
confirmation.
