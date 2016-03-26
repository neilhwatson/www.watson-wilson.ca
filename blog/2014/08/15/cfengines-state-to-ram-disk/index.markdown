---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
  post_type: post
  wp_menu_order: 0
  wp_post_id: 961
  wp_post_name: cfengines-state-to-ram-disk
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/cfengines-state-to-ram-disk/
date: 2014-08-15 16:53:50
status: published
title: CFEngine's state to ram disk
---
[caption id="attachment_963" align="alignright" width="656"][![Load stats after moving state to ram disk.](http://watson-wilson.ca/static/images/cfengine_state_on_ram.png)](http://watson-wilson.ca/static/images/cfengine_state_on_ram.png)
Load stats after moving state to ram disk.[/caption]

Earlier this year I mounted /var/cfengine/state to a ram disk . The
load change was dramatic, but there are draw backs. A reboot will lose
promise locks, so any long ifelapsed jobs will run on cf-agent's next
run. The folks at [Normation](http://normation.com) tried this [too.](http://blog.normation.com/en/2013/09/09/speed-up-your-cfengine-by-using-a-ram-disk/)
