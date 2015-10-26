---
title: Heartbeat 2 cheatsheet
tags: cluster, heartbeat, cheatsheet
---

Commands
List cluster resources.    crm_resource -L
Dump cluster configuration as xml to stdout.    cibadmin -Q
Place node in standby (maintenance mode). Technically this is adding the standby property.   crm_standby -U <hostname> -v true
Place local node in standby.  crm_standby -v true
Place node online or remove the standby property.  crm_standby -D -U <hostname>
Place local node online or remove standby property.   crm_standby -D
View cluster status. One time to stdout.  crm_mon -1
View cluster status. Refresh every 3s.    crm_mon -i3
One line simple output.    crm_mon -s
Show inactive resources.   crm_mon -r
Stop resource.    crm_resource -r <resource> -p target_role -v stopped
Start resource.   crm_resource -r <resource> -p target_role -v started
Clear failed resource.  crm_resource -C -H <host> -r <resource>
Query running cluster for current state (STDOUT).  cibadmin -Q --obj_type resources
Other resources.  XML definition
