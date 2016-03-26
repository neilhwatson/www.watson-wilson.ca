---
author: nwatson
data:
  categories:
    - content: best practices
      domain: category
      nicename: best-practices
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
  wp_post_id: 945
  wp_post_name: cfengine-best-practices-part-2
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/cfengine-best-practices-part-2/
date: 2014-07-18 09:57:02
status: published
tags:
  - best practices
  - Cfengine
  - delta reporting
  - EFL
title: 'CFEngine best practices: part 2'
---
![stormtrooper-apple](http://watson-wilson.ca/wp-content/uploads/2014/07/stormtrooper-apple.jpg)

Continuing on from [testing best practices](http://watson-wilson.ca/cfengine-best-practices-testing/),
let's look at other best practices to make you a CFEngine ninja.

---

#### Thinking CFEngine  ####

CFEngine is different. It took me a while to understand it. It was a
lot like calculus. In the beginning my brain exploded, but later it
began to understand. I was enlightened. Let me tell you what I've
learned about CFEngine.

##### Don't think procedurally #####

CFEngine's declarative language requires a different approach to
development than scripting. Let's break the shackles of procedure and
declare our promises! Don't think 'what steps do I take to make this
configuration?' CFEngine is designed to use its own built in procedures
to reach your goal. A promise declares what you want, not how to get
there.

In this example script we have to mentally parse it to understand the
end result.

Figure 1: A script is, a script. ` `

    #!/bin/sh
    
    cp /var/templates/resolve.conf /etc/resolv.conf
    chown root:root /etc/resolv.conf
    chmod 644 /etc/resolv.conf
          

In a CFEngine promise, we state our end result, and CFEngine uses its
own built in code to make it happen.

Figure 2: A clear promise no politician would make. ` `

    files:
       "/etc/resolv.conf"
           perms     => mog( "644", "root", "root" ),
           copy_from => remote_cp( "/var/cfengine/temps", "${sys.policy_server}" );
          

##### Focus on the end goal #####

When you begin to write a promise or a bundle of promises focus on the
end goal. What is the ideal state you're trying to reach? Describe it
in your language, and then in the CFEngine language. Before you know it
you'll have a prototype and you did not need a procedure.

##### Think of CFEngine promises #####

Everything going on in a modern operating system can be described in
terms of files, commands, and processes; and CFEngine promises are the
same. Whatever your end goal is, break into these low level concepts
and the promises you need will be obvious.

##### Less is more #####

Beginners often don't realize how much CFEngine can figure out
automatically. Don't try to box in your policies with too many
restrictions. Start very simply and the results will surprise you.

#### Build reusable bundles ####

Use generic bundles that accept parameters much like functions in other
languages. Your bundles should generic enough to be reusable.

#### Data separation ####

Try to separate policy from data whenever possible. Data separation
makes policy maintenance faster and simpler. Read in parameter files.
Use template files. [EFL](https://github.com/evolvethinking/evolve_cfengine_freelib)
has many such examples for your reference.

#### Promise whole files ####

Speaking of template files, I always favour them over policies that
only promise selected lines inside an existing file. The trouble with
promising only a portion of the file is, what if the rest of the file
is corrupt? Don't go half way. Deliver a complete promise and your boss
will thank you.

#### Readability ####

Readability over efficiency. I said it. Code junkies everywhere just
sucked in a great breath. CFEngine is not a procedural language, but
there are some procedural aspects to it, like class dependencies and
the depends_on attribute. The more you reduce the code in the name of
efficiency it often becomes very hard to understand. Use comment,
handle, and tag attributes to document your promises and use meta
promises to document your bundles. One of the great things about
CFEngine is that once it is working you seldom have to revisit your
promises, but when you do you'd better be able to understand them.

#### Naming conventions ####

I encourage you to seek out the many readily available CFEngine
frameworks that offer a vast collection of ready to use promises and
bundles. Don't reinvent the wheel. If you do write your own policies
name them well.

##### Bundle names #####

You may have multiple bundles that are similar in function, so naming
the first one *ssh* may not be a good idea. Use more descriptive names.
One large organization I worked with had bundles written by many
departments. They used a numbering system like ssh_1122. I prefer using
bundles names that imply the bundle's intent; *Ssh_for_dmz* is much
clearer than *ssh_by_neil*.

##### Handle names #####

Handles must be unique. A popular naming convention in the CFEngine
community is *bundlename_promisetype_class_promiser*.

Figure 3: Handle names ` `

    bundle agent efl_main( ref )
    
    methods:
       "methods loop wrapper"
          comment    => "Call wrapper bundle to workaround naked variable bug.",
          handle     => "efl_main_methods_loop_wrapper";
    
    bundle agent efl_command ( ref )
    
       commands:
          "${${command[${c}]}}" -> { "${${promisee[${c}]}}" }
             comment    => "Run desired command",
             handle     => "efl_command_commands",
          

##### Class names #####

Classes should be named on discovery for inventory purposes or intent
if a class will trigger an action. A Class that identifies hosts in a
dmz might be *dmz_172_16_4_hosts*. Production web servers might be in
the class *prod_myapp_webservers*.

Some classes are about intent or action. A class defined to restart an
application should be named restart_web_server or restart_snmpd. Since
classes can be global be specific in your names to avoid name
collisions. Sometimes I like to prefix the class with the bundle name
so I know where it came from. There is something called *namespace* in
CFEngine, but I find that too complex. For me simple prefixes suffice.

#### Use separate promises for file permissions and content. ####

It's common to promise file permissions and content in a single
promise, but what if the promiser file is sshd_config? If you have a
follow up promise to restart sshd if sshd_config changes that restart
will be triggered even by a permission only repair. Separate these into
two promise to avoid this disruptive behaviour.

#### Embrace normal ordering ####

Promise types are considered by the agent in a set order. This is
called normal ordering and you cannot change it. Vars are evaluated
before classes, and both of these before files. You can delay promise
evaluation by using depends_on or classes, but if you find that you are
working very hard and wish that you could change normal ordering then
your approach is wrong. Go back to the beginning and try again.

#### Use shell commands sparingly ####

Shell commands in variables, classes, or commands promise force the
agent to start a partial or even full shell. This is expensive and a
common cause of slow running policies. Use the shell sparingly.

##### Beware the shell environment #####

Like crond, CFEngine's environment when it starts a shell process is
different than your shell environment. Test carefully.

##### Don't use command promises to cheat #####

Some folks, unable to get the promise they want, resort to using a
commands promise to call a script. Shell commands slow the agent down
and you must rely on the quality of the script, and not CFEngine, to
determine promise success.

#### Avoid promises that are too broad ####

The more precise your promise is the more certain you can be of its
success. Promises that are too broad, like bulk, recursive file
permissions, can affect files you did not think about.

#### Don't mess with update.cf or failsafe.cf ####

In CFEngine's default policy update.cf, previously called failsafe.cf,
allows the agent to pull new policy from the policy server. If
promises.cf or related files have errors the agent may not run, but
update.cf is separate and will allow the agent to download corrected
files when they are available. If update.cf has an error, however,
there is no mechanism to get repairs, and you'll have to fix *every
host by hand*. If you choose to modify update.cf and related files,
test *very carefully*.

An error in promises.cf or related files might cause cf-exed to fail,
preventing update.cf from being run. I use a backup cron job to call
update.cf directly.

Figure 4: cron contingency ` `

    cf-agent -f update.cf && cf-agent
          

You may recognize this, it is similar to the run command in cf-execd's
control body. I also go a step further and configure a bootstrap
process if the update fails.

Figure 5: A better contingency ` `

    (cf-agent -f update.cf || cf-agent -B ) && cf-agent
          

#### Summary ####

This ends the second part of my best practices with CFEngine. Let's
review.

  * Do not think procedurally, instead declare your intentions as
    CFEngine promises.

  * Less is more, leave decisions on how to do something to CFEngine.

  * Focus on the end goal, not the procedure.

  * Build reusable bundles.

  * Separation data form policy.

  * Promise whole files and not just a portion of a file.

  * Make your policy readable.

  * Use naming conventions for bundles, handles, and classes.

  * Use separate promises for file permissions and content.

  * Embrace normal ordering.

  * Use shell commands sparingly.

  * Beware the shell environment.

  * Don't use command promises to cheat.

  * Avoid promises that are to broad.

  * Don't mess with update.cf or failsafe.cf

#### Frameworks ####

The CFEngine ecosystem has never been stronger. There are so many
choices in ready to use policies. Take advantage of these.

  * CFEngine ships with a good [base framework](https://docs.cfengine.com/docs/3.6/guide-writing-and-serving-policy-policy-framework.html)
    and also offers the [Design Center](https://docs.cfengine.com/latest/reference-design-center.html).

  * [NCF](http://www.ncf.io/) by [Normation](http://normation.com).

  * [Dynamic Cfengine3](http://wiki.webhuis.nl/index.php/Dynamic_Cfengine3)
    by [WebHuis](http://webhuis.nl/).

  * Brian Bennett's [framework](https://digitalelf.net/blog/categories/cfengine/).

  * [Evolve Thinking's free library (EFL)](https://github.com/evolvethinking/evolve_cfengine_freelib)
    contains a large collection of ready to use, scalable promises. It
    is portable, able to work with CFEngine's base framework or any
    other policy you use. EFL also powers [Delta Reporting](http://watson-wilson.ca/products/delta-reporting/)
    an open source reporting tool for CFEngine.
