---
title: A brief overview of Red Hat Enterprise Virtualization
tags: rhev, vitualization, kvm
---

Red Hat Enterprise Virtualization is a fairly new product offering from Red
Hat. Red Hat acquired RHEV when they purchased Qumranet in September 2008.
Qumranet created KVM when they created a Windows desktop virtualization product
. RHEV is the evolution of that product and in the hands of Red Hat it offers a
virtualization solution for both desktops and servers, Linux and Windows.

---

The Windows roots of RHEV mean that currently the command and control manager
must run on a Windows server. Red Hat is working hard to eliminate the need for
Windows. They plan to create a portable all Java command and control service.
This will be open source. It is important to keep these roots in mind while
exploring and testing RHEV. These roots explain why things work the way they
do.

At its heart RHEV is a cluster. Nodes, called hosts or hypervisors, host KVM
virtual machines, called guests. A separate manager server, currently a
Microsoft Windows service, acts as the command and control centre. Guests can
be made highly available so that they are automatically migrated from host to
host in the event of resource failure. In essence the virtual hardware is made
highly available.

The manager divides guests, hosts, clusters, storage and network resources into
logical containers called data centres. This allows resources, such as separate
groups of development and QA guests, to be logically separated.

As with any virtualization solution guests share the same hardware. In the case
of network interfaces, bandwidth can be a bottleneck. While Linux based
Ethernet bonding is available there are limits. Typically a guest connects to a
network interface via a network bridge. There are incompatibilities between
certain types of Ethernet bonding and network bridges. This limits the number
of bonding modes available. There are hardware solutions to work around this.

In addition to the Windows dependency the manager itself is a single point of
failure. Should it go down guests will continue to run but will not be highly
available.

Highly available guest often give a false sense of security. Such guests are
safe from hardware failure but not software failure. Should a guest hosting an
Apache service have Apache fail the guest will not migrate or fix itself.
Software clustering is still needed. Red Hat is working on making their Cluster
Suite RHEV aware so that a cluster running on guests could fence themselves
using RHEV.

During my months of testing I did uncovered some bugs. Red Hat provided me with
excellent high level support and through this collaboration we were able make
significant improvements in RHEV. You can learn more about RHEV at Red Hat or
contact me for help on evaluation and implementation.

