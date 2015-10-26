---
title: IPv6 Migration part 6
tags: ipv6, networking
---

Liberation! Using IPV6, I have 18,446,744,073,709,551,616 public IP addresses. This is considered a small offering (/64). Normally, an organization would get a /48 network that contains 65536 /64 subnets.

Previously my local IPV6 setup was limited to just my workstation. It initiated the 6in4 tunnel to my IPV6 tunnel broker, Sixxs. Recently this tunnel malfunctioned. I think it was due to it passing through a NAT IPV4 router. I did not discover the problem but, I did move on the next stage. Now my router handles the tunnel and my workstation has a static IPV6 address from the /64 block provided by Sixxs.

My router is an Alix system running Linux. Moving the tunnel from my workstation to the router was quite simple. Note, that in part 1 I was using a static tunnel. With IPV4 addresses in short supply, and poor ISP quality in Canada, I had to move to a dynamic IP address setup. Sixxs provides a daemon called Aiccu to tunnel through dynamic IPV4 setups. Debian has the Aiccu package. With simple apt-get install you are ready to configure your tunnel. The configuration file is /etc/aiccu.conf. Set a username, password, protocol, and server in the file. All of these are provided by Sixxs. The rest of the file can be left at the defaults.
home-ipv6.png

My router has two interfaces. One faces the Internet and the other faces my internal network. The 6in4 tunnel provides an IPV6 address to the external interface. It is not part of the IPV6 subnet provided to me. That subnet is attached to the inside interface. In those simple steps you have your first IPV6 subnet. If you work with IPV4 then this looks familiar. At this level IPV4 and IPV6 work the same way. Don't let the IPV6 address syntax scare you. Just remember that IPV6 requires its own firewall. In Linux that is ip6tables.

