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
  wp_post_id: 671
  wp_post_name: template-configuration-files-using-cfengine
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/template-configuration-files-using-cfengine/
date: 2013-10-17 17:16:56
status: published
tags:
  - cfengine
  - EFL
title: Template configuration files using CFEngine
---


Using the edit_template feature in CFEngine allows you create service
configuration files based on the knowledge of cf-agent. Context/class
constraints and variables can be included inside a CFEngine template.
Read on to learn more.

---

### Using classes ###

Here is an example policy that creates a resolv.conf file from a
template file. It works much like the old edit_line bundles. Cf-agent
reads the template file one line at a time and adds each to a temp file
in RAM. Note that CFEngine will not insert duplicate lines (see below).
Each [%CFEngine class:: %] expression is a class expression. The lines
that follow it are only considered if the class is true. This allows
for great flexibility. Once the final file is constructed in RAM
cf-agent compares it to the promiser file. If the two files are
different then cf-agent writes the new RAM file to the promiser file.

A word about duplicate lines. CFEngine assumes that a any line in a
file should only be repeated one. If you require duplicate lines,
you'll need to work around this behavior. One method is to add unique
comments to lines. Another is to use the tags [%CFEngine BEGIN %] and
[%CFEngine END %] which treat the text between them as a single block.

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
             create        => 'true',
             edit_defaults => empty,
             edit_template => "${sys.workdir}/inputs/resolv.tmp";
    
    }
    body edit_defaults empty
    {
       empty_file_before_editing => "true";
       edit_backup => "false";
    }


The template file.

``

    [%CFEngine ipv4_172_16_100:: %]
    nameserver 172.16.100.254
    nameserver 46.21.99.2
    
    [%CFEngine sweden:: %]
    nameserver 2a02:750:11:2::1
    nameserver 46.21.99.2
    nameserver 2001:470:1d:a2f::1
    
    [%CFEngine any:: %]
    domain watson-wilson.ca
    search watson-wilson.ca
    timeout:2

Run the agent.

``

    $ cf-agent -IKf ./edit_template.cf 
    2013-10-17T11:24:45-0400
       info: /main/methods/'any'/resolv_conf/files/'/tmp/resolv.conf':
       Created file '/tmp/resolv.conf', mode 0600
    2013-10-17T11:24:45-0400
       info: /main/methods/'any'/resolv_conf/files/'/tmp/resolv.conf':
       Edit file '/tmp/resolv.conf'

The created promiser file.

``

    $ cat /tmp/resolv.conf
    nameserver 172.16.100.254
    nameserver 46.21.99.2
    
    domain watson-wilson.ca
    search watson-wilson.ca
    timeout:2

### Using variables ###

Edit_template will also expand variables. Our previous example could
have been done this way.

``

    body common control
    {
            bundlesequence => { "main", };
    }
    
    bundle agent main
    {
       vars:
          ipv4_172_16_100::
             "nameserver" slist => { 
                "172.16.100.254",
                "46.21.99.2"
             };
    
          sweden::
             "nameserver" slist => { 
                "2a02:750:11:2::1",
                "46.21.99.2",
                "2001:470:1d:a2f::1"
             };
    
            methods:
    
                    "any" usebundle => resolv_conf;
    }
    
    bundle agent resolv_conf 
    {
       meta:
          "purpose" string => "Example of edit_template use";
    
       files:
          "/tmp/resolv.conf"
             create        => 'true',
             edit_defaults => empty,
             edit_template => "${sys.workdir}/inputs/resolv.tmp";
    
    }
    body edit_defaults empty
    {
       empty_file_before_editing => "true";
       edit_backup => "false";
    }

The template file.

``

    nameserver ${main.nameserver}
    
    domain watson-wilson.ca
    search watson-wilson.ca
    timeout:2

Run the agent.

``

    $ cf-agent -IKf ./edit_template.cf 
    2013-10-17T13:03:52-0400
       nfo: /main/methods/'any'/resolv_conf/files/'/tmp/resolv.conf':
       Created file '/tmp/resolv.conf', mode 0600
    2013-10-17T13:03:52-0400
       info: /main/methods/'any'/resolv_conf/files/'/tmp/resolv.conf':
       Edit file '/tmp/resolv.conf'

The created promiser file.

``

    $ cat /tmp/resolv.conf
    nameserver 172.16.100.254
    nameserver 46.21.99.2
    
    domain watson-wilson.ca
    search watson-wilson.ca
    timeout:2

This second method demonstrates variable expansion. Variables
represented in the template are expanded by cf-agent. Also, we see list
iteration. The nameserver line is repeated for each element in the
nameserver list. Note that the nameserver variable uses the fully
qualified form of bundle.variable. Many prefer this method rather than
the first example, because it is less typing, but the first example has
one key advantage: there is more data and less CFEngine syntax in one
place. *Someone who knows very little about CFEngine can quickly
understand and make changes to the template in the first example.
Always look to separate data from CFEngine policy.*

### Evolve free library ###

The [Evolve free promise library](http://watson-wilson.ca/make-cfengine-simple-using-the-evolve-free-library/)
has a bundle for editing templates. The bundle efl_edit_template takes
a CSV parameter file that contains the data for one or more
edit_template promises. For the sake of readability I’m going to break
long lines in this example using ‘\’. You cannot do this in actual use
because the CFEngine functions that read CSV files treat line breaks as
record breaks.

Consider the following parameter file. It has seven columns from zero
to six.

  * Zero is the constraining class expression. The record is only
    promised if this class expression is true.

  * One is the promiser file.

  * Two is the source file on the policy server.

  * Three defines the permissions mode of the promiser file.

  * Four defines the owner of the promiser file.

  * Five defines the group of the promiser file.

  * Six is the promisee for documentation and searching.

``

    # context(0) ;; promiser file(1)    ;; source file(2) \
       ;; mode(3) ;; owner(4) ;; group(5) ;; promisee(6)
    
    any          ;; /etc/resolv.conf    ;; /var/cfengine/sitefiles/misc/etc/resolv.conf.tmp \
       ;; 644 ;; root ;; root ;; Neil Watson

Call the bundle using a method.

``

    "Copy files"
       usebundle => efl_edit_template( "${sys.workdir}/inputs/efl_edit_templates.txt" );

[Learn more about the Evolve free promise library](http://watson-wilson.ca/make-cfengine-simple-using-the-evolve-free-library/)

### Mustache templates ###

[Mustache](http://mustache.github.io/) is a simple template system and
CFEngine version 3.6 will be able to [interpret these templates](http://cfengine.com/docs/master/reference-promise-types-files.html#edit_template)
similar to what I've shown you. Be aware that it is not yet clear to me
if Mustache is a good thing. Cf-agent populates Mustache templates
using JSON containers rather than normal CFEngine variables. Also,
[%CFEngine class:: %] expressions are not used. There is some sort of
boolean capability to the data container, but it's not yet clear how
those will be used or if they will be as flexible. To add to the
uncertainty it has been [suggested](https://cfengine.com/dev/issues/1986#note-10)
that the old template system, that I've just shown you, will be
depreciated if Mustache is successful. I'll keep you posted as I learn
more, but I encourage you to express you views to the [CFEngine user
group](https://groups.google.com/forum/?fromgroups#!forum/help-cfengine).
