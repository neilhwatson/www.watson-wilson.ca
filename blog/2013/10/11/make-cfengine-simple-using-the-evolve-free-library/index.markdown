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
  wp_post_id: 656
  wp_post_name: make-cfengine-simple-using-the-evolve-free-library
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/make-cfengine-simple-using-the-evolve-free-library/
date: 2013-10-11 11:06:52
status: published
tags:
  - Cfengine
  - EFL
title: Make CFEngine simple using the Evolve Free Library
---


[EFL](https://github.com/evolvethinking/evolve_cfengine_freelib) makes
using CFEngine both simple and easy. [EFL](https://github.com/evolvethinking/evolve_cfengine_freelib)
is a collection of data driven bundles that promise many common
configuration states. Here are a few examples covering just a few
bundles found in [EFL](https://github.com/evolvethinking/evolve_cfengine_freelib).

---

### Setting classes ###

If you have an arbitrary list of hosts that you'd like to belong to the
same class then you can use the bundle efl_class_hostname. In this
example assume the desired class is web_servers. Create a file called
efl_class_hostname-web_servers.txt and fill it with a list of
unqualified hostnames, one per line, of all the hosts that belong to
the class web_servers.

``

    $ cat efl_class_hostname-webservers.txt
    atlweb01
    atlweb01
    dmzatlweb01
    dmzatlweb02
    altdevweb01
    atltestweb02

Call the bundle via method.

``

    "Set web_server class"
       usebundle => efl_class_hostname( "${sys.workdir}/inputs/efl_class_hostname-web_servers.txt" );

The bundle efl_class_hostname extracts the class web_servers from the
file name using '-' and '.txt' as anchors. The bundle then iterates
through each line in the file. If any line in the file matches
${sys.uqhost} the class web_servers is set in the scope of namespace,
which is less accurately called a global class.

### Defining string variables ###

The bundle efl_global_strings allow you to define string variables
using a simple csv file. Consider following csv file. It has four
columns, numbered from zero to three. Column one defines the variable
name, column two defines the variable value, column three defines a
promisee, used for documentation and for searching parameter files for
related data. Column zero is a class expression to constrain the
variable. More in a moment.

``

    $ cat efl_global_strings.txt 
    # Set global strings
    
    # context(0) ;; variable name(1) ;; variable value(2) ;; promisee(3)
    Sunday       ;; day              ;; sat               ;; Days of the week
    Monday       ;; day              ;; sun               ;; Days of the week
    Tuesday      ;; day              ;; tue               ;; Days of the week
    Wednesday    ;; day              ;; wed               ;; Days of the week
    Thursday     ;; day              ;; thu               ;; Days of the week
    Friday       ;; day              ;; fri               ;; Days of the week
    Saturday     ;; day              ;; sat               ;; Days of the week
    any          ;; mf_cache         ;; /var/cache/cfmasterfiles ;; Cache directory
    any          ;; gzip             ;; /bin/gzip         ;; gzip

Call the bundle using a method.

``

    "Set namespace strings"
       usebundle => efl_global_strings( "${sys.workdir}/inputs/efl_global_strings.txt" );

The bundle iterates through each row in the file and sets the variable
to the given value if the class expression in column zero is true. The
bundle is an agent bundle so you can recall the variables using the
fully qualified form: ${efl_global_strings.day}.

### Deleting files ###

The bundle efl_delete_files allows you define common file deletion
promises. Again the parameter file is a csv file. For the sake of
readability I'm going to break long lines in this example using '\'.
You cannot do this in actual use because the CFEngine functions that
read csv files treat line breaks as record breaks.

Consider the following parameter file. It has seven columns from zero
to six.

  * Zero is the constraining class expression.. The record is only
    promised if this class expression is true.

  * One is the file promiser. It can be a single file or a directory to
    recurse.

  * Two defines the recurse level: 'no' to not recurse, 0-99999 for
    levels to recurse, and 'inf' for infinite recursion.

  * Three defines the leaf regular expression that will match the files
    to be deleted. For example '.*' will match any file.

  * Four can turn column three into a negative match. That is, match
    any file that does not match the regular expression. Takes the
    parameter 'yes' or 'no'.

  * Five defines the minimum age, in days, of the files to delete.

  * Six is a free form promisee for documentation and searching.

``

    # cat efl_delete_files.txt 
    # Delete files that match the given requirements.
    
    # context(0) ;; file promiser(1) ;; recurse(2) ;; leaf(3) \
       ;; negative match(4) ;; file age(5) ;; promisee(6)
    
    any          ;; /tmp             ;; inf        ;; .* \
       ;; no               ;; 8           ;; Neil Watson
    
    !alix        ;; /var/tmp         ;; inf        ;; .* \
       ;; no               ;; 8           ;; Neil Watson
    
    any          ;; /var/cfengine/outputs ;; inf   ;; .* \
       ;; no               ;; 8           ;; Neil Watson

Call the bundle using a method.

``

    "Delete files"
       usebundle => efl_delete_files( "${sys.workdir}/efl_delete_files.txt" );

### Copying files ###

The bundle efl_copy_files allows you to define common copy file
promises. Again the parameter file is a csv file. For the sake of
readability I'm going to break long lines in this example using '\'.
You cannot do this in actual use because the CFEngine functions that
read csv files treat line breaks as record breaks.

Consider the following parameter file. It has ten columns from zero to
nine.

  * Zero is the constraining class expression. The record is only
    promised if this class expression is true.

  * One defines the promiser or target file. If the promiser is a
    directory then use the trailing '/.' notation.

  * Two is the leaf regular expression to match files if using
    recursive copying.

  * Three defines the source file.

  * Four defines the policy server. It must be in the form of a fully
    qualified string list, but without '$' or '@' qualifiers. You may
    use 'efl_c.policy_servers' which is defined automatically by [EFL](https://github.com/evolvethinking/evolve_cfengine_freelib)
    and defaults to ${sys.policy_server}.

  * Five sets if the file transfer should be encrypted ('no' or 'yes').

  * Six defines the permissions mode of the promiser file.

  * Seven defines the owner of the promiser file.

  * Eight defines the group of the promiser file.

  * Nine is the promisee for documentation and searching.

``

    $ cat efl_copy_files.txt 
    # context(0) ;; file promiser(1) ;; leaf regex(2) ;; file source(3) ;; \
       server(4) ;; encrypt(5) ;; mode(6) ;; onwer(7) ;; group(8) ;; promisee(9)
    
    any          ;; /usr/share/games/fortunes/taow ;; .* ;; ${efl_global_vars.sitefiles}/misc/taow \
       ;; efl_c.policy_servers ;; no ;; 644 ;; root ;; root ;; Neil Watson
    
    any          ;; /usr/share/games/fortunes/taow.dat ;; .* ;; ${efl_global_vars.sitefiles}/misc/taow.dat \
       ;; efl_c.policy_servers ;; no ;; 644 ;; root ;; root ;; Neil Watson
    
    ettin        ;; /etc/hosts       ;; .*            ;; ${efl_global_vars.sitefiles}/misc/etc/hosts \
       ;; efl_c.policy_servers ;; no ;; 644 ;; root ;; root ;; Neil Watson

Call the bundle using a method.

``

    "Copy files"
       usebundle => efl_copy_files( "${sys.workdir}/inputs/efl_copy_files.txt" );

### Promising packages ###

The bundle efl_packages performs simple package promises. Again the
parameter file is a csv file. For the sake of readability I'm going to
break long lines in this example using '\'. You cannot do this in
actual use because the CFEngine functions that read csv files treat
line breaks as record breaks.

Consider the following parameter file. It has six columns from zero to
five.

  * Zero is the constraining class expression. The record is only
    promised if this class expression is true.

  * One is the package policy such as 'add' or 'delete'.

  * Two is the regular expression to match the package name.

  * Three is the string to match the package version. Use '0' if
    version does not matter.

  * Four is the package architecture. Use '*' if this does not matter.

  * Five is the promisee for documentation and searching.

``

    $ cat efl_packages.txt 
    # Generic package promiser 
    # Add packages
    # context(0) ;; policy(1) ;; name regex(2) ;; version(3) ;; arch regex(4) ;; promisee(5)
    debian       ;; add       ;; lsof          ;; 0          ;; default       ;; CFEngine
    opennms_nodes ;; add      ;; snmpd         ;; 0          ;; default       ;; snmpd and opennms
    sol|ettin|alix ;; add     ;; bind9         ;; 0          ;; default       ;; Neil Watson
    
    # Delete packages
    # context(0) ;; policy(1) ;; name regex(2) ;; version(3) ;; arch regex(4) ;; promisee(5)
    debian       ;; delete    ;; portmap       ;; 0          ;; default       ;; Neil Watson
    debian       ;; delete    ;; rpcbind       ;; 0          ;; default       ;; Neil Watson

Call the bundle using a method.

``

    "Promise packages"
       usebundle => efl_packages( "${sys.workdir}/inputs/efl_packages.txt" );

### Running commands ###

The bundle efl_command promises to run given commands, constrained by a
class expression, optionally as a module. Again the parameter file is a
csv file. For the sake of readability I'm going to break long lines in
this example using '\'. You cannot do this in actual use because the
CFEngine functions that read csv files treat line breaks as record
breaks.

Consider the following parameter file. It has six columns from zero to
five.

  * Zero is the constraining class expression. The record is only
    promised if this class expression is true.

  * One is the command promiser.

  * Two sets the shell containment ('useshell' or 'noshell').

  * Three defines if the command should be treated as a module ('yes'
    or 'no').

  * Four sets the ifelapsed number for the commands promise.

  * Five is the promisee for documentation and searching.

``

    $ cat efl_command.txt 
    # execute arbitrary commands.  Great for cron replacement.
    
    # context(0)             \
       ;; command(1) \
       ;; usehell(2) ;; module(3) ;; ifelapsed(4) ;; promisee(5)
    
    sql_server.Hr03 \
       ;; /usr/bin/mysqldump -A -u root -pMyPW | gzip > /root/sqlbackup-$(date +%a).gz \
       ;; yes ;; no ;; 60 ;; EvovleThinking
    
    cfengine_3_5 \
       ;; /var/cfengine/bin/tchmgr optimize /var/cfengine/state/cf_lock.tcdb \
       ;; noshell ;; no ;; 480 ;; Cfengine tcdb corruption

Call the bundle using a method.

``

    "Run commands or modules"
       usebundle => efl_command( "${sys.workdir}/inputs/efl_command.txt" );

### Starting a service ###

The bundle efl_start_service starts a service if a process is not
running. Again the parameter file is a csv file. For the sake of
readability I'm going to break long lines in this example using '\'.
You cannot do this in actual use because the CFEngine functions that
read csv files treat line breaks as record breaks.

Consider the following parameter file. It has four columns from zero to
three.

  * Zero is the constraining class expression. The record is only
    promised if this class expression is true.

  * One is a regular expression to match the process command column in
    a ps command.

  * Two is the start command to run if the process from column one is
    not found.

  * Three is the promisee for documentation and searching.

``

    $ cat efl_start_service.txt 
    # Start service if process is not runing and context is true.
    
    # Context(0) ;; Process regex(1) \
       ;; Restart command(2) ;; promisee(3)
    
    earth        ;; ^.+/usr/lib/postgresql/9.1/bin/postgres \
       ;; /usr/sbin/service postgresql restart ;; www.watson-wilson.ca website
    
    scope        ;; .+/usr/share/opennms/lib/opennms_bootstrap.jar start \
       ;; /usr/sbin/service opennms restart ;; monitoring

Call the bundle using a method.

``

    "Start services"
       usebundle => efl_start_service( "${sys.workdir}/inputs/efl_start_service.txt" );

### Promising a service ###

The bundle efl_service promises to configure and run a service
including promising configuration files, restarting if these files
change, and starting if the process is not running. Again the parameter
file is a csv file. For the sake of readability I'm going to break long
lines in this example using '\'. You cannot do this in actual use
because the CFEngine functions that read csv files treat line breaks as
record breaks.

Consider the following parameter file. It has eleven columns from zero
to ten.

  * Zero is the constraining class expression. The record is only
    promised if this class expression is true.

  * One is a regular expression to match the process command column in
    a ps command.

  * Two is the promiser for the configuration file.

  * Three is the source of the configuration file. The server
    @{efl_c.policy_servers} is assumed.

  * Four defines if the configuration file promise is a copy action or
    an edit_template action. Is it a template? 'yes' or 'no'.

  * Five sets if the file transfer should be encrypted ('no' or 'yes').

  * Six defines the permissions mode of the promiser file.

  * Seven defines the owner of the promiser file.

  * Eight defines the group of the promiser file.

  * Nine is the start command to run if the process form column one is
    not found.

  * Ten is the promisee for documentation and searching.

``

    $ cat efl_service.txt 
    # promise services.
    
    # context(0) \
       ;; process regex(1) \
       ;; config file promiser(2) ;; config file source(3) \
       ;; template yes/no(4) ;; encrypt yes/no(5) ;; mode(6) ;; owner(7) ;; group(8) \
       ;; restart command(9) ;; promisee(10)
    
    #
    # snmp
    #
    opennms_nodes \
       ;; /usr/sbin/snmpd -Lsd -Lf /dev/null -u snmp -g snmp -I -smux -p /var/run/snmpd.pid \
       ;; /etc/default/snmpd  ;; /var/cfengine/sitefiles/snmp/debian-defaults-snmpd \
       ;; yes ;; no ;; 644 ;; root ;; root \
       ;; /usr/sbin/service snmpd restart ;; snmp and opennms
    
    opennms_nodes \
       ;; /usr/sbin/snmpd -Lsd -Lf /dev/null -u snmp -g snmp -I -smux -p /var/run/snmpd.pid \
       ;; /etc/snmp/snmpd.conf  ;; /var/cfengine/sitefiles/snmp/snmpd.conf \
       ;; yes ;; yes ;; 644 ;; root ;; root \
       ;; /usr/sbin/service snmpd restart ;; snmp and opennms
    
    #
    # other
    #
    debian \
       ;; /usr/sbin/rsyslogd -c5 \
       ;; /etc/rsyslog.conf ;; /var/cfengine/sitefiles/misc/etc/rsyslog.conf \
       ;; no ;; no ;; 644 ;; root ;; root \
       ;; /usr/sbin/service rsyslog restart ;; Logging

Sharp viewers may notice that there are two SNMP records where only the
configuration file differs. This is perfectly legal and, because of how
CFEngine iterates through promises, duplicate promisers such as the
process and restart command are not duplicated when the agent runs.

Call the bundle using a method.

``

    "Promise running services"
       usebundle => efl_service( "${sys.workdir}/inputs/efl_service.txt" );

### Promise ordered methods ###

Until now I've shown you how to call [EFL](https://github.com/evolvethinking/evolve_cfengine_freelib)
bundles using standard methods. The bundle efl_main allows you to
parameterize these method calls into a csv file. For the sake of
readability I'm going to break long lines in this example using '\'.
You cannot do this in actual use because the CFEngine functions that
read csv files treat line breaks as record breaks.

Consider the following parameter file. It has six columns from zero to
five.

  * Zero is the constraining class expression. The record is only
    promised if this class expression is true.

  * One is the method promiser.

  * Two is the bundle name.

  * Three is the ifelapsed parameter for the method promise.

  * Four is the csv file bundle parameter.

  * Five is the promisee for documentation and searching.

``

    $ cat methods.txt 
    # Method calls
    # context(0)      ;; promiser(1)                  ;; bundle(2) ;; ifelapsed(3) \
       ;; parameter(4) \
       ;; promisee(5)
    
    #
    # Classes
    #
    any               ;; web servers hostname class match ;; efl_class_hostname ;; 1 \
       ;; ${sys.workdir}/inputs/user_data/classes/efl_class_hostname-web_server.txt \
       ;; web servers
    
    #
    # variables
    #
    any               ;; global vars       ;; efl_global_strings   ;; 1 \
       ;; ${sys.workdir}/inputs/user_data/bundle_params/efl_global_strings.txt \
       ;; Neil Watson
    
    #
    # other
    #
    any               ;; clean up          ;; efl_delete_files  ;; 1 \
       ;; ${sys.workdir}/inputs/user_data/bundle_params/efl_delete_files.txt \
       ;; Neil Watson
    
    any               ;; packages          ;; efl_packages      ;; 1 \
       ;; ${sys.workdir}/inputs/user_data/bundle_params/efl_packages.txt \
       ;; Neil Watson
    
    any               ;; copy files        ;; efl_copy_files    ;; 1 \
       ;; ${sys.workdir}/inputs/user_data/bundle_params/efl_copy_files.txt \
       ;; Neil watson
    
    any               ;; services          ;; efl_start_service ;; 1 \
       ;; ${sys.workdir}/inputs/user_data/bundle_params/efl_start_service.txt  \
       ;; Neil Watson
    
    any               ;; services          ;; efl_service       ;; 1 \
       ;; ${sys.workdir}/inputs/user_data/bundle_params/efl_service.txt  \
       ;; Neil Watson

Call the bundle using a method.

``

    "Promise running services"
       usebundle => efl_main( "${sys.workdir}/inputs/efl_main.txt" );

### That's not all ###

I've show you some bundles from the Evolve Free Library, but there are
more.

  * More bundles to set classes using common functions.

  * Bundles to disable or enable services using the chkconfig command.

  * Bundles for reporting hosts seen and not seen.

  * A bundle to report CFEngine server statistics from cf-monitord.

  * A bundle that promises files using edit_template.

  * A bundle to promise links.

  * A bundle to promise file permissions.

  * A bundle to [promise sysctl.conf and live kernel settings](http://watson-wilson.ca/secure-sysctl-settings-with-cfengine/).

#  #

[EFL](https://github.com/evolvethinking/evolve_cfengine_freelib) is
open source and free to use. It is the engine that runs our [Delta
Hardening](http://watson-wilson.ca/products/)© product and our yet to
be released Delta Reporting© product.
