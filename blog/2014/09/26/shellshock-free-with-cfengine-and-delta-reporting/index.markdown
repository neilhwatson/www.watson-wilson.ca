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
  post_type: post
  wp_menu_order: 0
  wp_post_id: 1053
  wp_post_name: shellshock-free-with-cfengine-and-delta-reporting
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/shellshock-free-with-cfengine-and-delta-reporting/
date: 2014-09-26 10:47:04
status: published
tags:
  - cfengine
  - delta reporting
  - EFL
  - security
title: Shellshock free with CFEngine and Delta Reporting
---
![Hosts reported free of shell shock](/static/images/shell_shock.png)

Above is a screenshot from Evolve's production [Delta Reporting](https://github.com/neilhwatson/delta_reporting)
service. These hosts are safe from Shell shock. Thanks to Delta
Reporting, [EFL](https://github.com/neilhwatson/evolve_cfengine_freelib),
and [CFEngine](http://cfengine.com) our journey to a safe harbour was
not long. First we had to design a test for the vulnerability.

---

Fortunately there is already a test described; a single shell command.
Because we use EFL there was no need to write new CFEngine policy for
the test or the fix. EFL's ready to use policy bundles take parameter
files and for this test only two parameters were needed for the bundle
*efl_classes_cmd_regcmp*.

This is a bundle that defines classes by comparing the output of a
command with a given regular expression. The user defines if the match
should be positive or negative. That is if a match, set a given class,
or without a match set a given class. We used both:

efl_classes_cmd_regcmp parameters

    linux ;; is_shell_shock_vulnerable   ;; no ;; \
       /usr/bin/env x='() { :;}; echo vulnerable' bash -c "echo this is a test" ;;\
       useshell ;; (?ims).*?vulnerable.* ;; security
    
    linux ;; isnt_shell_shock_vulnerable ;; yes ;; \
       /usr/bin/env x='() { :;}; echo vulnerable' bash -c "echo this is a test" ;;\
       useshell ;; (?ims).*?vulnerable.* ;; security

The lines here a broken with '\' for easier reading. The true parameter
file has no line breaks for each entry. The first line sets the class *is_shell_shock_vulnerable*
if the command's return matches the regular expression. The second line
sets the class *isnt_shell_shock_vulnerable* if the command's return
does not match the regular expression. The match or not match is
controlled by the yes/no column, which means use 'not' in the class
expression rather than the standard 'expression'. Thus, the first line
is no, use expression, and the second is yes use 'not'. Once this
policy is out to the clients one of those two classes will be set and
Delta Reporting will collect and record them. Now on to the fix.

Package promises are seldom easy in CFEngine. The more exacting you
make the promise, like specifying always upgrade to the latest or
install a given version, the less reliable the promise is. This is not
solely a CFEngine problem. Package managers are notoriously
inconsistent in their behaviour. In CFEngine 3.6 this will improve.
However, our production is still using CFEngine 3.5.2 so we had to use
the hammer approach of a commands promise to be certain. Fortunately
EFL has a commands bundle, so we can simply write a parameter and not a
promise.

efl_command parameter

    debian ;; /usr/bin/apt-get -y install bash ;; yes ;; no ;; 240 ;; security

Above the apt-get command is run on every debian host, in a shell, once
every 240 minutes. We'll take this out after a few days, but in the
mean time any new bash fixes will be applied when they are ready.

There you have it. With just three lines of code we were able to use
our existing CFEngine infrastructure, powered by EFL and Delta
Reporting, to quickly patch our hosts.
