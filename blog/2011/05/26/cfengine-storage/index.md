---
title: Disk space monitoring using Cfengine
tags: cfengine, cfengine cookbook, configuration management, monitoring
---

Problem

You want to monitor free disk space.
Solution

Cfengine has storage promises that can mount file systems and monitor disk space.

bundle agent recipe {

  storage:

    "/var"
      handle => "var_fs_check",
      comment => "var filesystem check",
      volume => min_free_space("13G");
}

In this example we see a message printed if the /var filesystem has less than 13 gigabytes of free space.

root@venus:/home/neil/.cfagent/inputs# cf-agent -f ./recipe.cf 
 !! Disk space under 13631488 kB for volume containing /vars: (12113604
 kB free)
 I: Made in version 'not specified' of './recipe.cf' near line 17
 I: Comment: vars: filesystem check

Gravy

Why stop at passive monitoring? A class can be defined when the file system is filling up. This allows for more actions.

bundle agent recipe {

    storage:

        "/var"
            handle => "var_fs_check",
            comment => "var filesystem check",
            classes => if_notkept("var_full"),
            volume => min_free_space("13G");

    reports:

        var_full::
            "Report: /var has to little free space.";
}

Now the class “var_full” is set. In this example we only create a report but any other action would be possible. Perhaps we can initiate a search for core files and delete them. We could delete aged files from /var/tmp. A package cache could be deleted. An alert could be sent to a central monitoring system. We could even do all of these things.

