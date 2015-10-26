---
title: IPv6 Migration part 8
tags: ipv6, networking
---

DNS for IPV6 is just like IPV4, but longer. In part 2 I discussed DNS quad A records. Now I'll explain IPV6 PTR records.

In this example I'll use Bind and the subnet 2001:470:1d:a2f::/64. First load the zone file.

zone "f.2.a.0.d.1.0.0.0.7.4.0.1.0.0.2.ip6.arpa" {
   type master;
   file "/etc/bind/db.2001:470:1d:a2f";
};

Note that "ipv6.arpa" is different than IPV4 (in-addr.arpa). The 16 numbers in the zone make up the subnet (a /64). As is custom, they are in reverse order. The last 16 digits, not shown here, are all part of the subnet and are not yet needed.

In PTR records, IPV6 addresses must be reversed just like IPV4 addresses. When done manually this can drive you mental because IPV6 addresses are up to 32 characters long. Fortunately you can use tools to reverse these for you. Consider the humble host command.

# host 2001:470:1d:a2f::1
1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.f.2.a.0.d.1.0.0.0.7.4.0.1.0.0.2.ip6.arpa domain name pointer alix.watson-wilson.ca.

Also, the dig command.

# dig -x 2001:470:1d:a2f::1

; <<>> DiG 9.8.4-rpz2+rl005.12-P1 <<>> -x 2001:470:1d:a2f::1
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 6661
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3

;; QUESTION SECTION:
;1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.f.2.a.0.d.1.0.0.0.7.4.0.1.0.0.2.ip6.arpa. IN PTR

Avid script writers are invited to create ingenious ways to cut the first or last 16 digits as needed. Next up the zone file.

;; 2001:470:1d:a2f/64
$TTL 3h
@ IN SOA sol.watson-wilson.ca. hostmaster.watson-wilson.ca. (
        30              ; TODO SERIAL
        3h              ; 3 hour refresh
        1h              ; 1 hour retry
        1w              ; 1 week expire
        1h)     ; negatic TTL cache

   NS sol.watson-wilson.ca.
   NS alix.watson-wilson.ca.

$ORIGIN f.2.a.0.d.1.0.0.0.7.4.0.1.0.0.2.ip6.arpa.

1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0 IN PTR alix.watson-wilson.ca.
2.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0 IN PTR ettin.watson-wilson.ca.
3.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0 IN PTR scope.watson-wilson.ca.

Most of the file is as we would use in IPV4. The last parts are IPV6 related. The '$ORIGIN' denotes the subnet. This is a short cut. Bind will know to add this to the PTR records below it. The PTR records show the last 16 digits of the IP address, again in reverse order. Bind will put the origin and the PTR record together like this:

1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.f.2.a.0.d.1.0.0.0.7.4.0.1.0.0.2.ip6.arpa IN PTR alix.watson-wilson.ca.

That's enough for working PTR records in IPV6. I hope you found this help.

