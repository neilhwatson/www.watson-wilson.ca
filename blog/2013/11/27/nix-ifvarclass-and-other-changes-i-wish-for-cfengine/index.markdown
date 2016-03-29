---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
  post_type: post
  wp_menu_order: 0
  wp_post_id: 726
  wp_post_name: nix-ifvarclass-and-other-changes-i-wish-for-cfengine
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/nix-ifvarclass-and-other-changes-i-wish-for-cfengine/
date: 2013-11-27 12:00:15
status: published
tags:
  - cfengine
title: Nix ifvarclass and other changes I wish for CFEngine
---

I am frequently asked what I would change in CFEngine if I had the
power.

---

My high level answer is documentation. It is still too hard
for new comers to get started with CFEngine and experienced users do
not have access to detailed low level documentation. How does the
client server handshake work? How does cf_promises_validated work? How
do I read debugging output? I wish I could answer these questions using
official citations. There is an [effort underway](https://groups.google.com/forum/?fromgroups#!searchin/help-cfengine/documentation/help-cfengine/Tyvg3-7k-Lw/JTmMcaI_riQJ)
to improve documentation.

At a lower level the are other things I would change. Here are a few.

### Better redundancy ###

While file copies can fail over to multiple servers it is not possible
to bootstrap a host to multiple servers. This makes creating fail over
servers cumbersome because keys have to be exchanged using manual or
home grown automatic methods. There is an outstanding [ feature request](https://cfengine.com/dev/issues/3570)
for this.

### Whitespace in variables and classes ###

Variable expressions like

   ${meth[${i}][3]}
   
are an eyesore. I wish I
could use whitespace and rewrite them as

   ${meth[ ${i} ][ 3 ]}

Similarly class expressions like

   dmz_hosts.!(hosta|hostb|hostc)::

would be easier to read as

   dmz_hosts .! ( hosta|hostb|hostc )::

There is an [ open feature request](https://cfengine.com/dev/issues/1771) for this.

### Nix ifvarclass ###

While we are on the subject of classes, let's talk about ifvarclass. I
hate it. New users often wrongly think ifvarclass can define a class.
Truly ifvarclass exists only because this is illegal syntax:

    files:
       ${myclass}::
          "/path/to/promiser"
             yada => yada;

The above is so much clearer to the reader than the abomination that is
ifvarclass.

    files:
       "/path/to/promiser"
          ifvarclass => "${myclass}",
          yada       => yada;

Removing ifvarclass has been [ discussed](https://cfengine.com/bugtracker/view.php?id=894)
in the [past](https://groups.google.com/forum/?fromgroups#!searchin/help-cfengine/classes$20iteration$20ifvarclass$20watson/help-cfengine/jztMvL_V1g8/1hRDUSV2XSwJ),
but no changes are pending.
