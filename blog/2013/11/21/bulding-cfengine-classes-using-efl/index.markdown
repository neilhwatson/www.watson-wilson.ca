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
  wp_post_id: 723
  wp_post_name: bulding-cfengine-classes-using-efl
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/bulding-cfengine-classes-using-efl/
date: 2013-11-21 12:00:25
status: published
tags:
  - cfengine
  - EFL
title: Bulding CFEngine classes using EFL
---


Recently my CFEngine colleague [Marco Marongiu](http://syslog.me/)
wrote about [classifying CFEngine hosts via external means](http://syslog.me/2013/11/18/external-node-classification-the-cfengine-way/).
His post inspired me to write about classifying hosts using [EFL](http://watson-wilson.ca/tag/efl/).

---

EFL allows you classify your hosts using data separation and external
modules. Let's look at the current bundles available to you and how you
can expand EFL adding your own.

All of these bundles take a CSV file as a parameter. You can call the
bundles when, where, and as many times as you like using different
parameter files. For the sake of readability I’m going to break long
lines in these examples using ‘\’. You cannot do this in actual use
because the CFEngine functions that read CSV files treat line breaks as
record breaks.

### Classes from hostnames ###

If you have an arbitrary list of hosts that you’d like to belong to the
same class then you can use the bundle efl_class_hostname. In this
example assume the desired class is web_servers. Create a file called
efl_class_hostname-web_servers.txt and fill it with a list of
unqualified hostnames, one per line, of all the hosts that belong to
the class web_servers.

    $ cat efl_class_hostname-webservers.txt
    atlweb01
    atlweb01
    dmzatlweb01
    dmzatlweb02
    altdevweb01
    atltestweb02

The bundle efl_class_hostname extracts the class name web_servers from
the file name using ‘-’ and ‘.txt’ as anchors. The bundle then iterates
through each line in the file. If any line in the file matches
${sys.uqhost} the class web_servers is set in the scope of namespace,
which is less accurately called a global class.

Call the bundle via method.

    "Set web_server class"
       usebundle => efl_class_hostname( "${sys.workdir}/inputs/efl_class_hostname-web_servers.txt" );

### Classes from reading external command output ###

The bundle efl_class_cmd_regcmp defines a class if the output of a
command matches, or does not match, the provided regular expression.
Consider the following parameter file. It has seven columns from zero
to six.

  * Zero is the constraining class expression. The record is only
    promised if this class expression is true.

  * One is the class promiser that will be set.

  * Two is whether or not to negate the match. Meaning set a class if
    the expression is not matched.

  * Three is the command to run.

  * Four defines whether or not the command is run in a full shell.

  * Five is the regular expression that must match the entire output of
    the command in four.

  * Six is a free form promisee for documentation and searching.

    # Define global class if anchored regex matches command output.
    # context(0) ;; class promiser(1) ;; 'not' match?(2) ;; command(3) \
              ;; useshell/noshell(4) ;; anchored regex(5) ;; promisee(6)
    
    debian       ;;  install_cfengine_apt_key ;; yes ;; /usr/bin/apt-key list \
              ;; useshell ;; (?ims).*?CFEngine Community package repository.* ;; Neil Watson

The above record runs the command 'apt-key list' on hosts of the debian
class. If the given regular expression is not matched (see column two),
then the class 'install_cfengine_apt_key' is set.

Call the bundle using a method.

    "Class by shell and regcmp"
       usebundle => efl_class_cmd_regcmp "${sys.workdir}/efl_class_cmd_regcmp.txt" );

### Classes from expressions ###

The bundle efl_class_expression sets a class if the provided expression
is true. Consider the following parameter file. It has three columns
from zero to two.

  * Zero is the class promiser.

  * One is a class expression. If the expression is evaluated as true,
    then the class in column zero is defined.

  * Three is a free form promisee for documentation and searching.

    # promiser class(0) ;; class expression(1)         ;; promisee(3)
    dmz_a               ;; ipv4_10_10_10|ipv4_10_10_11 ;; dmz_a networks

The class 'dmz_a' is defined if either of the given classes, which in
this case are hard classes, are defined.

Call the bundle using a method.

    "classify by expressions"
       usebundle => efl_class_expression( "${sys.workdir}/efl_class_expression.txt" );

### Classes from the classmatch function ###

The bundle efl_class_classmatch sets a class if the given regular
expression matches any already defined classes. Consider the following
parameter file. It has three columns from zero to two.

  * Zero is the class promiser.

  * One is a class regular expression. If the expression matches any
    defined class, then the class in column zero is defined. Note that
    the expression must match the entire class name and not a partial
    match.

  * Three is a free form promisee for documentation and searching.

    # promiser class(0) ;; class regular expression(1) ;; promisee(3)
    ipv4_host           ;; ipv4_.*                     ;; Any ipv4 host

Call the bundle using a method.

    "Class by classmatch function"
       usebundle => efl_class_classmatch( "${sys.workdir}/efl_class_classmatch.txt" );

### Classes from the iprange function ###

The bundle efl_class_iprange sets a class if any of the hosts IP
addresses fall within the given range. Consider the following parameter
file. It has three columns from zero to two.

  * Zero is the class promiser.

  * Two is the IP range to test against. If there is a match the class
    in zero is defined.

  * Three is a free form promisee for documentation and searching.

    # promiser class(0) ;; ip range(1)     ;; promisee(3)
    dmz_a               ;; 10.10.10.0/24   ;; dmz_a networks
    dmz_a               ;; 10.10.11.0/24   ;; dmz_a networks
    dmz_b               ;; 172.16.100.0/24 ;; dmz_b networks
    sandbox_hosts       ;; 192.168.0.10-15 ;; CFEngine sandbox hosts


Call the bundle using a method.

    "Class by iprange function"
       usebundle => efl_class_iprange( "${sys.workdir}/efl_class_iprange.txt" );

### Classes from external modules ###

The bundle efl_command (also discussed [here](http://watson-wilson.ca/make-cfengine-simple-using-the-evolve-free-library/).)
promises to run given commands, constrained by a class expression. When
the module options at column three is true then the promise attribute
'module' is set to true and cf-agent will treat the output of the
command as module syntax. Consider the following parameter file. It has
six columns from zero to five.

  *  Zero is the constraining class expression. The record is only
    promised if this class expression is true.

  *  One is the command promiser.

  *  Two sets the shell containment (‘useshell’ or ‘noshell’).

  *  Three defines if the command should be treated as a module (‘yes’
    or ‘no’).

  *  Four sets the ifelapsed number for the commands promise.

  *  Five is the promisee for documentation and searching.

    # execute arbitrary commands.  Great for cron replacement.
    # context(0)             \
       ;; command(1) \
       ;; usehell(2) ;; module(3) ;; ifelapsed(4) ;; promisee(5)
    
    redhat \
       ;; ${sys.workdir}/modules/graphics \
       ;; yes ;; 1 ;; Set graphics hardware classes

Call the bundle using a method.

    "Run commands or modules"
       usebundle => efl_command( "${sys.workdir}/inputs/efl_command.txt" );

### Expanding EFL ###

Most bundles in EFL are so similar that you can easily create your own
bundles by copying existing ones. There is even a template called
'efl_skeleton' for this very purpose. A common change might be to
duplicate a class bundle but change it to a common bundle. Such bundles
would define classes that cf-serverd can use. If you do develop new
bundles I hope you'll contribute them back to [EFL](https://github.com/neilhwatson/evolve_cfengine_freelib).
