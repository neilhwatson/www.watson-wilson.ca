---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
  post_type: post
  wp_menu_order: 0
  wp_post_id: 1095
  wp_post_name: setting-default-variables-in-cfengine
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/setting-default-variables-in-cfengine/
date: 2015-04-08 08:54:30
status: published
tags:
  - Cfengine
title: Setting default variables in CFEngine
---


Do you want to set a default value for variables in CFEngine? Here are
two methods. The first uses *defaults* promises. Defaults promises can
be bit confusing and I've seen bugs in them in the past, so test
carefully when using them. See the CFEngine reference for more details
on defaults.

---

The second method is a normal variables promise, but uses the *ifelse*
function. Ifelse takes the form of

``

    "myvar" string => ifelse(
       "class1", "value1",
       "classn+1", "valuen+1",
       "default value" );

The agent checks each class condition and assigns the value of the
variable for the correct class. Assume that the first correct value
will be assigned even if more than one class is true, but variable
policy bugs may deem otherwise (see
https://dev.cfengine.com/issues/1492), so test carefully. If no class
condition is meet, the final value, that has no class, is assigned.

``

    body common control
    {
       bundlesequence => { "g", "main", };
    }
     
    bundle common g
    {
       defaults:
          "a" string => "default value";
     
       vars:
          "b" string => ifelse(
             "set", "set value for 'b'",
             "default value for 'b'"
             );
     
          set::
             "a" string => "A 'set' value";
    }
     
    bundle agent main
    {
       reports:
          "a is ${g.a}";
          "b is ${g.b}";
    }
     
    neil@ettin ~/.cfagent/inputs $ cf-agent -Kf ./default.cf
    R: a is default value
    R: b is default value for 'b'
     
    neil@ettin ~/.cfagent/inputs $ cf-agent -Kf ./default.cf -D set
    R: a is A 'set' value
    R: b is set value for 'b'
