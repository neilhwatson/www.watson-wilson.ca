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
  wp_post_id: 733
  wp_post_name: json-containers-improve-cfengine-and-efl
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/json-containers-improve-cfengine-and-efl/
date: 2013-11-27 14:02:37
status: published
tags:
  - cfengine
  - EFL
title: JSON containers improve CFEngine and EFL
---


CFEngine 3.6 will be able to parse JSON files making EFL data files
more readable.

---

The current data format of the [Evolve Free Promise
Library](https://github.com/neilhwatson/evolve_cfengine_freelib) is
CSV. CSV files are workable but, become error prone when record lines
become long. In the following example, run using a build from the
CFEngine 3.6 [source code](https://github.com/cfengine/core), the init
bundle creates a data file that we normally maintain by other means. It
exists here for convenience.

The bundle sysctl loads the JSON, indexes it, then iterates through it.
This is similar to how EFL uses the function CFEngine
readstringarrayidx. Imagine a record with many fields, that line wrap
around your screen in CSV form. In JSON format the same data is more
readable.

    body common control
    {
            bundlesequence => { "main", };
    }
    
    bundle agent main
    {
            methods:
                    "any" usebundle => init;
                    "any" usebundle => sysctl( "/tmp/sysctl.json" );
    }
    
    bundle agent init 
    {
            vars:
                    "sysctl" string => '
    [
        {
            "context": "any",
            "name": "net.ipv6.conf.all.accept_ra",
            "value": 0,
            "promisee": "IPV6 Team"
        },
        {
            "context": "any",
            "name": "net.ipv6.conf.default.autoconf",
            "value": 0,
            "promisee": "IPV6 Team"
        }
    ]
    ';
       files:
          "/tmp/sysctl.json"
             edit_defaults => empty,
             create        => 'true',
             edit_line     => el_init( "${sysctl}" );
    }
    
    body edit_defaults empty
    {
       empty_file_before_editing => "true";
       edit_backup               => "false";
    }
    
    bundle edit_line el_init( str )
    {
       insert_lines:
          "${str}";
    }
    
    bundle agent sysctl( ref )
    {
       vars:
          "sysctl"
             comment => "Read json file into container",
    # New vars type 'data'.
             data    => readjson( "${ref}", 1024 );
    
          "i"
             comment => "Get index of json for iteration",
             slist   => getindices( "sysctl" );
    
       reports:
          "
    context  => ${sysctl[${i}][context]}
    name     => ${sysctl[${i}][name]}
    value    => ${sysctl[${i}][value]}
    promisee => ${sysctl[${i}][promisee]}
    ";
    }
    
    $ cf-agent -f ./json.cf
    2013-11-27T13:48:04-0500   notice: /main/methods/'any'/sysctl: R: 
    context  => any
    name     => net.ipv6.conf.all.accept_ra
    value    => 0
    promisee => IPV6 Team
    
    2013-11-27T13:48:04-0500   notice: /main/methods/'any'/sysctl: R: 
    context  => any
    name     => net.ipv6.conf.default.autoconf
    value    => 0
    promisee => IPV6 Team
