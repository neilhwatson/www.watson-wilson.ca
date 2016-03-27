---
author: nwatson
data:
  categories:
    - content: security
      domain: category
      nicename: security
  post_type: post
  wp_menu_order: 0
  wp_post_id: 137
  wp_post_name: its-time-to-rethink-anti-virus
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/its-time-to-rethink-anti-virus/
date: 2013-05-09 10:47:41
status: published
tags:
  - anti-virus
  - security
  - virus
title: It's time to rethink Anti-virus
---
Anti-virus is always a step behind. It's a good revenue stream for
anti-virus software makers. For end users it's a race to the horizon.
--- Virus pattern recognition only works on patterns that have been
discovered, researched, and added to the pattern database. Recent
anti-virus pattern databases now detect more than 22 million patterns.
Is it a wonder that anti-virus software kills computer performance? [1](http://www.symantec.com/security_response/definitions/certified/)

The impossible pattern race is bad. The system crippling false alarms
are worse. In the recent past most major anti-virus tools have crippled
corporate and person computers by mistakenly quarantining a Windows
system or application file.[1](http://www.theregister.co.uk/2013/02/06/kaspersky_win_xp_update_snafu/),
[2](http://www.theregister.co.uk/2012/09/20/sophos_auto_immune_update_chaos/),
[3](http://www.pcmag.com/article2/0,2817,2362926,00.asp)

I'm not a computer virus expert. But there has to be a better way to
protect us. I can think of some.

White listing defines what files are allowed to execute on a system.
Any file not on the white list is denied execution. For most corporate
workstations this is ideal. A few hundred executable files are white
listed and the workstation becomes secure. More generic workstations,
like home computers, require longer lists. This is not insurmountable.
I'd rather subscribe to a ten thousand item white list than a 22
million item black list. The look ups will be shorter and new threats
do not get an automatic free pass.

Mandatory access control. SELinux is the well known form of MAC. MAC is
similar to white listing but goes further. Programs are not just denied
execution rights. Their rights to access the rest of the system are
explicitly defined. For example, a web browser may be allowed to touch
printing, browser cache, and other relevant files. Anything else is
denied, by default. Viruses cannot run wild on the system because
they've not been defined to be allowed to do so. Set up and maintenance
of such a systems is no small task. Neither is maintaining a growing
list of 22 million virus definitions.

I'm not a computer virus expert. But the arms race between new viruses
and new definitions can never be won. It's time for a new approach.
Consider that the next time your computer is churning another
anti-virus disk scan.
