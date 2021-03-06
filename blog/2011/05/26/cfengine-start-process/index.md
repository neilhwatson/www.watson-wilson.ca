---
title: Starting processes using Cfengine
tags: cfengine, cfengine cookbook, configuration management
---

### Problem

You want to ensure that a process is running.

---

### Solution

This promise searches the process table for the regular expression “snmpd”. If
this is not found the class “start_snmpd” is set. This class being set causes
the command “/etc/init.d/snmpd start” command to be run.

Beware that “snmpd” is a regular expression. It may match more than you would
expect.

    bundle agent recipe {

      processes:

        "snmpd"
           handle => "run_snmpd",
           comment => "Promise that snmpd is running",
           restart_class => "start_snmpd";

      commands:

        start_snmpd::
          "/etc/init.d/snmpd start",
          handle => "start_snmpd",
          comment => "Start snmpd when required.";
    }

Now the output.

    root@venus:/home/neil/.cfagent/inputs# ps -ef|grep snmpd

    root@venus:/home/neil/.cfagent/inputs# cf-agent -IKf ./recipe.cf 
    -> (warning) Promise snmpd kills then restarts - never strictly
    converges
    Promise (version not specified) belongs to bundle 'recipe' in file
    './recipe.cf' near line 16
    Comment: Promise that snmpd is running
    -> Making a one-time restart promise for snmpd
    -> Executing '/etc/init.d/snmpd start'
    ...(timeout=-678,owner=-1,group=-1)
    Q: "...it.d/snmpd star":  * Starting network management services:
    I: Last 1 QUOTed lines were generated by promiser "/etc/init.d/snmpd
    start"
    -> Completed execution of /etc/init.d/snmpd start

    root@venus:/home/neil/.cfagent/inputs# ps -ef|grep snmpd
    snmp     26808     1  2 09:24 ?        00:00:00 /usr/sbin/snmpd -Lsd
    -Lf /dev/null -u snmp -g snmp -I -smux -p /vars:/run/snmpd.pid
127.0.0.1

### Gravy

Process matching can be very sophisticated if you choose. Beyond regular
expression matching you can also match processes based on count range, memory
usage and more. See the Cfengine reference guide for more information.

