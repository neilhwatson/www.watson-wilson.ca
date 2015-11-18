---
title: Linux networking cheatsheet
tags: linux, networking, cheatsheet
---

### Network calculation

<table>
<tr>
	<td>Show network info</td>
	<td><code>ipcalc 10.0.0.0/24<br></code>ipcalc 10.0.0.0/255.255.255.0`</td>
</tr>
<tr>
	<td>Segment network into 2 50 node subnets</td>
	<td><code>ipcalc 10.0.0.0/24 -s 50 50</code></td>
</tr>
</table>

### Net-tools versus Iptroute2

<table>
<tr>
	<td>List interfaces</td>
	<td><code>ip addr list</code><br><code>ifconfig -a</code><br><code>ip addr list eth0</code><br><code>ifconfig eth0</code></td>
</tr>
<tr>
	<td>Link status</td>
	<td><code>ip link list</code><br><code>ifconfig -a</code><br><code>ip link list eth0</code><br><code>ifconfig eth0</code></td>
</tr>
<tr>
	<td>Route table</td>
	<td><code>ip route</code><br><code>netstat -rn</code></td>
</tr>
<tr>
	<td>Adding routes</td>
	<td><code>ip route add default via 10.0.0.1</code></td>
</tr>
<tr>
	<td>Add/delete IP addresses</td>
	<td><code>ip addr add 10.0.0.2/24 dev eth0</code><br><code>ifconfig eth0 10.0.0.2 netmask 255.255.255.0</code><br><code>ip addr del 10.0.0.2/24 dev eth0</code><br><code>ifconfig eth0 del 10.0.0.2</code></td>
</tr>
</table>

### Linux Ethernet bonding

    # Loading module:
    # for Red Hat AS4, may work with other 2.6 Linuxes.
    install bond0 /sbin/modprobe bonding -o bond0 mode=0 miimon=100
    # for Red Hat AS3, may work with other 2.4 Linuxes.
    alias bond0 bonding
    options bond0 -o bonding mode=0 miimon=100

#### For Redhat distributions

    # ifcfg-ethx
    DEVICE=ethx
    USERCTL=no
    ONBOOT=yes
    MASTER=bond0
    SLAVE=yes
    BOOTPROTO=none

    # ifcfg-bond0
    DEVICE=bond0
    USERCTL=no
    ONBOOT=yes
    IPADDR=172.16.48.66
    NETMASK=255.255.255.0
    GATEWAY=172.16.48.1

### OSI model diagram
![OSI model diagram](/blog/2011/03/08/linux-network-cheatsheet/osi-model.gif)
