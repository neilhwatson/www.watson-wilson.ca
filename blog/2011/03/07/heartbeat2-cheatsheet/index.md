---
title: Heartbeat 2 cheatsheet
tags: cluster, heartbeat, cheatsheet
---

### Commands

<table>
<tr>
	<td>List cluster resources.</td>
	<td><code>crm_resource -L</code></td>
</tr>
<tr>
	<td>Dump cluster configuration as xml to stdout.</td>
	<td><code>cibadmin -Q</code></td>
</tr>
<tr>
	<td>Place node in standby (maintenance mode). Technically this is adding the standby property.</td>
	<td><code>crm_standby -U <hostname> -v true</code></td>
</tr>
<tr>
	<td>Place local node in standby.</td>
	<td><code>crm_standby -v true</code></td>
</tr>
<tr>
	<td>Place node online or remove the standby property.</td>
	<td><code>crm_standby -D -U <hostname></code></td>
</tr>
<tr>
	<td>Place local node online or remove standby property.</td>
	<td><code>crm_standby -D</code></td>
</tr>
<tr>
	<td>View cluster status. One time to stdout.</td>
	<td><code>crm_mon -1</code></td>
</tr>
<tr>
	<td>View cluster status. Refresh every 3s.</td>
	<td><code>crm_mon -i3</code></td>
</tr>
<tr>
	<td>One line simple output.</td>
	<td><code>crm_mon -s</code></td>
</tr>
<tr>
	<td>Show inactive resources.</td>
	<td><code>crm_mon -r</code></td>
</tr>
<tr>
	<td>Stop resource.</td>
	<td><code>crm_resource -r <resource> -p target_role -v stopped</code></td>
</tr>
<tr>
	<td>Start resource.</td>
	<td><code>crm_resource -r <resource> -p target_role -v started</code></td>
</tr>
<tr>
	<td>Clear failed resource.</td>
	<td><code>crm_resource -C -H <host> -r <resource></code></td>
</tr>
<tr>
	<td>Query running cluster for current state (STDOUT).</td>
	<td><code>cibadmin -Q --obj_type resources</code></td>
</tr>
</table>
