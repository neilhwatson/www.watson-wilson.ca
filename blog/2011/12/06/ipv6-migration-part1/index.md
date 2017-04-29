---
title: IPv6 Migration part 1
tags: ipv6, networking
---

<img style='float:right' alt='Success with IPv6' src='/static/images/ipv6-success-kid.jpg' width='150' >

The first step in my exploration of IPV6 was to get an IPV6 address via an IPV4
to IPV6 tunnel. A little research lead me to the fine folks at SixXS.

---

My ISP does not offer IPV6 addresses at this time. Even if it did I did not
want to go all the way down the rabbit hole at this time. Instead I chose the
tunnel route. SixXS allows you to set a tunnel from your host to their servers.
It is similar to a VPN connection. Your presence at the SixXS end of the tunnel
is an IPV6 address. Their website explains in good detail how to get ready for,
apply for and set up this tunnel.

UPDATE. I have since moved from [SixXS](http://sixxs.net) to [Hurricane
Electric](http://ne.net). See [here](/blog/2012/07/25/ipv6-migration-part7/)
for more details.

The first preparation was to ready my firewall. This caused me some grief.
Typically I've configured my firewall by hand but these additional requirements
added complexity which made me doubt the firewall's integrity. In an effort to
simplify I built all new firewall rules using Firewall Builder. After the
initial learning curve I was off to the races. The relevant rules are:

UPDATE. I have since changed my firewall software. I now use Shorewall.

    Allow protocol 41 between my IPV4 IP and tunnel target at SixXS.
    Allow ICMPv6 between my IPV6 IP and the Internet.

More paranoid folks try to block a lot of ICMP traffic. ICMP traffic has a
purpose and blocking can cause trouble as it did for me. In this instance SixXS
monitors the tunnel using ICMPv6 traffic.

After applying for a tunnel SixXS send me the details. My test host runs
Debian. I had to configure an interface for the tunnel:

    iface sixxs inet6 v4tunnel
        address 2604:8800:100:111::2
        netmask 64
        endpoint 38.229.76.3
        ttl 64
        up ip link set mtu 1280 dev sixxs
        up ip route add default via 2604:8800:100:111::1 dev sixxs

My IPV6 address is 2604:8800:100:111::2. The endpoint is the target at SixXS to
create the tunnel. Then I bring the interface up.

    sixxs     Link encap:IPv6-in-IPv4  
              inet6 addr: fe80::c713:ab18/64 Scope:Link
              inet6 addr: 2604:8800:100:111::2/64 Scope:Global
              inet6 addr: fe80::a00:1/64 Scope:Link
              inet6 addr: fe80::c0a8:1/64 Scope:Link
              UP POINTOPOINT RUNNING NOARP  MTU:1280  Metric:1
              RX packets:5134 errors:0 dropped:0 overruns:0 frame:0
              TX packets:4398 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:4788682 (4.5 MiB)  TX bytes:623868 (609.2 KiB)

And it works:

    ping6 -nc 4 ipv6.google.com

    PING ipv6.google.com(2607:f8b0:4001:c01::93) 56 data bytes
    64 bytes from 2607:f8b0:4001:c01::93: icmp_seq=1 ttl=56 time=41.1 ms
    64 bytes from 2607:f8b0:4001:c01::93: icmp_seq=2 ttl=56 time=41.3 ms
    64 bytes from 2607:f8b0:4001:c01::93: icmp_seq=3 ttl=56 time=42.3 ms
    64 bytes from 2607:f8b0:4001:c01::93: icmp_seq=4 ttl=56 time=41.4 ms

    --- ipv6.google.com ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3004ms
    rtt min/avg/max/mdev = 41.173/41.576/42.351/0.456 ms

Be aware that firewall tools, like Iptables, require separate rules for IPV6
traffic. A normal IPV4 firewall may allow all IPV6 traffic or block it.

Next time I'll look at enabling a service using an IPV6 address.
