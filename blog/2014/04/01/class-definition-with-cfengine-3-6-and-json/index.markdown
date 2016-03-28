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
  wp_post_id: 891
  wp_post_name: class-definition-with-cfengine-3-6-and-json
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/class-definition-with-cfengine-3-6-and-json/
date: 2014-04-01 19:28:33
status: published
tags:
  - cfengine
  - EFL
title: Class definition with CFEngine 3.6 and JSON
---


JSON in CFEngine 3.6, coming soon, offers a great way to separate your
data from your policy. Consider this example. It sets the promiser
class if the host's unqualified hostname is found in the hosts list. If
you want add or remove hosts or classes, just edit the JSON file. Look
for this in EFL after CFEngine's 3.6 release.

---

``

    body common control
    {
            bundlesequence => { "main", };
    }
    
    bundle agent main
    {
            methods:
                    "any" usebundle => init( "${sys.workdir}/inputs/class_by_hostname.dat" );
                    "any" usebundle => run( "${sys.workdir}/inputs/class_by_hostname.dat" );
                    "any" usebundle => check;
    }
    
    bundle agent init ( ref )
    {
       vars:
          "class_by_hostname" string => '
    [
       {
          "promiser_class": "dns_host",
          "promisee": "my, myself, and I",
          "hosts": [
             "blue", "red", "yellow", "moon", 
             "ettin", "black", "green", "purple"
             ],
       },
       {
          "promiser_class": "email_host",
          "promisee": "you, yourself",
          "hosts": [
             "pluto", "venus", "ettin", "moon"
             ],
       }
    ]
    ';
    
       files:
          "${ref}" -> { "Neil H Watson", "Evolve Thinking" }
             create        => 'true',
             edit_defaults => empty,
             edit_line     => append_if_no_line( "${class_by_hostname}" );
    }
    
    bundle agent run ( ref )
    {
       meta:
          "purpose" string => "Set class if uqhost matches names in hosts list";
    
       vars:
          "d" data => readjson( "${ref}", 2048 );
          "i" slist => getindices( "d" );
    
       classes:
          "${d[${i}][promiser_class]}" -> { "${d[${i}][promisee]}" }
             scope      => 'namespace',
             expression => strcmp( "${sys.uqhost}", "${d[${i}][hosts]}" );
    }
    
    bundle agent check
    {
       reports:
          dns_host::
             "This is a dns_host.";
          email_host::
             "This is an email_host.";
    }
    
    body edit_defaults empty
    {
          empty_file_before_editing => "true";
          edit_backup => "false";
    }
    bundle edit_line append_if_no_line(str)
    {
      insert_lines:
          "$(str)";
    }
    
    $ hostname
    ettin.watson-wilson.ca
    
    $ cf-agent -Kf ./efl36.cf 
    R: This is a dns_host.
    R: This is an email_host.
