---
title: "ACL matrix"
description: "Which console may use which job, client, storage, schedule, pool, FileSet, catalog and command: consoles side by side, catalog ACLs, new consoles and profile proposals."
weight: 7
---

**Tools → ACL matrix of the consoles...** shows the ACLs of every console side by side: one
column per console, one row per resource (jobs, clients, storages, schedules, pools, FileSets,
catalogs and commands). It needs the Onesimus Director, which provides the
[`.acl`](/docs/commands/dot-acl/) command.

{{< screenshot name="acl-matrix" alt="ACL matrix: resources by console" >}}

## Two tiers of ACLs

The ACL directives of the Console and Profile resources in the Director's configuration (the
*file ACL*) are the outer frame. The Onesimus Director adds a *catalog ACL* per console, stored
in the catalog, which can only narrow that frame further. What a console may use is what both
allow.

The cells:

| Mark | Meaning |
|---|---|
| ✓ | allowed |
| ✗ | denied by an entry with "!" |
| · | not allowed |
| ⊘ | allowed by the file ACL, narrowed by the catalog ACL |
| — | console locked (its catalog ACL cannot be read) |

A cell's tool tip says why; a console's tool tip shows its profiles, its catalog ACL and its
Where and Plugin Options ACLs. **Filter resources** narrows the rows, **Only rows where the
consoles differ** hides the rest, **Refresh** reads all ACLs again.

## Changing the catalog ACL

On the **Consoles** tab a double click (or Space) on ✓ denies the resource through the catalog
ACL; on ⊘ it allows it again. Changed cells are underlined until they are applied.
**Apply...** shows every change once (now / new per console and ACL type) and sends them after
your confirmation as `.acl set` / `.acl delete`; the first change the Director refuses stops the
rest. **Discard** forgets changes that were not applied. What the file ACL denies cannot be
allowed here; that is changed in the configuration.

## New consoles

**New console...** creates a Console resource on the Director with a name, a generated password
and a profile (`configure add console`). The profile's ACLs are the frame of the new console;
the matrix can narrow them further afterwards. Copy the password at once: whoever uses the
console needs it, and it cannot be read back. The console appears as a new column.

## Profile proposals

The **Profiles** tab shows the ACLs of the Profile resources. Profiles live in the
configuration files of the Director only, so the GUI never writes them: a double click turns a
cell in a *proposal*, and **Config text...** shows the new text of every changed profile.
**New profile...** adds a proposed profile as a new column, empty or as a copy of an existing
one.

Put the proposed text in place of the Profile resource in its file (the path shown is a
suggestion), check it with the Director's test (`-t`) and reload the Director; then
**Refresh** shows the new state. Comments of the old resource are not in the proposed text.
