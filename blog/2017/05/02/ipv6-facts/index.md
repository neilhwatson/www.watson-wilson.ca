---
title: Beginner facts about IPv6
tags: networking, ipv6
---

<img style='float:right' alt='Success with IPv6' src='/static/images/ipv6-success-kid.jpg' width='150' >

- This is an IPv4 address in hexadecimal: FF.FF.FF.FF (255.255.255.255).

- This is an IPv6 address, which are always in hexadecimal: FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF. See the difference in size?

- *Everyone gets public* IPv6 addresses. There is no need for NAT.

- I'll say it again, there is a *no need for NAT*. Firewalls still work, but don't use NAT.

- No NAT means end to end communication with less complexity. Rejoice!

- You will be assigned a large subnet of public IPv6 addresses. No more rationing a handful of public IPs.

- The smallest typical [subnet](https://en.wikipedia.org/wiki/IPv6_subnetting_reference) of IPv6 is a /64 or 2<sup>64</sup> addresses. IPv4 space, *all of it* contains 2<sup>32</sub> addresses.

- Small organizations, or even your home, are assigned a /56 which contains 256 /64 subnets.

- Larger organization are assigned a /48 which contains 65535 /64 subnets.

- Go back and count those in your head again. I'll wait.

- [Sipcalc](https://github.com/sii/sipcalc) is a good IPv6 subnet calculator.

- Addresses can be statelessly assigned to nodes using [SLAAC](https://en.wikipedia.org/wiki/IPv6#Stateless_address_autoconfiguration_.28SLAAC.29).

- Addresses can be assigned statefully using [DHCPv6](https://en.wikipedia.org/wiki/DHCPv6).

- IPv6 and IPv4 are separate protocols and co-exist. This is called [dual stack](https://en.wikipedia.org/wiki/IPv6#Transition_mechanisms).

- You must have separate routing and firewall rules for both IPv4 and IPv6.

- Services must be configured to listen on IPv6, but most do so by default already.

- A DNS A record for an IPv6 address is an AAAA or 'quad A' record. `dig aaaa watson-wilson.ca`.

