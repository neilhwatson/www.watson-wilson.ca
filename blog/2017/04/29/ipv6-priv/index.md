---
title: Linux, Ubiquity, and IPv6 privacy extensions
tags: ipv6, security, linux, networking, slaac
---

<img style='float:right' alt='Success with IPv6' src='/static/images/ipv6-success-kid.jpg' width='150' >

Here are some quick notes about IPv6 on an Ubiquity router and Linux clients, using privacy extensions. With IPv6 everyone gets a public IP address. In order to offer some privacy, the IPv6 privacy extensions allow clients to change IPv6 addresses over a period of time.

---

### SLAAC on Ubiquity

This stanza allows [stateless](https://en.wikipedia.org/wiki/IPv6#Stateless_address_autoconfiguration_.28SLAAC.29) IPv6 assignment via router advertisement.

    ethernet eth4 {
        address 10.0.0.1/24
        address 2001:0470:b34d::1/64
        description WIFI
        duplex auto
        firewall {
            local {
                ipv6-name IPV6_LAN_LOCAL
                name LAN_LOCAL
            }
        }
        poe {
            output pthru
        }
        speed auto
          ipv6 {
                 router-advert {
                      default-preference high
                      managed-flag true
                      max-interval 10
                      other-config-flag true
                      name-server 2001:0470:b34d::1
                      prefix 2001:0470:b34d::/64 {
                            autonomous-flag true
                      }
                      send-advert true
                 }
          }

    }

The subnet is 2001:0470:b34d::/64, ::1 is assigned to the router's eth4 interface.

My laptop uses the NetworkManager, love it or hate it, and it will setup privacy IPv6 addresses with one kernel tweak.


### /etc/sysctl.d/neil.conf

    net.ipv6.conf.default.use_tempaddr=2

Now NetworkManager will change IPv6 addresses over a period of time, set by `temp_valid_lft` and similar kernel settings.

If you look at the addresses on your interface there are two. One is the same address that will be assigned each time. The other will be changed and is the use during web browsing and other outbound transactions.

### Static IPs

If you want static IPs you'll have to use DHCPv6. Router advertisement does not allow static reservations. For a quick and dirty solution, assuming you have only a few static addresses, you could just configure your host with a static address form the subnet. Given the size of the subnet the odds of an address collision are very low.


