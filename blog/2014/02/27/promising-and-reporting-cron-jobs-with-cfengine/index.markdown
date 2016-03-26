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
  post_type: post
  wp_menu_order: 0
  wp_post_id: 842
  wp_post_name: promising-and-reporting-cron-jobs-with-cfengine
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/promising-and-reporting-cron-jobs-with-cfengine/
date: 2014-02-27 08:12:19
status: published
tags:
  - Cfengine
  - delta reporting
  - EFL
title: Promising and reporting cron jobs with CFEngine
---
![image of stopwatch](http://watson-wilson.ca/static/images/stopwatch_13154_sm.gif)

Previously I discusses how use [CFEngine as a cron replacment](http://watson-wilson.ca/2011/09/cfengine-as-an-alternative-to-crond.html).
I'd like to revisit that using EFL and Delta Reporting.

---

Recall that you can use time classes to represent cron time syntax.

Sundays at 0700 hours.

In Cron ``

    0 7 * * 0

In Cfengine ``

    Sunday.Hr07.Min00::

EFL has several class bundles that can make class definitions [easy.](/bulding-cfengine-classes-using-efl/)
Try defining your holidays in cron without using a script. With the
bundle efl_class_expression it is easy.

``

    # class    ;; expression                                      ;; promisee
    is_holiday ;; (January.Day1)|(December.Day25)|Sunday|Saturday ;; Holidays with no work.
    backups    ;; Hr01.(Monday|Wednesday|Friday)                  ;; Backup schedule.

Using the efl_commands bundle we can promise commands just as we would
in cron.

``

    # class     ;; command             ;; shell   ;; module ;; ifelapsed ;; promisee
    !is_holiday ;; /usr/bin/db_dump.sh ;; noshell ;; no     ;; 1440      ;; Daily backup
    ettin       ;; /usr/bin/fetchmail  ;; noshell ;; no     ;; 5         ;; email
    backups     ;; /usr/bin/backup.sh  ;; noshell ;; no     ;; 60        ;; Backups

Using [Delta Reporting](/products/delta-reporting/) we can audit the
history of our jobs, reporting last status and status of the past.

[![delta reporting screen shot of fetchmail promiser](http://watson-wilson.ca/static/images/dr_efl_command_ss.png)](http://watson-wilson.ca/static/images/dr_efl_command_ss.png)
