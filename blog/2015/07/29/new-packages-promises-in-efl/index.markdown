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
    - content: provisioning
      domain: category
      nicename: provisioning
  post_type: post
  wp_menu_order: 0
  wp_post_id: 1115
  wp_post_name: new-packages-promises-in-efl
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/new-packages-promises-in-efl/
date: 2015-07-29 08:26:33
status: published
tags:
  - cfengine
  - EFL
  - provisioning
title: New packages promises in EFL
---
![A package](/static/images/cubimal-package.png)

Good news everyone. CFEngine 3.7 has revamped packages promises making
them simpler and more reliable. These new promises are now used in EFL
with the bundle efl_packages_new. The bundle's parameter file looks
like this:

---

Call the bundle (but using efl_main is recommended).

``

    "my packages"
       usebunnde => efl_packages_new(
          '${sys.inputdir}/efl_data/bundle_params/packages.csv' );

In csv format. ``

    # class ;; policy  ;; package ;; version ;; arch  ;; promisee
    any     ;; absent  ;; nano    ;; 0       ;; amd64 ;; efl development
    any     ;; present ;; e3      ;; 0       ;; amd64 ;; efl development

These parameters are almost identical to the efl_packages and
efl_packages_via_cmd. You need only alter the policy and the version.
The policy now has only two forms: absent and present. The previous
forms: delete, add, update, and patch have been depreciated. The
version has two forms, 0 means use the latest version the package
manager can find. Otherwise you must specify the precise version
string. The new packages promises do not permit more complex version
comparison at this time.

**Note: You must enable the packages_module in promises.cf's [common
body control](https://github.com/cfengine/masterfiles/blob/master/promises.cf#L68)**:

``

    package_inventory => { $(package_module_knowledge.platform_default) };

Modules are the new interface between CFEngine and package managers.
Currently only yum and apt-get are supported. See [here](https://github.com/cfengine/masterfiles/blob/master/modules/packages/apt_get)
for the gory details.

Don't like the pseudo CSV files? Then you can use JSON format. EFL even
comes with a conversion tool, [eflconvert](https://github.com/evolvethinking/evolve_cfengine_freelib/blob/master/bin/eflconvert).
I converted the above csv file like this:

``

    eflconvert -b efl_packages -i csv -o json < 01_packages.csv

In JSON format. ``

    [
       {
          "package_name" : "nano",
          "class" : "any",
          "promisee" : "efl development",
          "package_version" : "0",
          "package_policy" : "absent",
          "architecture" : "amd64"
       },
       {
          "package_policy" : "present",
          "architecture" : "amd64",
          "promisee" : "efl development",
          "package_version" : "0",
          "package_name" : "e3",
          "class" : "any"
       }
    ]

#### Coming soon YAML format! ####

``

    eflconvert -b efl_packages -i json -o yaml < 01_packages.json

In YAML format ``

    ---
    - architecture: amd64
      class: any
      package_name: nano
      package_policy: absent
      package_version: 0
      promisee: efl development
    - architecture: amd64
      class: any
      package_name: e3
      package_policy: present
      package_version: 0
      promisee: efl development
