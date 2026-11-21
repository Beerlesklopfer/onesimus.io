---
title: "Onesimus — Modern Backup Management"
description: "A modern Qt6 GUI and a stable Rust backup stack: a drop-in replacement for the Bareos Director, with Bareos as the fallback."

hero:
  badge: "Open source · AGPL-3.0"
  title: "A modern backup GUI."
  titleEm: "A stable Rust core."
  subtitle: "Onesimus is a Qt6 desktop application **and** a backup stack written in Rust: Director, file daemon, storage daemon and console. It drops in for Bareos 25: same configuration, same catalog, same clients. And Bareos stays installed as your way back."
  actions:
    - label: "Install"
      url: "/docs/install/"
      primary: true
    - label: "Onesimus vs. Bareos"
      url: "/compare/"
    - label: "GitHub"
      url: "https://github.com/Beerlesklopfer/Onesimus"
  screenshot:
    name: "overview"
    alt: "The Onesimus main window: the Jobs tab with the job list and the statistics dock"

pillars:
  label: "Why Onesimus"
  title: "One package, three promises"
  items:
    - icon: "🖥️"
      title: "A GUI you want to use"
      text: "A native Qt6 application for Linux, Windows and macOS, in English, German, Spanish, French, Italian and Russian. It talks gRPC with TLS to the Onesimus Director and the classic console protocol to any Bareos Director."
    - icon: "⚙️"
      title: "Stability first"
      text: "The Director `odir` runs every job that talks to a daemon in its own process: a job that crashes cannot take the Director down. Its console output is checked against `bconsole` byte for byte."
    - icon: "↩️"
      title: "Bareos stays your fallback"
      text: "`odir` reads `/etc/bareos/bareos-dir.d` as it is and uses the Bareos PostgreSQL catalog. Both Directors can stay installed; systemd starts one and stops the other."

showcase:
  label: "Features"
  title: "What you see in Onesimus"
  subtitle: "Screenshots from a demo Director with invented data."
  items:
    - label: "Jobs"
      title: "Every job at a glance"
      text: "The Jobs tab lists the jobs of the catalog with a statistics dock next to it."
      bullets:
        - "Filter by status, level, client, name and date"
        - "Job details with files, bytes, duration and log"
        - "Export the list as JSON or CSV"
      screenshot:
        name: "overview"
        alt: "Jobs tab with the job list and the statistics dock"
    - label: "Live job log"
      title: "Watch a job while it runs"
      text: "Against the Onesimus Director the job log is pushed over gRPC the moment the Director writes it, together with the job status. Against a Bareos Director the GUI polls the log instead."
      badge: "Push events with the Onesimus Director"
      screenshot:
        name: "job-log"
        alt: "A running job with its live job log"
    - label: "Schedules"
      title: "The whole night on one timeline"
      text: "The Schedules tab draws the night as a Gantt timeline from measured job durations and shows where jobs will wait for each other."
      bullets:
        - "Editor grid: weekday × hour, painted by level"
        - "Stagger proposal: start times on a 15-minute grid"
        - "Applying a proposal copies the schedule as `<name>-HHMM`; every change is shown to you before it is written"
      screenshot:
        name: "schedules"
        alt: "Schedules tab: Gantt timeline of the night with predicted waits"
    - label: "Access control"
      title: "Who may do what, in one matrix"
      text: "The ACL matrix shows the rights of every console. On the Onesimus Director you can create a console with a profile from the GUI, and narrow a console further with catalog ACLs (`.acl`) without touching a configuration file."
      badge: "Catalog ACLs with the Onesimus Director"
      screenshot:
        name: "acl-matrix"
        alt: "ACL matrix of the consoles"
    - label: "Prune & purge"
      title: "Purge with a preview"
      text: "The prune and purge panel first runs a dry run and lists what would be purged. Only the previewed volumes are purged, and only after you confirm."
      bullets:
        - "Many volumes at once with `purge volume all … dryrun|yes` (Onesimus Director)"
        - "The Onesimus Director never purges the volumes that hold the latest Full chain of a client"
      screenshot:
        name: "purge"
        alt: "Prune and purge panel with the dry-run preview"
    - label: "Restore & 3-2-1"
      title: "Restore files, check your copies"
      text: "The restore wizard walks you through job selection and the file tree. The 3-2-1 check shows for each job whether its data exists in enough copies, on different media types and off site."
      screenshot:
        name: "check-321"
        alt: "3-2-1 check dialog"

features:
  label: "More"
  title: "Built for administrators"
  items:
    - icon: "🔌"
      title: "Connection wizard"
      text: "Finds Onesimus Directors on the local network (mDNS) and pins the Director's TLS certificate on first use. TLS-PSK and certificates for Bareos Directors."
    - icon: "🧩"
      title: "Edit the configuration safely"
      text: "With the Onesimus Director, resources can be added, changed and deleted (`configure add/update/delete`). Every change starts from the raw configuration text and is shown to you before it is written."
    - icon: "📖"
      title: "One grammar for every command"
      text: "The Onesimus Director describes its console commands in a grammar (`.grammar`). The command reference on this site, completion in `oconsole` and the man pages come from it."
    - icon: "🗂️"
      title: "Restore browsing with OVFS"
      text: "Next to BVFS the Onesimus Director browses backup contents with OVFS, a PostgreSQL extension, and computes the same result itself where the extension is missing."
    - icon: "🤖"
      title: "MCP for AI assistants"
      text: "`oconsole --mcp` offers the Director to AI assistants as typed tools. This is configuration, not a separate program: every console whose name ends in `-mcp` is an assistant console, with its own password; the profile `assistant` lets it read and change the configuration. ACL changes, new consoles and direct SQL are refused by the Director for every assistant console, whatever the configuration says. No tool delivers backup contents: a restore, if you allow one, writes the files to the client, never to the assistant. [How to set it up](/docs/install/mcp/)"
    - icon: "🌍"
      title: "Six languages, two themes"
      text: "Choose the language and a dark or light theme in the settings."

stack:
  label: "The stack"
  title: "Replace one part or all of them"
  subtitle: "Each Onesimus daemon reads the Bareos configuration of the part it replaces. You can mix Onesimus and Bareos daemons."
  items:
    - name: "odir"
      role: "Director"
      text: "Drop-in for `bareos-dir` 25: same `bareos-dir.d`, same PostgreSQL catalog, the classic console port for `bconsole`, plus gRPC with TLS for the GUI."
      fallback: "Way back: `bareos-dir`"
    - name: "ofd"
      role: "File daemon"
      text: "Backup, restore, estimate and verify. Talks gRPC with TLS to `odir` and falls back to the classic protocol."
      fallback: "Way back: `bareos-fd`"
    - name: "osd"
      role: "Storage daemon"
      text: "Writes volumes in the Bareos format that `bls` and `bareos-sd` can read. File devices for now; also serves a Bareos Director over the classic protocol."
      fallback: "Way back: `bareos-sd`"
    - name: "oconsole"
      role: "Console"
      text: "Interactive console over the classic protocol or gRPC, with completion from the Director's grammar and an MCP server."
      fallback: "`bconsole` keeps working"
  note: "Tape, S3 and other device types are on the storage daemon's plan, not in it yet. See [Onesimus vs. Bareos](/compare/) for what is different and what is missing."

name:
  label: "The name"
  title: "Why Onesimus?"
  text: "Onesimus was a slave in the first century who ran away from his master Philemon. Far from home he met the apostle Paul, and through him Jesus Christ. Paul sent him back with a short letter that is part of the New Testament today. In it he plays on the name, which means *useful*:"
  quotes:
    - text: "Formerly he was useless to you, but now he is indeed useful to you and to me."
      source: "[Philemon 11](https://www.bibleserver.com/ESV/Philemon1)"
    - text: "For the Son of Man came to seek and to save the lost."
      source: "[Luke 19:10](https://www.bibleserver.com/ESV/Luke19)"
  closing: "Lost, found, restored: that is what a backup is for. And it is what God offers every person in Jesus Christ. We named the software after Onesimus because we believe that. The letter to Philemon is one page long; [read it](https://www.bibleserver.com/ESV/Philemon1)."

cta:
  title: "Try it next to your Bareos installation"
  text: "Onesimus is open source under the AGPL-3.0 and not yet as established as Bareos. Install it on a test system first; the way back to Bareos is one `systemctl` command."
  actions:
    - label: "Installation & operation"
      url: "/docs/install/"
      primary: true
    - label: "Star on GitHub"
      url: "https://github.com/Beerlesklopfer/Onesimus"
---
