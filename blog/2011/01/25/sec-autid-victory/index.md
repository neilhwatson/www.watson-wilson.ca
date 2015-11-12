---
title: Victory over security audits
tags: cfengine, configuration management, infosec
---

It’s vicious cycle. Resources are spent auditing hosts. Many more are spent
fixing all of the audit’s deficiencies. Then it’s back to business as usual.
Time passes and hosts slowly degrade until the next audit. Repeat.

---

It might take an hour to plan, schedule and fix each host. That’s 100 hours for 100 hosts. Audit twice a year and you’ve spent 200 hours. What if you have a 1000 hosts? Using Cfengine you can audit your hosts and fix deficiencies automatically every day! Consider these typical policies.

    Disable services that are not required.
    No world writable files.
    Limited guid and suid files.
    Tighten file permissions in selected areas.
    Harden services by applying custom configurations.
    Ensure certain applications are not installed.

This can be a lot of manual work. Typically I see these policies applied at build time using services like Jumpstart and Kickstart. But what happens after hosts are built? Over time hosts will diverge from the ideal state set at build time. Cfengine can manage all of these requirements automatically and continuously. As Cfengine makes corrections and reports you’ll build a log of information that the auditors will love. It will show compliance.

Go above and beyond with more advanced policies.

    Monitor any file for content changes (e.g. Tripwire).
    Monitor host performance for statistical anomalies.
    Kill unwanted processes.
    Change all local root passwords.
    Disable local accounts and ssh keys.
    Change any of these policies and all hosts are updated automatically!

Before you finish your next 300 page audit report defeat this cycle. Find out how you turn audits from headaches into business as usual with Cfengine.
