---
title: Heartbeat 2 cheatsheet
tags: cluster, heartbeat, cheatsheet
---

### Commands

<table>
<tr>
	<td>List cluster resources.</td>
	<td>`crm_resource -L`</td>
</tr>
<tr>
	<td>Dump cluster configuration as xml to stdout.</td>
	<td>`cibadmin -Q`</td>
</tr>
<tr>
	<td>Place node in standby (maintenance mode). Technically this is adding the standby property.</td>
	<td>`crm_standby -U <hostname> -v true`</td>
</tr>
<tr>
	<td>Place local node in standby.</td>
	<td>`crm_standby -v true`</td>
</tr>
<tr>
	<td>Place node online or remove the standby property.</td>
	<td>`crm_standby -D -U <hostname>`</td>
</tr>
<tr>
	<td>Place local node online or remove standby property.</td>
	<td>`crm_standby -D`</td>
</tr>
<tr>
	<td>View cluster status. One time to stdout.</td>
	<td>`crm_mon -1`</td>
</tr>
<tr>
	<td>View cluster status. Refresh every 3s.</td>
	<td>`crm_mon -i3`</td>
</tr>
<tr>
	<td>One line simple output.</td>
	<td>`crm_mon -s`</td>
</tr>
<tr>
	<td>Show inactive resources.</td>
	<td>`crm_mon -r`</td>
</tr>
<tr>
	<td>Stop resource.</td>
	<td>`crm_resource -r <resource> -p target_role -v stopped`</td>
</tr>
<tr>
	<td>Start resource.</td>
	<td>`crm_resource -r <resource> -p target_role -v started`</td>
</tr>
<tr>
	<td>Clear failed resource.</td>
	<td>`crm_resource -C -H <host> -r <resource>`</td>
</tr>
<tr>
	<td>Query running cluster for current state (STDOUT).</td>
	<td>`cibadmin -Q --obj_type resources`</td>
</tr>
</table>
