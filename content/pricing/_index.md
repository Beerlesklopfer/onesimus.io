---
title: "Pricing"
description: "1 TB per month free for every household. Early-bird prices for everyone who reserves before v1.0.0."
layout: "pricing"
label: "Pricing"
headline: "1 TB a month is free.<br>Pay only when you need more."
subtitle: "Onesimus is open source under the AGPL-3.0. Every edition has every feature; the editions differ only in how much the Director may write per month, and in support. Prices per Director and year: Home Plus including VAT, the business editions plus VAT."
badge: "Early bird"
earlybird: "**Early bird until v1.0.0:** reserve a licence by e-mail now and keep the early-bird price for as long as your subscription runs without a break. There is nothing to pay before v1.0.0 is released; you receive your licence file then."
tiers:
  - name: "Free"
    price: "0 €"
    limit: "1 TB written per month"
    desc: "For households: photos, documents and a few computers, with a monthly Full and daily Incrementals."
    features:
      - "Every feature of the GUI and the Rust stack"
      - "Bareos stays your way back"
      - "Community support on GitHub"
    button: "Install"
    url: "/docs/install/"
  - name: "Home Plus"
    price: "29 €"
    per: "/ year incl. VAT"
    regular: "early bird, later <s>39 €</s>"
    limit: "5 TB written per month"
    desc: "For large media collections and homelabs."
    features:
      - "Everything in Free"
      - "Signed licence file"
      - "Support by e-mail"
    button: "Reserve"
    url: "mailto:contact@onesimus.io?subject=Onesimus%20Home%20Plus%20early%20bird"
    featured: true
  - name: "Small Business"
    price: "199 €"
    per: "/ year + VAT"
    regular: "early bird, later <s>290 €</s>"
    limit: "25 TB written per month"
    desc: "For offices, practices and small companies."
    features:
      - "Everything in Home Plus"
      - "Help with migrating from Bareos"
      - "Support by e-mail, answered on working days"
    button: "Reserve"
    url: "mailto:contact@onesimus.io?subject=Onesimus%20Small%20Business%20early%20bird"
  - name: "Business"
    price: "690 €"
    per: "/ year + VAT"
    regular: "early bird, later from <s>990 €</s>"
    limit: "unlimited"
    desc: "For companies that need agreed response times."
    features:
      - "Everything in Small Business"
      - "Agreed response times"
      - "Help with installation and operation"
    button: "Reserve"
    url: "mailto:contact@onesimus.io?subject=Onesimus%20Business%20early%20bird"
---

## Questions

### What counts towards the limit?
The bytes the Director writes in a calendar month: every Full, Differential and Incremental job with its
whole size. Restores never count. The GUI shows the month's usage in its status bar.

### What happens at the limit?
From v1.0.0 the free edition starts no new backup jobs once the month's terabyte is written; running
jobs finish, restores always work, and on the first of the month the count starts again. Your data is
never deleted.

### Why a limit, if the code is open?
Onesimus is free software under the AGPL-3.0, and it stays that way. The limit is part of the official
packages; the licence pays for signed packages, updates and support.

### What if my subscription ends?
The Director falls back to the free edition with its terabyte per month. Nothing is lost, and every
backup can still be restored.
