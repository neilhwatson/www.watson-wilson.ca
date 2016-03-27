---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
    - content: EFL
      domain: category
      nicename: efl
  post_type: post
  wp_menu_order: 0
  wp_post_id: 1179
  wp_post_name: simple-cfengine-setup-with-efl
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/simple-cfengine-setup-with-efl/
date: 2015-10-13 09:54:06
status: published
tags:
  - Cfengine
  - EFL
title: Simple CFEngine setup with EFL
---
![image of stopwatch](/static/images/stopwatch_13154_sm.gif)

CFEngine can be confusing and frustrating for new users. I'll try to
offer you a condensed and easy to follow procedure, including the [EFL](https://github.com/evolvethinking/evolve_cfengine_freelib)
addon.

---

## Concepts ##

CFEngine is client server application. The server, sometimes called the
hub, runs the program cf-serverd that acts as a file server for agents.
Cf-agent, the agent program, runs on all hosts including server. It
downloads policy and files from the server and enforces that policy on
the host by manipulating files and processes, just as a normal sysadmin
would.

Classes are the *if ( test ) then* of the CFEngine language. Tests are
built in, called *hard classes*, or user defined, *soft classes*. Hosts
that pass the test are members of the class.

  * Example hard classes: linux, ipv4_10_0_0_0, debian, cfengine_3_7.

  * Example soft classes: dmz_host, firewall, dhcp_server,
    restart_httpd.

#  #

## Procedure ##

  1. Downlaod and install CFEngine

  2. Prep masterfiles

  3. Install EFL

  4. Using IPv6

  5. Server ACL rules

  6. Stage inputs

  7. Test

  8. Start cf-serverd

  9. Bootstrap agent hosts

  10. Version control

  11. Getting stuff done

#  #

Note: assume these steps are on your CFEngine server unless stated
otherwise.

### Download and install CFEngine ###

Official CFEngine packages are found [here](https://cfengine.com/product/community/).
Packages for most Linux distributions can be found there. For none
Linux binaries try [CFEngineers.net](http://www.cfengineers.net/downloads/cfengine-community-packages/)
or you'll have build your own binaries from the [source code](https://github.com/cfengine/core).
By default CFEngine installs to the prefix /var/cfengine.

### Prep masterfiles ###

The CFEngine masterfiles policy framework is installed with the
binaries to /var/cfengine/share/corebase. Copy the contents to
/var/cfengine/masterfiles. Masterfiles is the default directory that
the agent will draw files from at bootstrap and afterwards. Sometimes
the masterfiles are not packaged with CFEngine. In such cases you have
to get masterfiles from the [source](https://github.com/cfengine/masterfiles).
You can copy files from other locations too, but bootstrapping is
always from masterfiles. This is an advanced topic for another
discussion.

### Prep EFL's masterfiles ###

Download [EFL's](https://github.com/evolvethinking/evolve_cfengine_freelib)
masterfiles directory into /var/cfengine/masterfiles.

#### Edit def.json ####

Def.json is read by the masterfiles policy and parsed for select
information. To enable EFL to run add this to
/var/cfengine/masterfiles/def.json, or create the file if it does not
exists.

``

    {
       "classes" :
          {
             "services_autorun" : "any"
          }
    }

This snippet turns on the soft class *services_autorun* which will
cause CFEngine to read the EFL file *services/efl.cf*.

### Using IPv6 ###

Sadly CFEngine does not support IPv6 out of the box. You must make
changes to masterfiles. Edit the file controls/cf_serverd.cf. In the *body
server control* add this line:

`

    body server control {
    
    # Add this line to make cf-server listen on all interfaces, 
    # including IPv6 interfaces
       bindtointerface => "::";

`

### Server ACL rules ###

Recall that cf-serverd is a file server. Like most file servers it uses
ACL rules to determine what clients are able to access. Masterfiles
allows some ACLs in def.json, but EFL's own mechanism is more flexible.
In this example, assume your server is 2001:DB8::2, with a hostname of
'mars' and your other clients are in the range of 2001:DB8::/32. Change
these to IPv6 or 4 addresses as you require. Edit the file
efl_data/bundle_params/efl_server.json to match what is shown below.
Cf-serverd will read this file, and if the hosts is a member of the
mars hard class (derived from the hostname), it will allow agents
access to /var/cfengine/modules and /var/cfengine/masterfiles if they
are part of the network 2001:0DB8::/32.

`

    [
       {
          "promisee" : "cfengine server",
          "class" : "mars",
          "path" : "${sys.workdir}/masterfiles/",
          "admit" : [
             "2001:0DB8::/32"
          ]
       },
       {
          "path" : "${sys.workdir}/modules/",
          "class" : "mars",
          "promisee" : "cfengine server",
          "admit" : [
             "2001:0DB8::/32"
          ]
       }
    ]

`

Note that *admit* is an array. Add more networks to the arrays to grant
access to agent hosts from other networks.

### Stage inputs ###

Now that mastefiles is ready copy them to /var/cfengine/inputs in order
to start the server.

### Test ###

Test your new inputs with /var/cfengine/bin/cf-promises -c. If no
errors are printed and the exit status is zero, you're good to go.

### Start cfengine ###

``

    /var/cfengine/bin/cf-serverd

### Boostrap the agent ###

Now bootstrap the server to itself. The server is always it's first
client host.

`/var/cfengine/bin/cf-agent -B 2001:DB8::2`. Repeat this bootstrap
command on other agent hosts.

### Version control ###

Now that masterfiles is working check it into version control. Git,
Mercurial, Subversion, whatever you use, but don't edit masterfiles
directly. Use version control, stage changes, then deploy to the
masterfiles directory. See my [best practices
](http://watson-wilson.ca/cfengine-best-practices-testing/)articles for
more information on testing and staging.

### Getting stuff done ###

Now that masterfiles is working you'll want to write your own policy.
You shouldn't do that, but let me explain before you get angry. EFL can
accomplish most of your tasks without you having to write custom
CFEngine policy. Now that you have EFL installed, mastefiles working,
and agent hosts boostrapped, you just need to start using EFL. See [building
data files](https://github.com/evolvethinking/evolve_cfengine_freelib/blob/master/INSTALL.md#building-data-files)
in the EFL install document.

### About EFL ###

[EFL](https://github.com/evolvethinking/evolve_cfengine_freelib) is an
open source policy framework for CFEngine. EFL's goal to tackle the
most common CFEngine tasks without having to write your own policy. It
is mature (since May 2013), [well tested](http://watson-wilson.ca/efl-is-tested-for-your-confidence/),
and you can buy support from its creator [Evolve Thinking](http://watson-wilson.ca/).
