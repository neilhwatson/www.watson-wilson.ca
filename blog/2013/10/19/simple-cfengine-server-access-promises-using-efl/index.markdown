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
  wp_post_id: 689
  wp_post_name: simple-cfengine-server-access-promises-using-efl
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/simple-cfengine-server-access-promises-using-efl/
date: 2013-10-19 09:09:29
status: published
tags:
  - Cfengine
  - EFL
title: Simple CFEngine server access promises using EFL
---


Here's an EFL bundle that simplifies access promises for cf-serverd.
CFEngine users with a complex environment will especially benefit. ---
The [Evolve Thinking Free Library or EFL](http://watson-wilson.ca/make-cfengine-simple-using-the-evolve-free-library/)
provides commonly used promise bundles that you can configure using
simple CSV parameter files. You don't need a PHD in CFEngie to get
things done.

Unlike EFL agent bundles the server bundle efl_server cannot be passed
parameter files. The is a CFEngine limit. Instead variable
'efl_server_txt' in the bundle 'efl_c' defines the location of the
parameter file to
${sys.workdir}/inputs/user_data/bundle_params/efl_server.txt. The file
format has four columns from zero to three.

  * Zero is the constraining class expression. The record is only
    promised if this class expression is true.

  * One is the promiser directory that we are granting access to.

  * Two is comma separated list of IP's or hostnames who we grant
    access to (see [admit](https://cfengine.com/docs/3.5/reference-promise-types-access.html#admit)).

  * Three is a free form promisee for documentation and searching.

`

    # Context(0) ;; promiser directory(1) ;; Command separated admit list(2) ;; Promisee(3)
    
    am_policy_hub ;; ${sys.workdir}/masterfiles ;;  2001:470:1d:a2f::/64 ;; Bootstrapping and updates
    ettin    ;; ${sys.workdir}/private/alix/ ;; 2001:470:1d:a2f::1 ;; 6in4 tunnel
    mercury  ;; /var/www/blog1/              ;; ${sys.policy_hub}  ;; Backups
    titan    ;; /var/www/evolve/             ;; ${sys.policy_hub}  ;; Backups
    any      ;; ${sys.workdir}/drop/         ;; ${sys.policy_hub}  ;; File transfers as needed

`

If you run cf-serverd -Fvl you'll see the access rules being applied.

``

    cf3> *****************************************************************
    cf3> BUNDLE efl_server
    cf3> *****************************************************************
    cf3>    =========================================================
    cf3>    access in bundle efl_server (0)
    cf3>    =========================================================
    cf3> . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
    cf3> Skipping whole next promise (/var/www/evolve-wp/), as var-context titan is not relevant
    cf3> . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
    cf3> . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
    cf3> Skipping whole next promise (/var/www/blog1/), as var-context mercury is not relevant
    cf3> . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
    cf3> Summarize control promises
    cf3> Granted access to paths :
    cf3> Path '/var/cfengine/private/alix' (encrypt=0)
    cf3> Admit: '2001:470:1d:a2f::1' root=
    cf3> Path '/var/cfengine/drop' (encrypt=0)
    cf3> Admit: '2001:470:1d:a2f::2' root=

When you upgrade CFEngine the upgrade offers new inputs like the sever
bundle 'access_rules' in the file cf_server.cf. If you have access
rules in that bundle you'll need to merge the old file with the
upgrade's improved file. Using the efl_server bundle the data is
separated from policy eliminating the need to merge policy files.
