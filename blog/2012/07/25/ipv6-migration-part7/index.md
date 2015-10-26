---
title: IPv6 Migration part 7
tags: ipv6, networking
---



I've broken up with SixXS. Hurricane Electric is my new girl.

It all started when an error in my Cfengine service began restarting SixXS's tunnel daemon, aiccu, four times per hour. SixXS viewed this as improper behavior and disabled my account. The irony is that my account was disabled by a daemon and not by a human. Let me explain. I contacted SixXS support to have my account turned back on. I explained what had happened and that the problem had been fixed. I was told that I was not supposed to run aiccu under any automatic service. Aiccu is supposed to run on its own. If it breaks, a human is meant to intervene. See the irony? But really, who manages daemons manually these days? Is this the stone age? Sure enough, check out SixXS's aiccu terms of use.

I tried to convince the SixXS person that automation is good. He was not swayed. Disheartened, I consulted with the nice folks of #ipv6 at Freenode. It seems many have had fights and breakups with SixXS. Eventually I did get my account back, but only after many emails and by promising to manually run and manage aiccu. My heart was broken. I knew, in the future, I would clash with SixXS again on some trivial infraction. In this relationship, is was all SixXS. I knew we had to break up.

What mends a broken heart the best? Getting in a better relationship before your ex does. And along came Hurricane Electric. The folks at #ipv6 recommended HE to me. Like SixXS, HE offers free tunnels. Unlike SixXS, HE also offers paid network and hosting services. Their free tunnel service has interesting features.

    Users can take online tests to gain IPV6 experience ranks. These ranks are fun to brag about, but they also allow HE staff to gauge your IPV6 knowledge when dealing with you.
    You can have up to 5 tunnels per account. Each tunnel has its own /64 or /48 IPV6 address block.
    Tunnels are simple IP tunnels requiring no daemon. A clever URL based API allows those with a dynamic IPV4 address to quickly change the tunnel to match a changed IPV4 address. This can be automated.
    IRC and SMTP ports are blocked by default. I was able to unblock IRC myself using HE's tunnel manager web page. I was also able to unblock SMTP after a no hassle email to HE support. I'm told that this was easy for me because I took the HE online tests to reach 'Sage' level before hand.

I'm happy with HE. Is has not been long, but I feel like HE might be THE ONE.

<a href="http://ipv6.he.net/certification/scoresheet.php?pass_name=neilhwatson" target="_blank"><img src="http://ipv6.he.net/certification/create_badge.php?pass_name=neilhwatson&amp;badge=1" style="border: 0; width: 128px; height: 128px" alt="IPv6 Certification Badge for neilhwatson"></img></a>
