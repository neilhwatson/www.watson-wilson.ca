---
title: IPv6 Migration part 5
tags: ipv6, networking
---

<img style='float:right' alt='Success with IPv6' src='/static/images/ipv6-success-kid.jpg' width='300' >

My email server now functions on both IPV4 and IPV6 networks. Postfix is IPV6
ready but, the configuration needed some adjustments.

---

In places like mynetworks, found in main.cf, IPV6 addresses must be enclosed in
square brackets. This does not include the netmask. For example: [::1]/128

In main.cf Postfix is told to use IPV6 using inet_protocols. Set this to all
and Postfix will listen to IPV4 and IPV6 interfaces.

For more information about Postfix and IPV6 see the
[Postfix](http://www.postfix.org/) web page

In fact a lot of configuration files have special rules to accommodate IPV6
addresses because IPV6 syntax was not a consideration when the configuration
syntax was first invented. Read configuration documentation carefully.

