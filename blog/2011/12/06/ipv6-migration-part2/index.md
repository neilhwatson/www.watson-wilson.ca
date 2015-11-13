---
title: IPv6 Migration part 2
tags: ipv6, networking
---

In this part of the series we will learn how to make a service run on an IPV6
address.

---

In part one of this IPV6 series we discussed the setup of an IPV6 tunnel. In
part two we’ll look at setting up an IPV6 available website.

My first task was to configure a DNS record. IPV6 has its own DNS record types.
In this simple test I only need the A record equivalent, the AAAA or quad-a
record. These look like this.

    ipv6.watson-wilson.ca.      IN AAAA 2604:8800:100:111::2

Lookups are done like this.

    dig aaaa ipv6.watson-wilson.ca

    ; <<>> DiG 9.7.3 <<>> aaaa ipv6.watson-wilson.ca
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 36878
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

    ;; QUESTION SECTION:
    ;ipv6.watson-wilson.ca.    IN AAAA

    ;; ANSWER SECTION:
    ipv6.watson-wilson.ca.  10725 IN AAAA  2604:8800:100:111::2

    ;; Query time: 8 msec
    ;; SERVER: 199.19.175.71#53(199.19.175.71)
    ;; WHEN: Sun Dec 18 13:16:00 2011
    ;; MSG SIZE  rcvd: 67

It’s worth noting that since IPV6 address are so long lazy IT staff are not
going to be able to forsake DNS and memorize IPV4 addresses as they have done
the in past. A working DNS service is paramount for successful use of IPV6.

Next was to configure a virtual host in Apache.

    Listen [2604:8800:100:111::2]:80
    <VirtualHost *:80>

        ServerName ipv6.watson-wilson.ca
        DocumentRoot "/var/www/ipv6/"
        ErrorLog /var/log/apache2/error_log
        CustomLog /var/log/apache2/access_log combined

    </VirtualHost>

If you have an IPV6 tunnel you can visit it here. If not, you can visit it via
[ipv6proxy.net](http://ipv6proxy.net).

In the next part I’ll show a dual stack host that has native IPV4 and IPV6
connectivity.

