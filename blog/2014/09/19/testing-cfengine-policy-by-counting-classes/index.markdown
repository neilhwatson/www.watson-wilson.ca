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
    - content: devops
      domain: category
      nicename: devops
    - content: EFL
      domain: category
      nicename: efl
    - content: software testing
      domain: category
      nicename: software-testing
  post_type: post
  wp_menu_order: 0
  wp_post_id: 1043
  wp_post_name: testing-cfengine-policy-by-counting-classes
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/testing-cfengine-policy-by-counting-classes/
date: 2014-09-19 11:45:48
status: published
tags:
  - cfengine
  - delta reporting
  - devops
  - EFL
  - software testing
title: Testing CFEngine policy by counting classes
---
![counting](/static/images/counting.jpg)

I've added a [new bundle](https://github.com/evolvethinking/evolve_cfengine_freelib/commit/00093210649c4b236e9d4940a23f5a6fe2e60742)
to the 3.5 branch of EFL. This bundle *efl_test_count* allows you to
count the classes matching a regular expression and test if that count
matches your expected count. Consider the *efl_service* bundle, it
promises that services are configured and running. My SSH parameters
for this bundle include a template file for configuration. I promise
that /etc/ssh/sshd_config is built from the sshd_config.tmp, a
template.

---

Paramters for efl_service ` `

    any ;; \
       /usr/sbin/sshd ;; \
       /etc/ssh/sshd_config ;; \
       /var/cfengine/sitefiles/ssh/sshd_config.tmp ;; \
       efl_global_slists.policy_servers ;; \
       yes ;; \
       no ;; \
       600 ;; \
       root ;; \
       root ;; \
       ${paths.path[service]} ssh restart ;; \
       Neil Watson

Looking at EFL I know that these promises will promise
/etc/ssh/sshd_config.

From efl_service ` `

    "${${config_file[${s}]}}" -> { "${${promisee[${s}]}}" }
       comment       => "Promise contents of configurationn file from template",
       handle        => "efl_service_files_config_template",
       classes       => efl_rkn( "${${config_file[${s}]}}", "efl_service_files_config_template" ),
       action        => efl_delta_reporting( "efl_service_files_config_template", "${${config_file[${s}]}}", "${${promisee[${s}]}}", "1" ),
       create        => "true",
       edit_defaults => empty,
       ifvarclass    => canonify( "build_from_template_${${source_file[${s}]}}_${s}" ),
       edit_template => "${efl_c.cache}/${${config_file[${s}]}}";
    
    "${${config_file[${s}]}}" -> { "${${promisee[${s}]}}" }
       comment    => "Promise permissions of configuration file",
       handle     => "efl_service_files_config_permissions",
       classes    => efl_rkn( "${${config_file[${s}]}}", "efl_service_files_config_permissions" ),
       action     => efl_delta_reporting( "efl_service_files_config_permissions", "${${config_file[${s}]}}", "${${promisee[${s}]}}", "1" ),
       ifvarclass => "${${class[${s}]}}",
       perms      => mog( "${${mode[${s}]}}", "${${user[${s}]}}", "${${group[${s}]}}" );

EFL creates classes if a promise is kept, repaired, or not kept. This
is primarily used for [Delta Reporting](https://github.com/evolvethinking/delta_reporting),
but you can use it for testing too. The classes attribute calls the
body efl_rkn. Let's look at it.

The body accepts the promiser and the handle. These are combined and
postfixed with the promise result. This makes promise outcome classes
predictable.

How EFL makes class results ` `

    body classes efl_rkn( promiser, handle )
    {
       promise_kept      => { "${promiser}_handle_${handle}_kept" };
       promise_repaired  => { "${promiser}_handle_${handle}_repaired" };
       repair_failed     => { "${promiser}_handle_${handle}_notkept" };
       repair_denied     => { "${promiser}_handle_${handle}_notkept" };
       repair_timeout    => { "${promiser}_handle_${handle}_notkept" };
    }

Thus I can predict what classes should be created when *efl_service*
processes my SSH parameters. *efl_test_count* expects a parameter file
described below.

From efl_test_count ` `

    bundle agent efl_test_count( ref )
    {
       meta:
          "purpose" string => "Skeleton bundle for new bundle authoring";
          "field_0" string => "Context expression";
          "field_1" string => "Class regex to test";
          "field_2" string => "Expected number classes that match the regex";
          "field_3" string => "Test name, free form like promisee";

Combining my knowledge I can now predict that promises for
/etc/ssh/sshd_config should create two classes. I put an expression
into the efl_test_count parameter file. Note, that I've added escaped
new lines for readability, but in practice this must be on one line due
to how CFEngine reads parameter files.

Parameters for efl_test_count ` `

    # class ;; test_class regex ;; count ;; test name
    policy_testing ;; \
       _etc_ssh_sshd_config_handle_efl_service_files_config.*?_kept ;; \
       2 ;; \
       Promising /etc/ssh/sshd_config

The regular expression should match my two outcome promises. Plug all
this in to EFL, see [here](https://github.com/evolvethinking/evolve_cfengine_freelib)
for details EFL integration instructions. Now I run it.

Success! ` `

    root@oort:~# cf-agent -KD policy_testing|grep 'R:'
    2014-09-19T10:45:53-0400   notice: R: PASS, [_etc_ssh_sshd_config_handle_efl_service_files_config.*?_kept], [Promising /etc/ssh/sshd_config]

This is just a quick look at EFL, how it works, and its new testing
bundles. Don't forget the companion [previous post](http://watson-wilson.ca/testing-cfengine-policy/).
I invite you further explore the power of EFL and Delta Reporting. Feel
free to contact me with any questions you have or to seek support using
EFL and Delta Reporting.
