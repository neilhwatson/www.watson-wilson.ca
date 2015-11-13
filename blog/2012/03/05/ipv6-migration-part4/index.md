---
title: IPv6 Migration part 4
tags: ipv6, networking
---

This website is now dual stacked to both IPV4 and IPV6. In part four of my IPV6
series I'll tell you what I learned during this migration.

---

This website consists of a web server, a database, an IP address and some DNS
records. Before we get to that you should know a little about hosting providers
and IPV6.

Not all hosting providers offer IPV6. Those that do offer IPV6 do not always
offer the full service. If you are shopping for an IPV6 ready hosting provider
here is a checklist.

1. How many IPV6 addresses do you get? Convention is that you should be
   provided with a /64 block. That is not a typo.
1. Is there a way to manage IPV6 PTR addresses?
1. Does the network allow dual stack IPV4 and IPV6 addressing?
1. What does this all cost?

My hosting provider, Glesys provided me with a \64 block of IPV6 addresses and
the ability to dual stack, all included in the price of my host. Sadly at this
time Glesys does not offer PTR record management for IPV6 addresses (they do
for IPV4 addresses). When I questioned Glesys about this I was told that they
plan to offer IPV6 PTR management in Q2 of 2012.

The next step is to know what software will work with IPV6. My site runs Debian
Squeeze at this time. The packages are quite dated. Apache easily works on IPV4
and IPV6 interfaces. Note that if you are using IP address virtual hosts, such
as for SSL, you will need separate entries for IPV4 and IPV6 addresses.

Originally this site ran using MySQL. Sadly the version that ships with Debian
Squeeze had IPV6 issues. The server seemed to work but the client did not.
Supposedly later version of MySQL work fine. Instead I used Postgresql with no
trouble.

The standard NTP daemon works fine dual stacked. However, IPV6 NTP servers are
hard to find. Pool.ntp.org lacks full IPV6 support. Only 2.pool.ntp.org appears
to have working IPV6 addresses at this time.

Those who know me will expect my report on Cfengine and IPV6. It works dual
stacked and exclusively with IPV6 but not without an issue. You can see my
findings here.

OpenSSH worked dual and single IPV6 stacked without issue.

When dealing directly with Linux I found no IPV6 issues including Ethernet
bonding, network bridges and KVM virtualization. Do be aware that IPV6 allows
for addresses to be auto configured. I did see this happen when routers outside
of my control advertised address allocation. The solution for me was to
make change in sysctl:

    net.ipv6.conf.all.autoconf=0
    net.ipv6.conf.all.accept_ra=0
    net.ipv6.conf.default.autoconf=0

This instructs the kernel to ignore any attempts to auto-configure.

Remember from previous parts in this series that you'll need separate IPV6
firewall rules. With Linux, IPV6 traffic is filtered via ip6tables. This is
virtually identical to the standard iptables for IPV4 networking. Wrappers like
Fwbuilder and Shorewall both support IPV6.

