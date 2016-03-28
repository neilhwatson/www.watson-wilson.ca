---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
    - content: monitoring
      domain: category
      nicename: monitoring
    - content: opennms
      domain: category
      nicename: opennms
  post_type: post
  wp_menu_order: 0
  wp_post_id: 508
  wp_post_name: polling-cfengine-with-opennms
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/polling-cfengine-with-opennms/
date: 2013-07-19 11:00:28
status: published
tags:
  - cfengine
  - monitoring
  - opennms
title: Polling CFEngine with Opennms
---


In the coming months I'm going to work with and write about [Opennms](http://www.opennms.org).
Started in 1999, Opennms is a mature, open source, enterprise scale
monitoring system. --- In this first installment I offer you a way to
monitor CFEngine's cf-serverd on any host. Since cf-agent typically
promises that cf-serverd running, knowing that cf-serverd is running
tells you that the agent is working.

In my install, Opennms keeps most of its configuration files in
/etc/opennms. First edit capsd-configuration.xml, adding the following
section.

    <protocol-plugin protocol="Cfengine" class-name="org.opennms.netmgt.capsd.plugins.TcpPlugin" scan="on">
       <property key="port" value="5308" />
       <property key="timeout" value="2000" />
       <property key="retry" value="1" />
    </protocol-plugin>

Second, edit poller-configuration.xml adding these sections.

    <service name="Cfengine" interval="300000" user-defined="false" status="on">
       <parameter key="retry" value="2" />
       <parameter key="timeout" value="3000" />
       <parameter key="port" value="5308"/>
       <parameter key="rrd-repository" value="/opt/opennms/share/rrd/response" />
       <parameter key="rrd-base-name" value="cfengine" />
       <parameter key="ds-name" value="cfengine" />
    </service>
    
    <monitor service="Cfengine" class-name="org.opennms.netmgt.poller.monitors.TcpMonitor" />

Restart Opennms, then you can manually rescan hosts immediately, or
wait for Opennms to do so in it's own time, usually overnight.

[caption id="attachment_521" width="640"][![screen shot of Opennms reporting CFEngine availability](/static/images/opennms-cfengine-polling.png)](/static/images/opennms-cfengine-polling.png)
Opennms reporting CFEngine availability. Notice anything shiny and
new?[/caption]

Sharp viewers will notice that my node is an IPV6 node. Opennms
supports IPV6, an important considering in the coming years.
