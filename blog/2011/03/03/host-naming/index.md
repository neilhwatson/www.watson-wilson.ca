---
title: Choosing a host naming convention
tags: dns
---

<object style='float:right' data='/static/images/hello_my_name_is_dns.svg' type='image/svg+xhtml' width='300px'>
    Hello, my name is Dns
</object>

Whether realizing it or not every organization goes through the process of
selecting a naming convention. Often this is done without much forward planing
resulting in unwieldy host and service names. In the worst cases host names are
dropped completely and either by habit or lack of a proper DNS service only ip
addresses are used.

---

In the following I will talk about the different types of naming conventions
that I’ve experienced or read about. I’ll discuss the pros and cons of each.
Before we get to that we’ll need to have a small refresher on domain name
services.

### DNS review

Domain name service is probably the most important and most overlooked of all
network services. In many cases unexplained network problems can be attributed
to improper or missing DNS. Some view DNS as complicated voodoo that is more
trouble than it is worth.

The goal of DNS is very simple. Ip addresses are difficult to remember, this is
especially true of ipv6 ip addresses. DNS allows you assign easy to remember
names to associate with an ip address. DNS allows further fine grained
identification through specialized name and ip address matches.

1. A record: this is the most basic record that associates a DNS name with an
   ip address.
1. PTR: Sometimes called a pointer or reverse record this associates an IP
   address with DNS name allowing a person or service to discover the DNS name
   of a known IP address. When building DNS records I often see these records
   missing and deemed unimportant. Without these a DNS service will not be
   complete and errors or service problems may occur.
1. MX RECORD: The MX record identifies the IP address and DNS name of mail
   servers (mail exchanger). Without these records mail will not flow.
1. NS RECORD: This identifies the IP address and DNS name of DNS servers.
   Without these records a DNS service cannot function.
1. CNAME: This record, sometimes called an alias, is optional but very useful
   and often overlooked. A CNAME allows for a host to have additional name
   records. As we’ll see being able to refer to a host via multiple names can
   be very useful.

#### DNS versus host name

It is important to differentiate between a DNS name and a host name. A DNS name
is the name record of an IP address. A host name is the name that a host is
assigned when it is setup, or changed to. The host name is known only to the
host. DNS names and host names independent. They do not always match and there
is no guarantee that they will. This is why a proper DNS service is so
important. Without one there is no centralized way to refer to a host without
knowing its IP address.

### Naming conventions

#### Purpose

This style names host after there purpose.

##### Examples

Printer1, router1, www and exchange1.

##### Pros

These host names are easy to remember.

##### Cons

1. As the number of alike services increases it can be difficult to remember if
   you are referring to printer1 or printer8.
1. Servers often have multiple purposes. Should a file and print server be
   called printer1, file1 or print-file1?
1. If a print server is to become a file server you’ll have to go through the
   trouble of renaming the server.

#### Geographic

This style attempts to chose names base on location such as city, office or
even floor.

##### Examples

Toronto1, kingst1, and 2ndfloor2.

##### Pros

You know where to find the server.

##### Cons

1. What does the host do?
1. As the number of hosts at single location increase it can be difficult to
   remember if you are referring to toronto1 or toronto5.
1. Whenever a host is moved you’ll have to rename the server.
1. If you’re not using CNAMEs how will your customers refer to the host? Will
   you give them a new name if you move it?
1. This may give out more information about your host than you might wish.

#### Inventory

This style attempts to combine the purpose and geographic style in hopes of
gaining an inventory system for all hosts. Some go even further to include the
operating system in the host name.

##### Examples

tor-print01, 2ndflr-router02, kingst-exchange01, toronto-lnx-nfs1,
kingst-csco-router1

##### Pros

This hostname tells you a lot about the host.

##### Cons

1. Host names are long, difficult to remember and difficult to type. This is
   counter to the purpose of DNS.
1. What if a host has multiple purposes such as file and print?
1. You’ll have to rename a host each time it is re-purposed or moved.
1. While this might seem like a poor man’s inventory system it is no substitute
   for the real thing.
1. This may give out more information about your host than you might wish.

#### Themes

We’ve all seen hosts with whimsical names that seem to serve no purpose.

##### Examples

zeus, maple, blue, pluto

##### Pros

To the newcomer such host names seem meaningless. However, as they are short
they are very easy to remember and type. People will quickly learn to associate
such names with their purpose. This is a common technique for code names in
industry and the military. These types of host names are the only ones that I
can remember even long after I’ve stopped working with them. Further You can
never run out of unique names.

##### Cons

1. The host name tells nothing about the host. One might argue this as a pro
   since a cracker has no additional information.
1. What happens if a host is decommissioned? Are customers told to access a new
   host name?

#### CNAMEs

Using CNAMEs allows you to combine all of the above naming conventions in a
single flexible system. Since a CNAME is an alias it can be reassigned to
another host without either host requiring a host name change. This allows
services to be moved without customers being aware of it. A customer can be
pointed to a new web server simply by assigning the CNAME www to another host.
The change is transparent.

Considering what you now know about CNAMEs. Go back and look at our naming
styles again. We can now combine them in a much more useful way. A host simply
called blue can have CNAMEs printer1, tor-printer or even
blue-lnx-toronto-printer1. For administrators blue is easy to remember and
type. Even if blue is decommissioned we simply reassign the CNAME to its
replacement server. If the server is moved, installed with a new operating
system or assigned a new purposed simple change the CNAME.

##### Examples

blue, blue-lnx-toronto-printer1, mars, mars-csc-kingst-brouter1

##### Pros

1. Allows all of the benefits of the previously discussed conventions.
1. Allows for the movement of services and hosts without the need to change host names.

##### Cons

1. Requires a functioning DNS service.
1. This may give out more information about your host than you might wish.
1. Current DNS implementations prevent clients from asking a DNS server to list
   the CNAMEs of a given A record. Instead the DNS server’s configuration must
   be examined in order to determine all CNAMEs.
1. Requires a little more work to keep CNAME records in addition to A and PTR
   records.

#### TXT and HINFO

There are two little known DNS records called TXT and HINFO. These are mostly
free form records used to store arbitrary host information. Unlike CNAMEs one
should be able to query these fields via a client. However, like some of our
other methods this can sometimes offer too much information to a cracker. For
more information about the TXT and HINFO refer to RFCs 1464 and 1033.

Whatever method you choose, and this list is by no means complete, be sure to
plan ahead. Think about how your naming convention can adapt to a growing
network as you add more nodes and move existing ones.

