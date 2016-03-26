---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
  post_type: post
  wp_menu_order: 0
  wp_post_id: 741
  wp_post_name: new-mustache-templates-in-cfengine-3-6
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/new-mustache-templates-in-cfengine-3-6/
date: 2014-01-23 18:22:46
status: published
tags:
  - Cfengine
title: New mustache templates in CFEngine 3.6
---


Mustache templates are a new alternative template method in 3.6. Let's
see how they work. --- [Recall](http://watson-wilson.ca/template-configuration-files-using-cfengine/)
my previous talk about templates and how to use them in CFEngine 3.5.

``

    body common control
    {
            bundlesequence => { "main", };
    }
    
    bundle agent main
    {
            methods:
    
                    "any" usebundle => resolv_conf;
    }
    
    bundle agent resolv_conf 
    {
       meta:
          "purpose" string => "Example of edit_template use";
    
       files:
          "/tmp/resolv.conf"
             create          => 'true',
             template_method => "mustache",
             edit_template   => "${sys.workdir}/inputs/resolv.tmp";
    
    }

There is a new attribute called template_method. Here we define the
mustache method. The actual template is below.

``

    {{#classes.sweden}}
    nameserver 172.16.100.2
    nameserver 172.16.100.1
    {{/classes.sweden}}
    
    {{#classes.toronto}}
    nameserver 192.168.100.254
    nameserver 192.168.100.253
    {{/classes.toronto}}
    
    domain watson-wilson.ca
    search watson-wilson.ca
    timeout:2

Can you spot the new class syntax? Rather than [%CFEngine
<class_name>:: %] there are now opening and closing class tags,
{{#classes.<class_name>}} and {{/classes.<class_name>}} that surround
the lines that the class applies to. This is different than CFEngine's
normal implied class application where the preceding class is assumed
still valid until the next class is stated. Lines outside of class tags
are part of the any class.

At a lower level the agent is using the [datastate](https://cfengine.com/docs/master/reference-functions-datastate.html),
which is an internal representation of the vars and classes available
to the agent. It's layout is roughly this:

``

    {
     "classes": {
     "ipv4_172": true,
     "fe80__fc54_ff_fe34_5399": true,
     "agent": true,
     "Lcycle_1": true,
    
    ....
    "vars": {
     "sys": {
       "systime": "1390500650",
       "flavour": "debian_jessie",
       "hardware_addresses": [
         "00:1e:67:8b:f7:13"
       ],
       "fqhost": "ettin.watson-wilson.ca",
       "ipv4_1[br0]": "172",
       "uptime": "7348",
       "bindir": "/home/neil/.cfagent/bin",
       "arch": "x86_64",
       "ipv4": "172.16.100.1",
    ....

I show only a small piece of it because the full collection is very
large. It gives you an idea of what the agent knows. For this example
it's not important. Just be aware that it exists. Now, let's run the
example policy.

``

    $ cf-agent -IKf ./edit_template.cf -D toronto; cat /tmp/resolv.conf 
    
    nameserver 192.168.100.254
    nameserver 192.168.100.253
    
    domain watson-wilson.ca
    search watson-wilson.ca
    timeout:2

Some folks will be pleased to see that the two blank lines in the
template exist in the promiser file. That suggests that duplicate lines
will *not be skipped* in mustache templates.

[Further reading[.](https://cfengine.com/docs/master/reference-promise-types-files.html#edit_template)
