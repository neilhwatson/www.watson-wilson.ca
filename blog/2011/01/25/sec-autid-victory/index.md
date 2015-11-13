---
title: Victory over security audits
tags: cfengine, configuration management, infosec
---

<img style='float:right' alt='Winston Churchill give victory sign' src='/blog/2011/01/25/sec-autid-victory/ch-vic.gif'>

It’s vicious cycle. Resources are spent auditing hosts. Many more are
spent fixing all of the audit’s deficiencies. Then it’s back to
business as usual.  Time passes and hosts slowly degrade until the next
audit. Repeat.

---

It might take an hour to plan, schedule and fix each host. That’s 100 hours for
100 hosts. Audit twice a year and you’ve spent 200 hours. What if you have a
1000 hosts? Using CFEngine you can audit your hosts and fix deficiencies
automatically every day! Consider these typical policies.

1. Disable services that are not required.
1. No world writable files.
1. Limited guid and suid files.
1. Tighten file permissions in selected areas.
1. Harden services by applying custom configurations.
1. Ensure certain applications are not installed.

This can be a lot of manual work. Typically I see these policies applied at
build time using services like Jumpstart and Kickstart. But what happens after
hosts are built? Over time hosts will diverge from the ideal state set at build
time. CFEngine can manage all of these requirements automatically and
continuously. As CFEngine makes corrections and reports you’ll build a log of
information that the auditors will love. It will show compliance.

Go above and beyond with more advanced policies.

1. Monitor any file for content changes (e.g. Tripwire).
1. Monitor host performance for statistical anomalies.
1. Kill unwanted processes.
1. Change all local root passwords.
1. Disable local accounts and ssh keys.
1. Change any of these policies and all hosts are updated automatically!

Before you finish your next 300 page audit report defeat this cycle. Find out
how you turn audits from headaches into business as usual with CFEngine.
