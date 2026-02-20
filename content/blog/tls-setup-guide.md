---
title: "Setting Up TLS Certificates for Bareos with Onesimus"
date: 2026-02-15
author: "Beerlesklopfer"
description: "A practical guide to configuring TLS-PSK and X.509 certificate authentication in Onesimus."
tags: ["tutorial", "tls", "security", "bareos"]
---

Securing your Bareos Director connection is essential — especially when managing backups across networks. Onesimus supports both TLS-PSK (Pre-Shared Key) and full X.509 certificate authentication out of the box.

## TLS-PSK: The Quick Path

If you already have a `bconsole.conf` with a PSK password, Onesimus can use it directly. In the Connection Wizard, select **TLS-PSK** and enter your Director address, port, and the shared password. Onesimus handles the CRAM-MD5 handshake and TLS negotiation automatically.

## X.509 Certificates: Enterprise-Grade Security

For production environments, certificate-based authentication is recommended. You'll need:

- A **CA certificate** (the same one your Director trusts)
- A **client certificate** signed by that CA
- The corresponding **private key**

Onesimus includes built-in certificate generation scripts for testing:

```bash
# Linux/macOS
./create-bacula-certs.sh

# Windows
.\create-bacula-certs.ps1
```

Then point the Connection Wizard to your certificate files, and you're connected.

## Windows PFX Support

On Windows, Onesimus natively supports `.pfx` files — combined certificate and key bundles that are common in Windows environments. No need to split them into separate PEM files.

## Connection Profiles

Once configured, save your connection as a **profile**. Onesimus lets you manage multiple Director connections and switch between them — perfect for admins managing staging and production environments.

## Troubleshooting

Enable **Debug Logging** in Settings → Advanced to see the full TLS handshake. The log shows every step of the authentication process, making it easy to diagnose certificate issues.
