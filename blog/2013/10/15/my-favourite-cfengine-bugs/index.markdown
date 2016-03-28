---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
  post_type: post
  wp_menu_order: 0
  wp_post_id: 663
  wp_post_name: my-favourite-cfengine-bugs
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/my-favourite-cfengine-bugs/
date: 2013-10-15 17:47:44
status: published
tags:
  - cfengine
title: My 'favourite' CFEngine bugs
---


What follows is a list of CFEngine bugs, and work-arounds if I have
them, that affect projects I'm working on and may also affect yours.

---

### Vars policy is always 'free'. ###

Versions affect: 3.3.5 to 3.5.2

Variables are supposed to default to 'constant'. That is, its value
cannot be changed after initial definition. If you wish to change this,
you can set the variable promiser's policy to 'free' ([see here](https://cfengine.com/docs/3.5/reference-promise-types-vars.html#policy)).
A bug has broken this behavior, causing all vars to be set to 'free'. I
have no work around for this bug.

  * [https://cfengine.com/dev/issues/1492](https://cfengine.com/dev/issues/1492)

#  #

### Variables inside arrays are not expanded. ###

Versions affected: 3.4.1 to 3.5.2

The Evolve free promise library makes liberal use of parameter CSV
files that CFEngine interprets as arrays. If these CSV files contain
variable names a bug prevents them from being expanded. For a [work
around](https://cfengine.com/dev/issues/2333#note-6) you must populate
a new array with the contents of the old array. The Evolve free promise
library uses this workaround.

  * [https://cfengine.com/dev/issues/2333](https://cfengine.com/dev/issues/2333)

#  #

### Cannot use arrays for method calls ###

Versions affected: 3.4.0 to 3.5.2

In theory usebundle can point to an array. A bug prevents this. The
Evolve free library bundle ["efl_bug2638"](https://github.com/evolvethinking/evolve_cfengine_freelib/blob/master/masterfiles/lib/evolve_freelib.cf)
shows how to work around this.

  * [https://cfengine.com/dev/issues/2638](https://cfengine.com/dev/issues/2638)

#  #

### Promise outcome logging does not work. ###

Versions affected: 3.4.0 to 3.5.2

Promise action bodies have [log_string](https://cfengine.com/docs/3.5/reference-promise-types.html#log_string),
and [log_(repaired|kept|failed)](https://cfengine.com/docs/3.5/reference-promise-types.html#log_kept)
attributes that allow you to log the outcome of any promise. Bugs
prevent this logging of useful information. The work around I have is
to reconcile outcome classes, from classes bodies, with the results of
the action log. It is very messy involving external scripts.

  * [https://cfengine.com/dev/issues/1221](https://cfengine.com/dev/issues/1221)

  * [https://cfengine.com/dev/issues/1222](https://cfengine.com/dev/issues/1222)

#  #

### Agent verbose logging: promiser expansion, process matching, and
promisee misplacement. ###

Versions affected: 3.5.0 to 3.5.2

CFEngine 3.5 introduced a better verbose output including time stamps
and a more succinct output. Sadly this feature is too immature,
containing multiple bugs. The expansion of variable promisers does not
work. The promisee information is logged at the end of promise
evaluation rather than at the beginning (you'll find the comment and
handle at the beginning, but not promisees). Process matches in
processes promises are shown before the promiser. Verbose logs are now
more confusing than before. Legacy verbose logging, -lv, can help a
little, but some bugs affect both logging forms.

  * [https://cfengine.com/dev/issues/2934](https://cfengine.com/dev/issues/2934)

  * [https://cfengine.com/dev/issues/2636](https://cfengine.com/dev/issues/2636)

  * [https://cfengine.com/dev/issues/2637](https://cfengine.com/dev/issues/2637)

#  #

### Server verbose logging, file requests are not logged. ###

Versions affected: 3.5.0 to 3.5.2

Cf-server was also given the improved verbose logging. A bug prevents
the server from logging file copy request from cf-agents, making common
file copy debugging more difficult than before. Even the legacy verbose
output is missing this information. There is no work around.

  * [https://cfengine.com/dev/issues/3128](https://cfengine.com/dev/issues/3128)

#  #

### Repositories and old versions of CFEngine. ###

Versions affected: all but the latest.

New versions of CFEngine can have 'surprises'. Because of this, people
like to keep using old versions and migrate slowly to newer versions.
The CFEngine provided repositories only keep the latest version. If you
want to pin and install a specific CFEngine version you'll need to
create your own repository.

  * [https://cfengine.com/dev/issues/1879](https://cfengine.com/dev/issues/1879)

#  #

### IPV6 only bootstrap ###

Versions affected: 3.4.0 to 3.5.2

IPV6 provides the end to end connectivity that IPV4 cannot. I've [blogged](http://watson-wilson.ca/ipv6/)
about IPV6 including how to use and get IPV6. Evolve uses IPV6 in
production and development. Many programs already fully support IPV6,
but CFEngine is not yet one of them. Using the CFEngine policy that it
comes packaged with, you cannot bootstrap an agent host to an IPV6
server. The work around is to edit the provided failsafe.cf file
removing 'skipidentify' in the agent control body. Alternatively,
bootstrap by hand, copying keys and inputs manually.

  * [https://cfengine.com/dev/issues/3037](https://cfengine.com/dev/issues/3037)

#  #

### IPV6 only CFEngine Enterprise server ###

Versions affected: 3.4.0 to 3.5.2

In testing the other day I could not make the CFEngine Enterprise
Mission Portal function on an IPV6 only host. It seems that the web
application will not connect to the back-end database using IPV6. There
is no workaround.

### IPV6 website and repositories ###

Versions affected: All

CFEngine's website and package repositories have no IPV6 addresses. If
you have IPV6 only hosts you'll need a [6to4](http://en.wikipedia.org/wiki/6to4)
service, use [Normation's mirror](http://www.normation.com/en/cfengine-package-repositories),
or make your own mirror.

  * [https://cfengine.com/dev/issues/2379](https://cfengine.com/dev/issues/2379)

#  #
