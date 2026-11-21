---
title: "Connecting to a Director"
description: "The connection wizard, gRPC with TLS and certificate fingerprint, and BNET for Bareos Directors."
weight: 1
---

Onesimus keeps one or more **connection profiles**. Each profile names a Director, the
protocol, the console name and (optionally) the password. Connect with **File → Connect**
(Ctrl+O); **Reconnect** (Ctrl+R) opens the last used connection again.

## Two protocols

- **gRPC (Onesimus Director)**: the typed API of the Onesimus Director. It is always encrypted
  with TLS. The Director's certificate is confirmed on first use and then pinned; you log in
  with console name and password. gRPC also delivers push events: new lines of a running job
  log and job status changes arrive without polling. The default gRPC port is the BNET port
  plus 1000 (9101 + 1000 = 10101).
- **BNET (Bareos console protocol)**: the classic console protocol of Bareos, with TLS-PSK
  (recommended) or TLS with certificates. Use it for a plain Bareos Director, or as a fallback.
  Functions that need the Onesimus Director (changing schedules, the catalog ACL, the volume
  purge preview) tell you so when the connection cannot do them.

## The connection wizard

**File → Connection Wizard...** sets up a new profile step by step:

1. **How would you like to create the connection?** Create new connection from scratch, use a
   template from an existing connection, or import from a ZIP file (a Director configuration
   archive; you then pick the Director and Console from it).
2. **Where is your Bareos Director?** Onesimus Directors announce themselves in the local
   network (mDNS) and are listed under *Found in the network*; select one to fill in the data,
   or enter **Host**, **Port**, **Server OS** and **Protocol** by hand. For gRPC also the
   **gRPC port**.
3. **Enter your credentials**: Director name, console name and password. **Generate** creates a
   random password; the MD5 hash is shown for the Director configuration.
4. For BNET: **How should we authenticate?** TLS-PSK (recommended) or TLS with certificates
   (CA, client certificate and key, or a PFX file; *Generate Certificates...* and *Convert
   PEM/DER to PFX...* help).
5. **Server Configuration Preview**: the Console resource (and for gRPC the `Enable Grpc`
   line of the Director resource) to paste into the Director's configuration, plus a
   configuration for command line consoles (`bconsole`, `oconsole`). Copy to Clipboard, Save
   .conf or Save ZIP.
6. **Test Connection** connects once and reports each step.
7. **Name this connection**, optionally *Set as default* and *Connect now*.

{{< screenshot name="connect" alt="Connection wizard: choosing the Director and protocol" >}}

## The certificate fingerprint (gRPC)

On the first gRPC connection Onesimus shows the dialog **Trust server certificate?** with the
*SHA-256 fingerprint of the server certificate*. Compare it with the fingerprint of the
Director's gRPC certificate, obtained from the Director's administrator or read on the
Director itself, before you click **Trust certificate**. If the same fingerprint was announced
in the local network (mDNS), the dialog says so, but this is no proof of identity: any device in
the network can send such an announcement. A fingerprint that does not match the announcement
is shown as a warning.

If the certificate changes later, the dialog **Server certificate changed** shows the old and
the new fingerprint. This is expected after the certificate was regenerated on the Director;
otherwise someone may be intercepting the connection.

In **Settings → Connection** a profile shows its pinned fingerprint; **Forget certificate**
removes it, and the next connection asks again.

## My permissions

**Help → My Permissions** asks the Director which commands your console may use, grouped as
Backup & Restore, Job Control, Administration and Media, with the restore details (where=,
client=, replace=).
