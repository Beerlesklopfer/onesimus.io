---
title: "Introducing Onesimus: A Modern UI for Bareos"
date: 2026-02-08
author: "Beerlesklopfer"
description: "Why we built a modern Qt6 management interface for Bacula and Bareos backup systems."
tags: ["announcement", "bareos", "open-source"]
---

Managing backups with Bareos or Bacula typically means staring at bconsole output or navigating the built-in WebUI. Both get the job done, but neither feels like a tool built for 2026.

**Onesimus** changes that. It's a native, cross-platform desktop application built with Qt6 and C++17 that gives you a clear, modern view of your entire backup infrastructure.

## Why a desktop app?

Web UIs are convenient, but a native application gives you real advantages for infrastructure management: faster response times, better keyboard shortcuts, native OS integration, and the ability to work offline or behind strict firewalls where web access to the Director might not be available.

## What's in v0.1.0?

The first alpha release includes:

- **Job Management** with advanced filters, statistics, and export
- **Client Overview** with a guided wizard for adding new clients
- **Storage & Volume** management with pool and device status
- **Schedule Viewer** with weekly planner
- **TLS/SSL** with PSK and X.509 certificate support
- **Connection Profiles** for managing multiple Directors
- **6 Languages** with automatic detection

## What's next?

We're working on live job monitoring, restore wizards, and the Enterprise features that larger teams need. Check out the [roadmap on GitHub](https://github.com/Beerlesklopfer/Onesimus) to see what's coming.

## Get involved

Onesimus is open source under the MIT license. We welcome contributions — whether it's code, translations, bug reports, or just feedback. Head over to [GitHub](https://github.com/Beerlesklopfer/Onesimus) to get started.
