---
title: Banning processes using Cfengine
tags: cfengine, cfengine cookbook, configuration management, infosec
---

Problem

You want to prevent certain processes from running.

Solution

In formal Cfengine parlance this promise ensures that there are zero instances of processes running that match the regular expression “snmpd”. If such processes are found a term signal is sent. If that signal is ignored a kill signal is sent.

Be careful because “snmpd” is a regular expression. It may match more than you think. Our intent is to look for a running instance of snmpd but this would also match “vim snmpd.conf”.

bundle agent recipe {

  processes:

    "snmpd" signals => { "term", "kill" },
       handle => "Banned_procs",
       comment => "Term process or kill if term fails",
       process_count => banned; 
}

body process_count banned {
  match_range => irange("0","0");
}

Below we see an snmpd process before the agent is run. We see the output of the agent and then we see no snmpd process after the agent is finished.

root@venus:/home/neil/.cfagent/inputs# ps -ef|grep snmp
snmp     26481     1  0 09:05 ?        00:00:00 /usr/sbin/snmpd -Lsd -Lf
/dev/null -u snmp -g snmp -I -smux -p /vars:/run/snmpd.pid 127.0.0.1

root@venus:/home/neil/.cfagent/inputs# cf-agent -IKf ./recipe.cf 
!! Process count for 'snmpd' was out of promised range (1 found)
I: Report relates to a promise with handle "Banned_procs"
I: Made in version 'not specified' of './recipe.cf' near line 16
I: Comment: Term process or kill if term fails

-> Signalled 'term' (15) to observed process match '26481'

root@venus:/home/neil/.cfagent/inputs# ps -ef|grep snmp



