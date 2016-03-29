---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
    - content: mustache
      domain: category
      nicename: mustache
  post_type: post
  wp_menu_order: 0
  wp_post_id: 1089
  wp_post_name: mustache-template-in-cfengine
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/mustache-template-in-cfengine/
date: 2015-03-26 10:59:43
status: published
tags:
  - cfengine
  - mustache
title: Mustache template in CFEngine
---


Here's a quick example of how to use mustache templates in CFEngine.

---

The policy

    body common control
    {
            bundlesequence => { "main", };
    }
    
    bundle agent main
    {
       vars:
          solar_system::
             "home_star" string => "sol";
             "planets" slist => { "mercury", "venus", "earth" };
             "a[moon]" string => "luna";
    
          star::
             "a[star]" slist => { "rigel", "vega", "polaris" };
    
          earth::
             "earth" data => parsejson('
             [
                { 
                   "oceans" : [ "atlantic", "pacific", "indian", "arctic" ],
                   "seas" : [ "caribbean", "dead", "black", "coral" ],
                   "position" : "3",
                   "orbit" : "1au",
                }
             ]
             ');
             
       files:
          "/tmp/mytemplate"
             create          => 'true',
             template_method => 'mustache',
             edit_defaults   => empty,
             edit_template   => '${sys.workdir}/inputs/mustache.tmp';
    }
    
    body edit_defaults empty
    {
       empty_file_before_editing => 'true';
    }

The template 

    This file is edited by CFEngine and is always in place.
    
    {{#classes.solar_system}}
    The star is {{vars.main.home_star}}.
    {{#vars.main.planets}}{{.}} is a planet.
    {{/vars.main.planets}}
    
    But {{vars.main.a[moon]}} is a moon.
    {{/classes.solar_system}}
    
    {{#classes.star}}
    Some stars are:
    {{#vars.main.a[star]}}{{.}}, {{/vars.main.a[star]}}.
    {{/classes.star}}
    
    {{#classes.earth}}
    {{#vars.main.earth}}
    Earth is planet number {{position}}, at an orbit of {{orbit}}.
    Oceans include {{#oceans}} {{.}},{{/oceans}}.
    Seas include {{#seas}} {{.}},{{/seas}}.
    {{/vars.main.earth}}
    {{/classes.earth}}

As always, my best practice is to empty the original file and start
fresh. Editing files in place can lead to problem. Also, note that I do
not use the in-line *template_data*. I prefer to define my data
elsewhere, in this case vars, to make the promise more reusable. Other
notable details are:

  * `{{#classes.solar_system}}` starts the beginning of a class block.
    Unlike CFEngine's normal code this block must be ended with `{{/classes.solar_system}}`.
    Everything in-between is evaluated when the class *solar_system* is
    true.

  * Strings take the form of `{{vars.bundle.name}}` as seen in `{{vars.main.home_star}}`
    and `{{vars.main.a[moon]}}`. It's best to avoid arrays and use JSON
    data containers instead. Arrays in CFEngine are not first class
    data objects. They are specially named strings that are parsed to
    be identified as pseudo arrays.

  * `{{#vars.main.planets}}` starts the iteration of the list *main.planets*.
    Everything between that and `{{/vars.main.planets}}` will be
    duplicated for each element in the list. Each element will be
    printed where `{{.}}` is found.

  * `{{#vars.main.earth}}` tells the agent to begin iterating through
    the JSON data container called *earth*. From there you can use
    short forms of the JSON data like `{{position}}` for the string *position*
    and `{{#oceans}} {{.}},{{/oceans}}` for the list oceans and the
    element position.

  * Note that unlike old style CFEngine templates, mustache templates *will
    print all duplicate lines*.

The resulting file

    This file is edited by CFEngine and is always in place.
    
    The star is sol.
    mercury is a planet.
    venus is a planet.
    earth is a planet.
    
    But luna is a moon.
    
    Some stars are:
    rigel, vega, polaris, .
    
    Earth is planet number 3, at an orbit of 1au.
    Oceans include  atlantic, pacific, indian, arctic,.
    Seas include  caribbean, dead, black, coral,.
