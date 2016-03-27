---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
  post_type: post
  wp_menu_order: 0
  wp_post_id: 617
  wp_post_name: experimental-and-coming-soon-features-in-cfengine
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/experimental-and-coming-soon-features-in-cfengine/
date: 2013-09-11 10:00:29
status: published
tags:
  - Cfengine
title: Experimental and coming soon features in CFEngine
---


Pull requests for CFEngine Core, at [Github](https://github.com/cfengine/core/pulls),
and CFEngine's [issue tracker](https://cfengine.com/dev/projects/core)
show some interesting proposals for future versions of CFEngine. Here's
a quick summary for you.

---

#### [TLS encryption](https://github.com/cfengine/core/pull/925) ####

The proposal is to replace the current transmission encryption of
CFEngine with the standard TLS protocol. I'm told that this transition
will be transparent and that CFEngine will fall back to the old
protocol automatically if required.

#### [LMDB replacing TCDB](https://github.com/cfengine/core/pull/325) ####

OpenLDAP's Lightning Memory-Mapped Database will replace TokyoCabinet.
TokyoCabinet was disappointing in its reliability. A better DB will be
welcome.

#### [JSON data containers](https://cfengine.com/dev/issues/3279) ####

If you use CSV files with CFEngine, like Evolve's own [free promise
library](http://watson-wilson.ca/evolve-thinkings-free-cfengine-library/),
you know that large CSV files can be cumbersome. Data represented in
JSON format will be easier to manage.

#### [Includes](https://cfengine.com/dev/issues/3323) ####

There's a proposal to allow include type statements in CFEngine policy
files. This will allow more dynamic policies.

It's too early for me to say when or if we'll see these features in
real life. If they interest you and you have an opinion about them now
is the time to voice it.
