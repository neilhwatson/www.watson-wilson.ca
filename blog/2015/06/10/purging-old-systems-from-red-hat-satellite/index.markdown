---
author: nwatson
data:
  categories:
    - content: perl
      domain: category
      nicename: perl
    - content: redhat
      domain: category
      nicename: redhat
    - content: satellite
      domain: category
      nicename: satellite
  post_type: post
  wp_menu_order: 0
  wp_post_id: 1099
  wp_post_name: purging-old-systems-from-red-hat-satellite
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/purging-old-systems-from-red-hat-satellite/
date: 2015-06-10 09:04:40
status: published
tags:
  - perl
  - redhat
  - satellite
title: Purging old systems from Red Hat Satellite
---

I've been involved in a Red Hat Satellite (version 5) project recently.
---

The nature of the client's work meant that most the systems
registered with Satellite were reinstalled regularly. This can lead to
duplicate systems residing in Satellite's database and its collection
of Cobbler files. With the aid of Red Had I wrote some scripts that use
the Satellite and Cobbler API to delete old systems from Satellite and
Cobbler. I can't share the scripts, but I can show you some useful
snippets from what I learned. The scripts are in Perl so I include the
snippets in my personal Perl [cheatsheet](https://github.com/neilhwatson/nustuff/blob/master/perl/cheatsheet.pod#satellite-snippets-including-cobbler)
