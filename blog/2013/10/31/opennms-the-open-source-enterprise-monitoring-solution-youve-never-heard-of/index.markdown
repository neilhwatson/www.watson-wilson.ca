---
author: nwatson
data:
  categories:
    - content: monitoring
      domain: category
      nicename: monitoring
    - content: opennms
      domain: category
      nicename: opennms
  post_type: post
  wp_menu_order: 0
  wp_post_id: 707
  wp_post_name: opennms-the-open-source-enterprise-monitoring-solution-youve-never-heard-of
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/opennms-the-open-source-enterprise-monitoring-solution-youve-never-heard-of/
date: 2013-10-31 12:00:34
status: published
tags:
  - monitoring
  - opennms
title: "OpenNMS: the open source enterprise monitoring solution you've never heard of."
---
[![opennms logo](/static/images/opennms.png)](http://www.opennms.org)

Begun in 1999, [OpenNMS](http://www.opennms.org) an enterprise scale
monitoring solution written in Java, with a Postgresql database and
configured with XML files. --- Because it uses SNMP OpenNMS can monitor
most servers, network gear, and other appliances without needing a
custom agent. Its [feature list](http://www.opennms.org/wiki/Features_List)
is impressive.

---

### When monitoring, less is more. ###

I've seen a lot of monitoring products in production over the years,
both proprietary and open source. Most suffer from information overload
because folks set out trying to monitoring everything. They believe
they can catch all problems early, but this never works. Staff are
inundated with so many alerts, most of them false, that searching for
legitimate ones becomes a full time job, or worse, alerts are
intentionally ignored. If you are monitoring or plan to start, start
small, very small, and grow slowly.

### What I like about OpenNMS ###

  * No message storms. OpenNMS has message correlation, multiple
    messages meaning the same thing result in only one alert. A feature
    called critical path ensures that multiple and different messages
    result in only one alert. For example, if a router is identified as
    a critical path, OpenNMS will not generate a storm of alerts for
    all hosts behind the router if it goes down.

  * Commercial support. OpenNMS creators offer paid support and
    consulting services. For do-it-yourselfers, there is a [mailing
    lists](http://www.opennms.org/wiki/Mailing_lists), a [wiki](http://www.opennms.org/wiki/Tutorial),
    and the #opennms IRC channel at [Freenode](http://freenode.net).

  * Scale and stability. OpenNMS was designed from day one to scale to
    thousands of nodes at low cost.

  * Simple to install. I was able to install and run OpenNMS on a small
    virtual host without difficulty.

  * SNMP. OpenNMS is not limited to servers supported by a custom
    agent. By using SNMP, OpenNMS can support servers, network gear,
    storage gear, UPS gear, and so much more. For those of you who
    think that SNMP is long in the tooth, look at SNMP version 3, with
    more functionality and [full encryption](https://en.wikipedia.org/wiki/Simple_Network_Management_Protocol#Version_3).

### What I don't like about OpenNMS ###

  * I'm not a fan Java. I've been disappointed by many Java
    applications over the years, but I had no such disappointment with
    OpenNMS. The installation process is easy. One problem I did
    encounter, with no solution yet, is that OpenNMS does not start a
    boot, no matter what I tried. I resorted to having CFEngine promise
    to keep it running.

  * Editing XML files sucks. XML was not made for people to ready
    continuously.

  * Merging XML files for upgrades sucks more. When I upgraded OpenNMS
    I was faced with the frustrating exercise of merging the upgrades
    with my preexisting changes.

  * Confusing documentation. The wiki is often outdated or incomplete.
    There is a [book](https://github.com/OpenNMS/opennmsbook), but it
    was not easy to find.

Every monitoring product I've worked with has things I don't like, so
don't think I'm singling OpenNMS out. We are now using OpenNMS to
monitor our gear at Evolve and OpenNMS is at the top of my list for any
future monitoring projects.
