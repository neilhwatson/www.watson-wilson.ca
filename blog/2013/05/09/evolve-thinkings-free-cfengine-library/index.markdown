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
  wp_post_id: 38
  wp_post_name: evolve-thinkings-free-cfengine-library
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/evolve-thinkings-free-cfengine-library/
date: 2013-05-09 10:47:41
status: published
tags:
  - Cfengine
  - EFL
title: Evolve Thinking's free CFEngine library
---
Our free CFEngine library empowers users to build and deploy new
policy faster, simplify existing policy, and reduce staff training. ---
We do this by offering simple reusable bundles and full data separation
using CSV parameter files.

Just as CFEngine uses a handful of promises to affect so much change on
a host, our small collection of bundles can accomplish most high level
tasks in CFEngine.

Typical CFEngine bundles in use today are too specialized. A bundle for
cron tables, a bundle for resolv.conf, and another for NTP. This is too
specialized and too costly. There is a better way. Simpler bundles can
offer greater flexibility and easier reuse at a lower cost. A single
service bundle can promise cron tables, NTP, and more. A single editing
template bundle can promise resolv.conf, the hosts file, shell
profiles, and more. Our library does this and more.

Consider this data file for the bundle *efl_chkconfig_enable_service*.
If the context class is true then the given service is enabled for boot
time start using the chkconfig command.

    # context(0) ;; service name(1) ;; Promisee(3)
    
    any          ;; cfengine3       ;; Sysadmin team
    web_server   ;; apache2         ;; Web team
    dev.dns      ;; bind            ;; Dev team

You can call the bundle like this:

    "enable with chkconfig"
    usebundle => efl_chkconfig_enable_service(
       "${sys.workdir}/inputs/user_data/bundle_params/efl_chkconfig_enable_service.txt"
    );

To enable a new service, change only the data file. The promisee is
very important. It will help you to find all related data. Labelling a
promisee "SSH services for DMZ" will help find all SSH entries, in all
data files using a single search.

Our library offers a further step in data separation. The method above
can be placed in a data file. The bundle efl_main takes a data file
that describes method calls and parameters. For example:

    # context(0) ;; promiser(1) ;; bundle(2) ;; ifelapsed(3) ;; parameter(4) ;; promisee(5)
    
    any ;; host classes ;; efl_class_hostname ;; 1 ;; /var/cfengine/inputs/user_data/classes/efl_class_hostname-ipv6_only.txt ;; Neil Watson
    any ;; chkconfig enable ;; efl_chkconfig_enable_service ;; 1 ;; /var/cfengine/inputs/user_data/bundle_params/efl_chkconfig_enable_service.txt ;; Neil Watson

When the given context is true a bundle is invoked with the given
parameter and using *ifelapsed*.

At this release the free library offer these bundles and more:

  * Enable and disable services using chkconfig.

  * Install and remove packages.

  * Promise sysctl.conf.

  * Promise live sysctl kernel settings.

  * Delete files.

  * Copy files.

  * Edit templates.

  * Promise commands.

  * Define classes

  * Promise links.

  * Define global variables.

  * Promise that services are configured and running.

  * Promise file permissions.

In the future we'll be offering special purpose bundles that use these
simple bundles, ready to use parameter files, and more.

The Evolve free library is open source and available at our [Git Hub
site.](https://github.com/evolvethinking/)
