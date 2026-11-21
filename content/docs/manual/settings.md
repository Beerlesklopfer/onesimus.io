---
title: "Settings"
description: "Connection profiles, language, theme, interface zoom and behaviour."
weight: 9
---

**File → Settings** (Ctrl+,) has four pages: **Connection**, **Appearance**, **Behavior** and
**Advanced**. **Apply** saves, **Reset** returns to the defaults.

{{< screenshot name="settings" alt="The settings dialog" >}}

## Connection

The *Connection Manager* lists the saved connection profiles (**+ Add**, **Edit**,
**Duplicate**, **Delete**). A profile holds the host, port, protocol (*BNET (Bareos console
protocol)* or *gRPC (Onesimus Director)*), the gRPC port, the server OS, the Director and console
names and the password. For BNET it also holds the TLS settings (PSK or x509 certificates); for
gRPC the pinned *Server certificate* fingerprint with **Forget certificate**. Options: *Save
password in profile*, *Auto-connect on startup*, *Connection timeout*. Profiles can be exported
and imported.

## Appearance

- **Interface zoom**: the text follows the font of your desktop; this factor enlarges or
  reduces it. The same works from the keyboard: Ctrl++ and Ctrl+- (View → Interface Zoom In /
  Out), Ctrl+0 resets it.
- **Application Language**: English, German, Spanish, French, Italian or Russian, or *System*,
  which follows the language of the operating system. A change takes effect after a restart;
  Onesimus offers to restart at once (the menu **Language** does the same).
- Colours of the status bar and of the backup levels.

The **theme** switches between dark and light with **Toggle Dark/Light Theme** (Ctrl+Shift+T).

## Behavior

- Confirmations before cancelling or starting a job.
- **Auto-refresh** and its interval.
- *Maximum Jobs* in the job list and *Show newest jobs first*.
- *Client backup is stale after* (hours): the limit for the stale clients on the
  [Clients](../clients/) tab.
- *Measure job history over the last* (days): the history the [schedule views](../schedules/)
  measure durations and waits from.
- *Visible Backup Levels* in the Run Backup dialog.

## Advanced

File logging (*Enable file logging*, log file, maximum size) for debugging.
