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
    - content: software testing
      domain: category
      nicename: software-testing
  post_type: post
  wp_menu_order: 0
  wp_post_id: 919
  wp_post_name: cfengine-best-practices-testing
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/cfengine-best-practices-testing/
date: 2014-07-04 21:10:32
status: published
tags:
  - best practices
  - cfengine
  - delta reporting
  - software testing
title: 'CFEngine best practices: testing'
---
![f4-crashtest](/static/images/f4-crashtest.jpg)

CFEngine's autonomous automation means that your policy, mistakes and
all, will be duplicated quickly to all of your hosts. --- Potentially
tens of thousands of them. When I taught martial arts it was humbling
to watch a class of thirty duplicate my incorrect movement. I didn't
know, because I didn't test myself. In martial arts I was simply
embarrassed, but in configuration management, mistakes could cost me a
raise or even my job. Testing is the paramount best practice for
CFEngine. Let me tell you what I have learned.

---

#### Prototyping ####

Your first kernel of a policy idea should be demonstrated with a small,
self contained, prototype. Try to keep your prototype to a single file.
If you need bundles or bodies from policy libraries, copy just what you
need from them into your prototype file. There are good examples on the
Internet get you started.

  1. The [Vim CFEngine plugin](https://github.com/neilhwatson/vim_cf3)
    has a built in skeleton policy file. In command mode ,k will insert
    the skeleton into the current buffer. This plugin's syntax
    highlighting will alert you about missing quotations and other
    syntax issues. If you are in the church of Emacs, there is an Emacs
    CFEngine plugin elsewhere on the web (its home is nebulous so I
    provide no link).

  2. CFEngine ships with many self contained examples that you can
    study. They are located in share/doc/examples in CFEngine's work
    directory (typically /var/cfengine).

Figure 1: Standalone unit test that ships with CFEngine.

      ettin:/var/cfengine/share/doc/examples# cat unit_depends_on.cf
      body common control
      {
      bundlesequence => { "one"  };
      }
      
      bundle agent one
      {
      reports:
      
       cfengine_3::
      
         "two"
           depends_on => { "handle_one" };
      
         "one"
           handle => "handle_one";
      
      }

  3. Many [CFEngine bug reports](https://dev.cfengine.com/projects/core/issues)
    (especially mine) contain good self contained examples. Indeed, if
    you report CFEngine bugs, be sure to include a small prototype to
    demonstrate the undesired behaviour.

#### Formal testing ####

Use real test plans. Don't just test that your policy works, prove it.
You can even use CFEngine for unit testing. Let's look at an example.
In practice I recommend you use the
[Free Promise Library(EFL)](https://github.com/neilhwatson/delta_reporting), or
some other policy framework, because they have ready to use policies
that will save you a lot of time, but for this example we'll keep it
small and hand made. I want you to see the concept rather than the
actual implementation.

We want a policy that will start a service if it is not running. Start
by breaking this down into basic components that translate into
CFEngine promises. Another best practice with CFEngine is to think in
terms of processes, commands, and files. Virtually everything in UNIX
is one of those three things. We can restate out example as promising
to run a command if a process is not found. In this example our process
is *sleep 99* and the command is */tmp/proto.sh*.

Here's my prototype. Note the *init* bundle, I use that to promise our
service start script. By including it here my prototype is self
contained. The bundle *proto* promises to define the class *start_service_proto_sh*
if the process *sleep 99* is not found. The commands process runs our
init script from the init bundle if the class *start_service_proto_sh*
is true. Also, note that the body parts at the bottom are copies of
bodies from the standard CFEngine library, except the *by_command* body
which is from [EFL](https://github.com/neilhwatson/delta_reporting).

Figure 2: My first prototype. 

    body common control
    {
            bundlesequence => { "main", };
    }
    
    bundle agent main
    {
            methods:
    
                    "Initialize prototype" usebundle => init;
                    "My prototype" usebundle => proto; 
    }
    
    bundle agent init
    {
       meta:
          'Purpose' string => 'Initialize prototype service script';
    
       vars:
          'service_script[location]' string => "/tmp/proto.sh";
          'service_script[contents]' string =>
    "#!/bin/sh
    exec 1>&- # close stdout
    exec 2>&- # close stderr
    sleep 99 > /dev/null &
    
    exit 0
    ";
    
       files:
          "${service_script[location]}"
             comment       => "Promise working script for testing",
             create        => 'true',
             perms         => m('755'),
             edit_defaults => empty,
             edit_line     => insert_lines( ${service_script[contents]} );
    }
    
    bundle agent proto
    {
       meta:
          'Purpose' string => "Promise to start service if not running.";
    
       processes:
          "sleep 99"
             comment        => "Test for desired process",
             process_select => by_command( "\Asleep 99\Z" ),
             restart_class  => "start_service_proto_sh";
    
       commands:
          start_service_proto_sh::
             "${init.service_script[location]}"
             contain => in_shell;
    }
    
    body contain in_shell
    {
       useshell => "true";
    }
    
    body edit_defaults empty
    {
       empty_file_before_editing => "true";
       edit_backup => "false";
    }
    
    bundle edit_line insert_lines(lines)
    {
       insert_lines:
    
          "$(lines)"
          comment => "Append lines if they don't exist";
    }
    
    body perms m(mode)
    {
       mode   => "$(mode)";
    }
    
    body process_select by_command( command )
    {
            command        => "${command}";
            process_result => "command";
    }
       

Note that in the processes promise I use the *process_select*
attribute. This may seem a duplicate of the promiser itself, but the
difference is subtle. The promiser is matched against the entire line
from a ps command. The process_select body uses the *command* attribute
to match against the ps command's command column only. I also anchor
the regular expression with \A and \Z. These extra details reduce the
chances of false positive matching.

During the process of writing this policy I frequently used the
CFEngine program *cf-promises* to test my syntax.

Figure 3: Testing syntax

   neil@ettin ~/.cfagent/inputs $ cf-promises -cf ./service.cf 
   neil@ettin ~/.cfagent/inputs $ echo $?
   0
       

If there was an error cf-promises would have shown it to me, and it
would have returned a none zero status.

Cf-promises will give line numbers to indicate the location of your
error, but the error is often located at the line *before* the given
line. Also, one error can result in a cascade of errors, so start with
the first error listed.

Let's run our test. It's important to know our expected results. If *sleep
99* is not running I expect proto.sh to be run. If sleep 99 is running
I expect nothing to happen. Let's try it.

Figure 4: Our first prototype run 

    neil@ettin ~/.cfagent/inputs $ cf-agent -KIf ./service.cf ; ps -ef |grep sleep ;cf-agent -KIf ./service.cf
    2014-07-03T19:48:21-0400     info: /default/main/methods/'My prototype'/default/proto/processes/'sleep 99'[0]: Making a one-time restart promise for 'sleep 99'
    2014-07-03T19:48:21-0400     info: /default/main/methods/'My prototype'/default/proto/commands/'/tmp/proto.sh'[0]: Executing 'no timeout' ... '/tmp/proto.sh'
    2014-07-03T19:48:21-0400     info: /default/main/methods/'My prototype'/default/proto/commands/'/tmp/proto.sh'[0]: Completed execution of '/tmp/proto.sh'
    neil     102836      1  0 19:48 pts/6    00:00:00 sleep 99
    neil     102838  35478  0 19:48 pts/6    00:00:00 grep --color=auto sleep
       

Success! This is a good first prototype, but I want more and continuous
testing. Now, I'll add a unit test that makes the agent break its own
configuration. I add this bundle to our prototype file and change the
methods in the main bundle.

Figure 5: Adding a unit test 

    ## Change main bundle:
    bundle agent main
    {
       methods:
    
          "Initialize prototype" usebundle => init;
    
          unit_01::
             "unit_01" usebundle => unit_01;
    
          any::
             "My prototype" usebundle => proto; 
    }
    
    # Added unit test bundle
    bundle agent unit_01
    {
       meta:
          'Purpose' string => "Kill process unit test";
    
       processes:
          "sleep 99"
             comment        => "Test for desired process",
             process_select => by_command( "\Asleep 99\Z" ),
             signals        => { "term", "kill" };
    }
       

Now we have a bundle *unit_01* that is called when the same named class
is true. This will kill the sleep 99 process forcing the proto bundle
to restart it.

Figure 6: Unit test in action.

    neil@ettin ~/.cfagent/inputs $ cf-agent -KIf ./service.cf -D unit_01 ; ps -ef|grep sleep
    2014-07-03T19:15:06-0400     info: /default/main/methods/'unit_01'/default/unit_01/processes/'sleep 99'[0]: Signalled 'term' (15) to process 107369 (neil     107369      1 107360  0.0  0.0   4216   0   356    1 19:14 00:00:00 sleep 99)
    2014-07-03T19:15:06-0400     info: /default/main/methods/'unit_01'/default/unit_01/processes/'sleep 99'[0]: Signalled 'kill' (9) to process 107369 (neil     107369      1 107360  0.0  0.0   4216   0   356    1 19:14 00:00:00 sleep 99)
    2014-07-03T19:15:06-0400     info: /default/main/methods/'My prototype'/default/proto/processes/'sleep 99'[0]: Making a one-time restart promise for 'sleep 99'
    2014-07-03T19:15:06-0400     info: /default/main/methods/'My prototype'/default/proto/commands/'/tmp/proto.sh'[0]: Executing 'no timeout' ... '/tmp/proto.sh'
    2014-07-03T19:15:06-0400     info: /default/main/methods/'My prototype'/default/proto/commands/'/tmp/proto.sh'[0]: Completed execution of '/tmp/proto.sh'
    neil     107437      1  0 19:15 pts/6    00:00:00 sleep 99
    neil     107439  35478  0 19:15 pts/6    00:00:00 grep --color=auto sleep
       

For a more complex policy you can have multiple scenarios that must be
repaired, each one being a separate unit test.

#### Large scale testing ####

In a prefect world we are all running a single flavour of UNIX. When
you find this utopia [tweet me](https://twitter.com/neil_h_watson)!.
Until then we must test our policy on all our different host types. In
a really small shop you may manually copy your prototype, conveniently
a single file, to your different hosts types and run it on each.

The rest of us are not so fortunate and will have to test our policy on
more than a few hosts. A less manual approach is to integrate this
prototype into your main policy, but only run it on select hosts. Then
you can check each host to see if it is working. If you are using
central reporting tools like [Rudder](http://www.rudder-project.org), [CFEngine
Enterprise](http://cfengine.com/) or [Evolve's](http://watson-wilson.ca)
own [Delta Reporting](https://github.com/neilhwatson/delta_reporting)
you'll be able to get reports showing your prototype in action on all
of your test hosts.

Figure 7: Delta Reporting showing an ntp process promise on multiple
hosts [![Reporting on ntp process promises](/static/images/dr-process-report.png)](/static/images/dr-process-report.png)

#### Summary ####

This ends my entry on testing best practices. Let's review.

  1. Start with simple prototypes.

  2. Use editor plugins.

  3. Check syntax with cf-promises.

  4. Test formally, including unit tests.

  5. Test on multiple architectures. Use reporting for scale.
