---
title: "AI assistants (MCP)"
description: "Connect an AI assistant to the Onesimus Director with oconsole --mcp: its own console, the profile assistant, the limits the Director enforces, stdio and HTTP."
weight: 6
---

`oconsole --mcp` offers the Director to an AI assistant over the
[Model Context Protocol](https://modelcontextprotocol.io) (MCP): typed tools such as `list_jobs`,
`status_director`, `show` or `configure_update` instead of free command lines. The connection to the
Director is the same as in the interactive console, over the classic console protocol or over gRPC
(`--grpc`).

The assistant does not get your rights. It logs in as a console of its own, and the Director decides
what that console may do.

<div class="note">

**No separate program, just configuration.** The assistant console is not an extra daemon or tool. It
is an ordinary `Console` resource in the Director's configuration, and the only thing that makes it
special is its name: **every console whose name ends in `-mcp` is an assistant console.** The Director
applies the assistant rules to it whichever client logs in with it (`oconsole --mcp`, `bconsole`, the
GUI), and nothing in the configuration can lift them. To set one up you add a `Console` and give it the
profile `assistant`; to remove it you delete that resource.

</div>

## The assistant's own console

`oconsole --mcp` always logs in as **`<name>-mcp`**, where `<name>` is the first `Console` in
`oconsole.conf` without that suffix (or the name given with `--name`). The password comes from the
`Console { Name = <name>-mcp; … }` resource in the same file, never from your own console.

If `oconsole.conf` has no such console (or names only `*UserAgent*`), `oconsole --mcp` does not
start: it exits with status 2 and prints the lines you need to add. It never falls back to your rights.
Without `--mcp`, oconsole logs in as your console as before, even if the `-mcp` console comes first in
the file.

`--name <x>-mcp --password …` selects an assistant console explicitly. oconsole recognises the suffix only in lower case: `--name X-MCP` counts as your own name and logs in as `X-MCP-mcp`.

## What the assistant may do

The rights are those of the `<name>-mcp` Console resource in the Director's configuration. For
this console there is the profile **`assistant`**:

- **Read:** `status`, `show`, `list`, `llist`, `messages`, `version`, `time`, `help`, `whoami`,
  `estimate` and the reading dot commands (`.jobs`, `.clients`, `.pools`, `.schedule`, …), including
  file browsing with `.bvfs_*` and `.ovfs_*`.
- **Change the configuration:** `configure`, that is add, change and delete Job, JobDefs, Schedule,
  Client, FileSet, Pool and Storage resources. Every change goes through the Director's checks, as it
  does from the GUI, and an assistant console cannot store a program the Director would run (see
  below).
- **Not:** `run`, `restore`, `purge`, `delete`, `cancel`, `label`, `reload`. These commands are not in
  the profile, so the Director refuses them.

The profile allows all Jobs, Clients, Storages, Schedules, Pools, FileSets and Catalogs. Narrow that in
the Console resource if the assistant should only see part of the installation.

### Granting more

If the assistant should be able to do more, add it **to that console only**, with the usual Bareos ACL
directives. The Console's own entries are checked first, then its profiles; as in Bareos the first
matching entry decides, and an entry with `!` denies.

```text
Console {
  Name = admin-mcp
  Password = "…"
  Profile = assistant
  Command ACL = run, restore      # in addition to the profile
  Where ACL = /srv/restore        # restores may only write here
}
```

For restores, the **`Where ACL`** limits where a restore may write on the client; a `where` outside
it is refused. The profile `assistant` has no `Where ACL`.

Destructive tools (`relabel_volume`, `prune`, `purge` except a dry run, `delete`, `truncate`, `configure_delete`) also
need the parameter `confirm: true`. Without it the tool asks the assistant to check with you first and
sends nothing to the Director.

## Limits no configuration lifts

For every console whose name ends in `-mcp` (the Director ignores upper and lower case), the Director refuses these commands,
whatever its ACLs and profiles say, even with `Command ACL = *all*`:

| Refused | Why |
|---|---|
| ACL changes (`.acl`, the catalog ACLs) | the assistant could lift its own limits |
| `sqlquery`, `.sql`, `query` | raw SQL: the only way to contents stored in the catalog |
| creating or changing consoles, profiles, users (`configure add console\|profile\|user`; `configure update/delete` do not know these types) | profiles and users are configuration resources that carry ACLs; an assistant creates and changes none |
| `RunScript`, `Run Before/After (Failed) Job`, `Client Run Before/After Job`, `Plugin`, `File = "\|…"`, `Write Bootstrap = "\|…"` in any configuration change | an assistant stores no program: a schedule would run it as the Director's user |

Everything else follows the console's ACLs. You change the assistant's rights from your own console
or in the configuration, never from the assistant's.

## The assistant cannot read your backups

No tool returns the contents of backed-up files:

- `ovfs_*`, `bvfs_*` and the `restore_tree_*` tools return **names and metadata** (paths, sizes,
  dates, versions), not file contents.
- A restore, if you grant one, is a job of the Director: the storage daemon sends the data to the
  **client**, where it is written to disk. Nothing comes back to the assistant; the tool returns the
  JobId.
- Raw SQL is refused (see above), so the assistant cannot read stored objects from the catalog either.

If the machine the assistant runs on is itself a backup client, a restore to that client lands on its
disk. Keep `restore` off for the assistant, or limit it with `Client ACL` and `Where ACL`.

## Setting it up

**1. The Console in the Director's configuration**, for example in
`bareos-dir.d/console/admin-mcp.conf`:

```text
Console {
  Name = admin-mcp
  Description = "AI assistant"
  Password = "a-long-random-password"
  Profile = assistant
}
```

You can also create it from the GUI or with `configure add console` from your own console. The
profile `assistant` must be in the configuration (`bareos-dir.d/profile/assistant.conf`).

**2. `oconsole.conf`** on the machine where the assistant runs: your console and the assistant's, each
with its own password.

```text
Director {
  Name = backup-dir
  Address = backup.example.org
  Password = "…"
}
Console {
  Name = admin
  Password = "…"
}
Console {
  Name = admin-mcp
  Password = "a-long-random-password"
}
```

`oconsole --mcp` then logs in as `admin-mcp`.

**3. Start the MCP server.**

Over **stdio** (the assistant starts oconsole as a local process):

```bash
oconsole --mcp            # read, write and restore tools, as far as the console's ACLs allow
oconsole --mcp --grpc     # the same over gRPC with TLS
oconsole --mcp --mcp-read-only   # only the read tools
```

Over **HTTP** (Streamable HTTP at `/mcp`, with a bearer token):

```bash
oconsole --mcp --mcp-http 127.0.0.1:9104
```

oconsole creates the token file at the first start (`~/.config/oconsole/mcp.token`, mode 0600; another
place with `--mcp-token-file`) and prints the URL and the file. `--mcp-host` adds a host name that the
server accepts in the HTTP `Host` header. **Over HTTP the production build offers only the read tools**,
whatever the console's ACLs allow; write tools over HTTP exist only in development builds.

Which tools the assistant sees depends on the transport; what it may actually do is always decided by
the Director, from the `-mcp` console.
