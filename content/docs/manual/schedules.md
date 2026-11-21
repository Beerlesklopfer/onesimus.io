---
title: "Schedules"
description: "The timeline of the night with measured durations and predicted waits, the schedule grid editor, the stagger proposal and the schedule wizard."
weight: 6
---

The **Schedules** tab shows when your jobs run, how long they take and where they wait for
each other. **View** switches between **Timeline**, **Grid** and **Measured waits**. The list
on the left holds the schedules; the table next to it shows the jobs of the chosen schedules
with Type, Client, Storage, FileSet and **Median duration**.

Changing, copying, renaming and deleting schedules uses the configuration methods of the
Onesimus Director over gRPC. On a BNET connection the views work read only, and a click on a
writing function says why it is not available.

## Timeline

The timeline shows the runs of a **Day** or a **Week** (**Today** jumps back), in two tracks:
**Clients (FD)** and **Storage (SD)**. **Zoom** sets the pixels per hour, **Snap** the grid a
dragged bar snaps to.

- The length of a bar is the **median duration** of the job's measured runs at that level; a
  lighter extension marks the 90th percentile (nine of ten runs ended by then). The colour
  stands for the level (Full, Differential, Incremental, Virtual Full).
- A pale, dashed bar with "~" is an estimate from other levels; a dashed outline with "?" marks
  a job that never ran.
- An **hourglass** marks a run that will wait; the hatched strip is the predicted wait, from the
  scheduled time to the predicted start. In the day view, arrows show which run waits for which
  and for what limit.
- **Measured runs** adds a thin track below the bars with the runs of past dates and today as
  the job history measured them, including the time they waited.
- Running jobs are drawn with the times the Director reports; their tool tip says *Running now*
  or *Waiting now*.

**Legend** explains every mark. The durations come from the job history of the last days; how
many days is set in **Settings → Behavior** (*Measure job history over the last*).

{{< screenshot name="schedules" alt="Timeline of the night with measured durations and waits" >}}

### Predicted waits

The tabs below the timeline hold **Predicted waits**, **Measured history** and **Stagger**.
*Predicted waits* lists every run that is predicted to wait, or whose prediction is uncertain,
with scheduled time, predicted start, wait, the measured wait and the reason. The prediction
replays the queue of the Director from its limits (Maximum Concurrent Jobs of Director, clients,
storages and jobs, priorities) and the measured durations. A limit the Director does not report,
such as the parallel writers of a device in the storage daemon, can be entered; until then the
runs that depend on it are marked uncertain. A *Back-test* compares the prediction with the
history.

### Moving a run

Drag a bar to another time to move its Run line. Only this line is written anew; the other lines
stay as they are in the file. If the schedule is used by several jobs, Onesimus asks: **Change
schedule ... for all jobs**, or **Move only job ...**, which creates a copy of the schedule with
the run at the new time and sets the Schedule of that job to it.

## Measured waits

This view lists per job and level the measured runs, median and 90% duration, median and 90%
wait and the last run. *Wait* is the start of the job minus its scheduled time. **Refresh
history** asks the Director again for the jobs of the last days.

## Stagger proposal

Jobs that are scheduled for the same moment and share a limit (a storage, a client, the job slots
of the Director, the parallel writers of a device) wait for each other. **Propose later start
times** on the *Stagger* tab replays the queue with jobs moved later quarter hour by quarter hour
(23:15, 23:30 ...) and keeps the smallest moves that wait least. A wait for a higher priority is
intended and not counted; a job of lower priority that follows a moved job moves along.

The table shows per job the current and proposed start, how much later, the wait now and then,
and a note. **Constraints...** keeps a job where it is (*Fixed*) or sets a *Latest start*; the
constraints are kept on your computer for this Director.

**Apply...** creates a schedule of its own for every job that starts later, named after the old
one plus the new start time (for example `Nightly-2315`), and sets the job's Schedule to it.
Everything is shown once for confirmation; the Director checks each resource, and the first one
it refuses stops the rest. Nothing is changed before you confirm.

{{< screenshot name="schedule-stagger" alt="Stagger proposal with start times on a quarter-hour grid" >}}

## Grid editor

The **Grid** view shows the chosen schedule as a grid of weekdays and hours, painted by level.

- **Brushes**: a brush is a level, the minute of the hour and optionally overrides that replace
  the job's settings (Storage, Pool, Messages, Full/Incremental/Differential/Next pool, Priority,
  Spool data, Accurate, Max run sched time). **New brush...** defines one; the **Eraser** removes
  runs. In *Paint mode* dragging paints at once; otherwise select cells and press Space.
  *Keep other runs* adds a brush to a cell instead of replacing its runs.
- **Scopes**: weeks of the month and months a grid is painted for, such as "1st sat at 21:00".
  **Add scope** creates one; runs of other scopes are shown hatched.
- **Calendar rules**: Run lines by day of the month or week of the year (such as "on 1 at
  21:00") do not belong to a weekday; **Add rule...**, **Edit rule...** and **Remove rule**
  manage them.
- **Run lines** lists the lines of the schedule; choosing one outlines its cells.
- **Description** is the Description of the schedule; it is saved with the Run lines.
- Undo and Redo (Ctrl+Z, Ctrl+Shift+Z) and **Revert all**.

**Save...** writes the changed Run lines. The Director checks them first; the review shows the
Run lines now and after writing, the jobs that use the schedule, and the text after writing,
which you can still edit (*Check with the Director*). Only **Write to the Director** writes it;
lines you did not touch stay as they are in the file. **Delete...**, **Copy...** and
**Rename...** work the same way, with a check and a confirmation. A schedule with a Run line
the GUI does not understand is locked and has to be changed in its configuration file.

{{< screenshot name="schedule-editor" alt="Schedule grid: weekdays by hours, painted by level" >}}

## New schedule wizard

**Schedules → Add Schedule...** opens *New Schedule*: a name, a description and *Enabled*, then
the runs painted on the grid, then a review of the Run lines, the resource and the Director
command (*Copy Resource* copies the text). At the end the wizard asks whether to send
`configure add` to the Director; the Director checks the schedule and creates it.
