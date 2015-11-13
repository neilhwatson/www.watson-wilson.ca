---
title: IPv6 Migration part 3
tags: ipv6, networking
---

We continue in this series by having a quick look at a dual stack VPS host.

---

Alas many providers, including my ISP, do not yet offer IPV6 addresses.
Fortunately my hosting provider does. I have a multipurpose VPS with them.
Before this article the VPS had one IPV4 address. Using my provider's website I
requested an IPV6 address. It’s worth noting that an IPV4 address costs me
€2.00 per month. An IPV6 address cost only €0.10 per month.

After I made the request, I returned a day later expecting to have to set
things up. I was surprised to see everything just worked. IPV6 address can be
assigned by stateless configuration. This is built in to IPV6 beyond regular
use of DHCPv6. I'm not sure how my provided assigned the IP but it must have
been easy and automatic.

    venet0    Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  
              inet addr:127.0.0.1  P-t-P:127.0.0.1  Bcast:0.0.0.0  Mask:255.255.255.255
              inet6 addr: ::1/128 Scope:Host
              inet6 addr: 2a02:750:5::464/128 Scope:Global
              UP BROADCAST POINTOPOINT RUNNING NOARP  MTU:1500  Metric:1
              RX packets:13899581 errors:0 dropped:0 overruns:0 frame:0
              TX packets:11227895 errors:0 dropped:6422 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:13392292622 (12.4 GiB)  TX bytes:1196669117 (1.1 GiB)

    venet0:0  Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  
              inet addr:46.21.104.226  P-t-P:46.21.104.226  Bcast:0.0.0.0  Mask:255.255.255.255
              UP BROADCAST POINTOPOINT RUNNING NOARP  MTU:1500  Metric:1

This host has one IPV4 address and one IPV6 address. I can access the host
through IPV4 and my IPV6 tunnel.

    PING 46.21.104.226 (46.21.104.226) 56(84) bytes of data.
    64 bytes from 46.21.104.226: icmp_req=1 ttl=50 time=145 ms
    64 bytes from 46.21.104.226: icmp_req=2 ttl=50 time=145 ms
    64 bytes from 46.21.104.226: icmp_req=3 ttl=50 time=145 ms

    --- 46.21.104.226 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2001ms
    rtt min/avg/max/mdev = 145.177/145.509/145.784/0.251 ms

    PING 2a02:750:5::464(2a02:750:5::464) 56 data bytes
    64 bytes from 2a02:750:5::464: icmp_seq=1 ttl=53 time=160 ms
    64 bytes from 2a02:750:5::464: icmp_seq=2 ttl=53 time=159 ms
    64 bytes from 2a02:750:5::464: icmp_seq=3 ttl=53 time=158 ms

    --- 2a02:750:5::464 ping statistics ---
    3 packets transmitted, 3 received, 0% packet loss, time 2002ms
    rtt min/avg/max/mdev = 158.861/159.709/160.406/0.718 ms

Assigning both IPV4 and IPV6 addresses is a good way to transition to IPV6. It
allows the host to access both worlds. Most reputable network services will
happily work on both types of addresses. Just be aware that services like DHCP
and packet filtering are entirely separate.

