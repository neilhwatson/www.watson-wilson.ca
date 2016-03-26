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
    - content: linux
      domain: category
      nicename: linux
    - content: security
      domain: category
      nicename: security
  post_type: post
  wp_menu_order: 0
  wp_post_id: 548
  wp_post_name: secure-sysctl-settings-with-cfengine
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/secure-sysctl-settings-with-cfengine/
date: 2013-08-07 16:13:42
status: published
tags:
  - Cfengine
  - EFL
  - linux
  - security
  - sysctl
title: Secure sysctl settings with CFEngine
---
Here's how to maintain Linux sysctl settings across all hosts in
an organization using the Evolve [free promise library](http://watson-wilson.ca/evolve-thinkings-free-cfengine-library/)
and CFEngine. ---

Sysctl data is separated from CFEngine policy in its own data file.

``

    # sysctl.txt
    # Promise sysctl.conf and live kernel settings
    
    # context(0) ;; sysctl variable name(1)         ;; value(2) ;; promisee(3)
    any          ;; net.ipv6.conf.all.accept_ra     ;; 0        ;; ipv6 auto assign
    any          ;; net.ipv6.conf.all.autoconf      ;; 0        ;; ipv6 auto assign
    any          ;; net.ipv6.conf.default.autoconf  ;; 0        ;; ipv6 auto assign
    any          ;; net.ipv6.conf.eth0.accept_ra    ;; 0        ;; ipv6 auto assign
    sol          ;; net.ipv6.conf.bond0.accept_ra   ;; 0        ;; ipv6 auto assign
    
    alix         ;; net.ipv6.conf.all.forwarding    ;; 1        ;; Routing
    alix         ;; net.ipv4.ip_forward             ;; 1        ;; Routing
    neptune      ;; proc.sys.kernel.sysrq           ;; 0        ;; Laptop security

Columns labeled 1 and 2 are the sysctl setting name and the value.
Column 3 is the promisee, used for documentation. Column 0 is the class
or context that must be true for the sysctl setting to be applied.

The Evolve free promise library has two sysctl bundles. One promises
live sysctl settings and the other promises the sysctl.conf file. Use
methods promises to call each bundle, passing the same parameter file.

``

    methods:
    
    "live sysctl settings"
       usebundle => efl_sysctl_live( "${sys.workdir}/inputs/bundle_params/sysctl.txt" ),
       action    => if_elapsed( "240" );
    
    "sysctl conf settings"
       usebundle => efl_sysctl_conf_file( "${sys.workdir}/inputs/bundle_params/sysctl.txt" ),
       action    => if_elapsed( "240" );

The live bundle calls the sysctl command often. If_elapsed is used to
reduce the load from excessive promise evaluation.
