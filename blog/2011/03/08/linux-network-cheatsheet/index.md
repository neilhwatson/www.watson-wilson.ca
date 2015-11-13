---
title: Linux networking cheatsheet
tags: linux, networking, cheatsheet
---

### Network calculation

Show network info  ipcalc 10.0.0.0/24
ipcalc 10.0.0.0/255.255.255.0
Segment network into 2 50 node subnets    ipcalc 10.0.0.0/24 -s 50 50

### Net-tools versus Iptroute2

List interfaces;;`ip addr list`<br>`ifconfig -a`
ip addr list eth0
ifconfig eth0
Link status    ip link list
ifconfig -a
ip link list eth0
ifconfig eth0
Route table    ip route
netstat -rn
Adding routes  ip route add default via 10.0.0.1
Add/delete IP addresses    ip addr add 10.0.0.2/24 dev eth0
ifconfig eth0 10.0.0.2 netmask 255.255.255.0
ip addr del 10.0.0.2/24 dev eth0
ifconfig eth0 del 10.0.0.2
Linux Ethernet bonding

# Loading module:
# for Red Hat AS4, may work with other 2.6 Linuxes.
install bond0 /sbin/modprobe bonding -o bond0 mode=0 miimon=100
# for Red Hat AS3, may work with other 2.4 Linuxes.
alias bond0 bonding
options bond0 -o bonding mode=0 miimon=100
# For Redhat distributions
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

Click for more Ethernet bonding information.
OSI model diagram
osi-model.gif

