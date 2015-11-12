---
title: Managing crontables with Cfengine
tags: cfengine, cfengine cookbook, cron
---

Problem

You want Cfengine to manage crontables.

---

Solution

The recipe we used edit authorized_keys can also be used for crontables.

bundle agent recipe {

  vars:
    "root_cron_jobs" slist => { 
      "45 * * * * /var/cfengine/bin/cf-execd -F",
      "17 0 * * 0 /usr/bin/apt-get update"
    };

  files:
    "/var/spool/cron/crontabs/root"
      handle => "root_cron_jobs",
      comment => "Promise root cron table entries",
      create => "true",
      perms => mog("0600","root","root"),
      edit_line => append_if_no_lines( "@{recipe.root_cron_jobs}" );
}

Now we run the agent.

cf3     Promise handle: 
cf3     Promise made by: 45 * * * * /vars:/cfengine/bin/cf-execd -F
cf3 
cf3     Comment:  Append lines to the file if they don't already exist
cf3     .........................................................
cf3 
cf3  -> Inserting the promised line "45 * * * *
/var/cfengine/bin/cf-execd -F" into /vars:/spool/
cf3 
cf3     .........................................................
cf3     Promise handle: 
cf3     Promise made by: 17 0 * * 0 /usr/bin/apt-get update
cf3 
cf3     Comment:  Append lines to the file if they don't already exist
cf3     .........................................................
cf3 
cf3  -> Inserting the promised line "17 0 * * 0 /usr/bin/apt-get update"
into /var/spool/cron/c

Vixie cron, found in most Linux and *BSD installs will notice the changed crontab in about a minute. Older cron daemons are more problematic. AIX and Solaris will not notice the change unless specifically told to do so. We do this by triggering a command promise. First add a classes body part to the crontabs file promise. Then add a commands promise to run crontab if the files promise is repaired.

bundle agent recipe {

  vars:
    "root_cron_jobs" slist => { 
      "45 * * * * /var/cfengine/bin/cf-execd -F",
      "17 0 * * 0 /usr/bin/apt-get update"
    };

  files:
    "/var/spool/cron/crontabs/root"
      handle => "root_cron_jobs",
      comment => "Promise root cron table entries",
      create => "true",
      classes => if_repaired("root_cron_repaired"),
      perms => mog("0600","root","root"),
      edit_line => append_if_no_lines( "@{recipe.root_cron_jobs}" );

  commands:
    root_cron_repaired.(aix|sunos_5_10)::
      handle => "update_cron_daemon",
      comment => "Reread cron tables if it was edited.",
      "/usr/bin/crontab /var/spool/crontabs/root";
}

Be aware that different versions of Linux and UNIX have cron tables in different locations. You can account for this by using a global variable. Briefly:

bundle common g {
# Global variables and settings

  vars:
    debian|ubuntu::
      "crontabs" string => "/var/spool/crontabs";

    redhat::
      "crontabs" string => "/var/spool/cron",

This bundle is read early by Cfengine. The strings defined can be referred to from any bundle. For example

  files:
    "${g.crontabs}/root"
      handle => "root_cron_jobs",
      comment => "Promise root cron table entries",
      create => "true",
      classes => if_repaired("root_cron_repaired"),
      perms => mog("0600","root","root"),
      edit_line => append_if_no_lines( "@{recipe.root_cron_jobs}" );

  commands:
    root_cron_repaired.(aix|sunos_5_10)::
      handle => "update_cron_daemon",
      comment => "Reread cron tables if it was edited.",
      "/usr/bin/crontab ${g.crontabs}/root";

Notice how the variable is prefixed with “g”. This tells Cfengine to check the common bundle named “g” that we defined earlier.
Gravy

Cfengine has enough time and date hard classes that it can function as a replacement for cron. Further, remote classes allow for classes based on the promises of agents on other hosts. This allows for enterprise scheduling. There are white papers on this at cfengine.com.

