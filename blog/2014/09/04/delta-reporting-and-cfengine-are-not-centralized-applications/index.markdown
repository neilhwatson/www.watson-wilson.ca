---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
    - content: delta reporting
      domain: category
      nicename: delta-reporting
  post_type: post
  wp_menu_order: 0
  wp_post_id: 999
  wp_post_name: delta-reporting-and-cfengine-are-not-centralized-applications
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/delta-reporting-and-cfengine-are-not-centralized-applications/
date: 2014-09-04 11:30:18
status: published
tags:
  - cfengine
  - delta reporting
title: Delta Reporting and CFEngine are NOT centralized applications
---


[Delta Reporting](https://github.com/evolvethinking/delta_reporting)
and CFEngine are not centralized applications. Yes, I do describe DR as
centralized reporting for CFEngine, but that is a simplistic view for
easy consumption. Both CFEngine and Delta Reporting are far more
flexible.

---

[caption id="attachment_996" align="alignnone" width="163"][![CFEngine typical centralized architecture](/static/images/client-server-centralized.png)](/static/images/client-server-centralized.png)
CFEngine typical centralized architecture[/caption]

A typical installation of CFEngine has all agent hosts connecting to a
single CFEngine server, but did you know that you can do more? In a DMZ
you can deploy a *DMZ mirror* CFEngine server to act as a proxy between
the DMZ host agents and the internal CFEngine server. The mirror is a
server for DMZ agents and is itself an agent of the internal server. In
isolated networks you can deploy additional CFEngine servers to support
local agent hosts.

[caption id="attachment_997" align="alignnone" width="430"][![CFEngine decentralized architecture](/static/images/client-server-decentralized.png)](/static/images/client-server-decentralized.png)
CFEngine decentralized architecture[/caption]

[Delta Reporting's](https://github.com/evolvethinking/delta_reporting)
promise outcome and class log can be similarly distributed. Each
CFEngine server loads DR's data to a database that can be local or
remote. Multiple CFEngine servers can share the same DR database, and
you can have isolated DR instances in high security networks.

[caption id="attachment_998" align="alignnone" width="430"][![Delta Reporting decentralized architecture](/static/images/delta-reporting-decentralized.png)](/static/images/delta-reporting-decentralized.png)
Delta Reporting decentralized architecture[/caption]

It is no exaggeration that CFEngine is decentralized and scales
enormously, and [Delta Reporting](https://github.com/evolvethinking/delta_reporting)
was designed the same way.
