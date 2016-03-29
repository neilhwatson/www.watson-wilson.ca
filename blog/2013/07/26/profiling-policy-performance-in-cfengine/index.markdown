---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
  post_type: post
  wp_menu_order: 0
  wp_post_id: 535
  wp_post_name: profiling-policy-performance-in-cfengine
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/profiling-policy-performance-in-cfengine/
date: 2013-07-26 08:27:36
status: published
tags:
  - cfengine
title: Profiling policy performance in CFEngine
---


[Loïc Pefferkorn](http://www.loicp.eu/) has created the [cfe-profiler](https://github.com/lpefferkorn/cfe-profiler).
It is a library that times the execution of CFEngine bundles in your
policy. Let's take a look.

---

Here is the output from one of my production hosts:

    # LD_PRELOAD=/home/neil/src/cfe-profiler/cfe_profiler35.so cf-agent
    
    Cfe-profiler-0.1: a CFEngine profiler - http://www.loicp.eu/cfe-profiler
    
    *** Sorted by wall-clock time ***
    
    Time(s) Namespace            Type               Bundle
       3.30   default           agent             efl_main
       3.14   default           agent          efl_bug2638
       1.20   default           agent          efl_service
       0.58   default           agent         efl_packages
       0.53   default          common                paths
       0.36   default           agent                email
       0.31   default           agent       efl_copy_files
       0.27   default           agent         postfix_main
    ....

Cfe-profiler list the execution time of each bundle in descending
order. A bundle like cfl_main calls many other bundles. Its time is an
accumulation of all the bundles it calls. Those with large complex
policies will welcome this tool. Keep up the good work Loïc!
