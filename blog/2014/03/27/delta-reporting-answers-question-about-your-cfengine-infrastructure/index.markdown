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
  post_type: post
  wp_menu_order: 0
  wp_post_id: 880
  wp_post_name: delta-reporting-answers-question-about-your-cfengine-infrastructure
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/delta-reporting-answers-question-about-your-cfengine-infrastructure/
date: 2014-03-27 10:45:10
status: published
tags:
  - cfengine
  - delta reporting
title: Delta Reporting answers questions about your CFEngine infrastructure
---
![dr-logo-100](/static/images/dr-logo-100.png)

Learn what [Delta Reporting](https://github.com/evolvethinking/delta_reporting) can answer for
you, all from one place.

---

Sign into the live demo with username 'evolve' and password 'thinking'.

## Using the inventory report ##

  * How many hosts do I have?

  * I've upgraded to CFEngine 3.5.2 how many hosts have upgraded? How
    many have not?

  * How many Red Hat 6, update 2 hosts do I have?

  * How many hosts are in the network 172.16.100?

  * How many 32 bit linux hosts do I have? Hint, i586.

### [Try it](http://drdemo.watson-wilson.ca/report/inventory) ###

## Using the promises report ##

  * What promises were not kept in the past 30 minutes?

  * What promises were repaired in the past 30 minutes?

  * What was the status of promises with the promisees like '%nsa%'
    yesterday during the 1200 hour?

  * What was the status of promises with the promiser '/etc/passwd/'
    between 0800 and 0830 hours?

### [Try it](http://drdemo.watson-wilson.ca/form/promises) ###

Notice that the results returned include timestamps. You know when
cf-agent evaluated the promise.

## Using the classes report ##

  * What hosts are members of the class 'toronto' in the past 15
    minutes?

  * What hosts were members of the class 'toronto' on Monday between
    0800 and 0815 hours?

### [Try it](http://drdemo.watson-wilson.ca/form/classes) ###

Notice that the results returned include timestamps. You know when
cf-agent evaluated the class.

## Finding missing hosts. ##

  * What hosts have not been seen in the past 24 hours that were seen
    24 hours before that?

### [Try it](http://drdemo.watson-wilson.ca/report/missing) ###

## More info ##

  * See the [Delta Reporting](https://github.com/evolvethinking/delta_reporting)
    information page.

  * Delta Reporting is open source, under the GPL3 licence. [Get the
    source](https://github.com/evolvethinking/delta_reporting).

  * Contact me for support and professional services for Delta Reporting.
