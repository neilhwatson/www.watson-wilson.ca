---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
    - content: delta reporting
      domain: category
      nicename: delta-reporting
    - content: EFL
      domain: category
      nicename: efl
    - content: security
      domain: category
      nicename: security
    - content: software testing
      domain: category
      nicename: software-testing
  post_type: post
  wp_menu_order: 0
  wp_post_id: 1148
  wp_post_name: auditing-hosts-using-cfengine-efl-and-delta-reporting
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/auditing-hosts-using-cfengine-efl-and-delta-reporting/
date: 2015-09-18 13:52:10
status: published
tags:
  - cfengine
  - delta reporting
  - EFL
  - security
  - software testing
title: 'Auditing hosts using CFEngine, EFL, and Delta Reporting'
---
![](/static/images/Liste-300px.png)

Sometimes you want to audit a host without changing it. This can be
hard with CFEngine, but with [EFL](https://github.com/evolvethinking/evolve_cfengine_freelib)
and [Delta Reporting](https://github.com/evolvethinking/delta_reporting)
it's possible.

---

Consider these arbitrary tests:

  1. Is vm.swappiness 60?

  2. Is vm.swappiness not 70?

  3. Does the hash of /etc/ssh/ssh_config match a predetermined string?

  4. Is ntp configured to start at boot time?

  5. Is ftpd not configured to start at boot time?

#  #

Testing is all about classes in CFEngine. Whether or not a class is set
determines the results of your test. EFL has many bundles for creating
classes. Two of them, efl_class_cmd_regcmp and efl_class_returnszero,
I'll use to make the above tests. I'm assuming that you have some
knowledge of CFEngine and EFL.

The first three tests can be accomplished by testing the output of a
command with a regular expression. I'll use the bundle
efl_class_cmd_regcmp for that. Here is the parameter file:

`

    [
       {
          "class": "any",
          "class_to_set": "vm_swappiness_is_60",
          "command" : "/sbin/sysctl vm.swappiness",
          "regex" : "\Qvm.swappiness = 60\E",
          "expression" : "expression",
          "useshell" : "noshell",
          "promisee" : "infosec audit"
       },
       {
          "class": "any",
          "class_to_set": "vm_swappiness_is_not_70",
          "command" : "/sbin/sysctl vm.swappiness",
          "regex" : "\Qvm.swappiness = 70\E",
          "expression" : "not",
          "useshell" : "noshell",
          "promisee" : "infosec audit"
       },
       {
          "class": "any",
          "class_to_set": "ssh_config_hash_is_6005ad62cd337cecbe177097cc74f0052eb15de92713eccd57c2e22fb162eaef",
          "command" : "/usr/bin/sha256sum /etc/ssh/ssh_config",
          "regex" : "(?x) 6005ad62cd337cecbe177097cc74f0052eb15de92713eccd57c2e22fb162eaef \s+ /etc/ssh/ssh_config",
          "expression" : "expression",
          "useshell" : "noshell",
          "promisee" : "infosec audit"
       }
    ]

`

The last two tests can be performed by testing the return value of
chkconfig. I'll use the bundle efl_class_returnszero for that. Here is
the parameter file:

``

    [
       {
          "class" : "any",
          "class_to_set" : "ntpd_boot_startup_enabled",
          "command" : "/sbin/chkconfig -c ntp",
          "zero" : "yes",
          "shell" : "noshell",
          "promisee" : "infosec audit"
       },
       {
          "class" : "any",
          "class_to_set" : "ftpd_boot_startup_disabled",
          "command" : "/sbin/chkconfig -c ftpd",
          "zero" : "no",
          "shell" : "noshell",
          "promisee" : "infosec audit"
       }
    ]

Both bundles will be run using EFL's efl_main bundle, which I won't
show here. I also want some pretty and testable output. I can use EFL's
efl_test_classes bundle for that. (see [TAP and EFL](http://watson-wilson.ca/testing-cfengine-using-efl-tap-and-perl/)).
Here is the parameter file:

``

    [
       {
          "class"         : "any",
          "class_to_test" : "vm_swappiness_is_60",
          "test_type"     : "is",
          "name"          : "Testing if vm.swappiness is 60"
       },
       {
          "class"         : "any",
          "class_to_test" : "vm_swappiness_is_not_70",
          "test_type"     : "is",
          "name"          : "Testing if vm.swappiness is not 70"
       },
       {
          "class"         : "any",
          "class_to_test" : "ssh_config_hash_is_6005ad62cd337cecbe177097cc74f0052eb15de92713eccd57c2e22fb162eaef", 
          "test_type"     : "is",
          "name"          : "Testing if ssh_config is the correct file"
       },
       {
          "class"         : "any",
          "class_to_test" : "ntpd_boot_startup_enabled",
          "test_type"     : "is",
          "name"          : "Testing if ntpd boot start is enabled"
       },
       {
          "class"         : "any",
          "class_to_test" : "ftpd_boot_startup_disabled",
          "test_type"     : "is",
          "name"          : "Testing if ftpd boot start is disabled"
       }
    ]

Now the output (note that cf-agent 3.7.0 spewed a bunch of warnings
about JSON and escape characters. I think they are harmless. You can
see the bug report [here](https://dev.cfengine.com/issues/7579).):

``

    R: _home_neil__cfagent_inputs_test_efl_test_classes_json_4b703cc338ec6c24abbc72019bea6929482d0a38
    1..5
    R: _home_neil__cfagent_inputs_test_efl_test_classes_json_4b703cc338ec6c24abbc72019bea6929482d0a38
    ok 1 - Testing if vm.swappiness is 60
    R: _home_neil__cfagent_inputs_test_efl_test_classes_json_4b703cc338ec6c24abbc72019bea6929482d0a38
    ok 2 - Testing if vm.swappiness is not 70
    R: _home_neil__cfagent_inputs_test_efl_test_classes_json_4b703cc338ec6c24abbc72019bea6929482d0a38
    ok 3 - Testing if ssh_config is the correct file
    R: _home_neil__cfagent_inputs_test_efl_test_classes_json_4b703cc338ec6c24abbc72019bea6929482d0a38
    ok 4 - Testing if ntpd boot start is enabled
    R: _home_neil__cfagent_inputs_test_efl_test_classes_json_4b703cc338ec6c24abbc72019bea6929482d0a38
    ok 5 - Testing if ftpd boot start is disabled

Success! For this host anyway, but suppose I have many hosts. Enter [Delta
Reporting](https://github.com/evolvethinking/delta_reporting). By
integrating the first two bundles into my production policy I can use
DR to search for class membership.

[caption id="attachment_1146" align="aligncenter" width="904"][![Auditing hosts using Delta Reporting](/static/images/auditing1.png)](/static/images/auditing1.png)
Auditing hosts using Delta Reporting[/caption]

**Without writing any new CFEngine policy** I was able to audit my
hosts in a safe and passive manner. I hope you'll try this for yourself
and feel free to contact us for help.
