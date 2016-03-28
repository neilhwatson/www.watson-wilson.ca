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
  wp_post_id: 951
  wp_post_name: cfengine-best-practices-deployment-upgrades-and-scaling
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/cfengine-best-practices-deployment-upgrades-and-scaling/
date: 2014-08-07 09:02:57
status: published
tags:
  - best practices
  - cfengine
  - delta reporting
  - EFL
title: 'CFEngine best practices: deployment, upgrades, and scaling'
---
![sts-atlantis](/static/images/sts-atlantis.jpg)

Part 3 of CFEngine best practices.

---

#### Version control ####

Put your CFEngine policy and supporting programs, data files, and
documentation into version control. Like any other code you'll benefit
from knowing its history. You can use branches to promote new policy
from testing to production. I recommend using three branches: dev, qa,
and production. Have servers and agents dedicated to each branch. The
greater the variety of hosts in each branch, the greater the chance of
catching bugs early. Always edit code in development only and promote
those changes to qa and then production.

I frequently use cf-agent to pull new policy into masterfiles directly
from version control. This provides automatic deployment upon commit. [EFL](https://github.com/evolvethinking/evolve_cfengine_freelib)
has a ready to use bundle, *efl_rcs_pull* to handle RCS pulls, and it
works with most RCS products.

#### Upgrading from CFEngine 2 ####

Because CFEngine 3 is not backwards compatible with CFEngine 2 the
upgrade path is steep and rocky. Many are just now starting this climb.
The best upgrade path is to set up separate CFEngine 3 servers, and
install CFEngine 3 on your clients while continuing to use CFEngine 2.
CFEngine 2's *cfagent* can run in parallel with the CFEngine 3 *cf-agent*.
The two versions do not share any common files so there is no overlap.
They do share common directories; the most important is inputs.

When you bootstrap CFEngine 3, using its built in bootstrap feature,
cf-agent will delete all files in inputs including any related to
CFEngine 2. If you want to run 2 and 3 in parallel you'll need a
wrapper script around CFEngine 3's bootstrap process to backup and
restore CFEngine 2's inputs. [here](https://tracker.mender.io/browse/CFE-959)
is an interesting discussion on this topic. With both agents running in
parallel you can reduce your CF2 policy and increase your CF3 in
gradually.

#### Upgrading from CFEngine 3.n to 3.n+1 ####

##### Steps to upgrading CFEngine, hyperbole

  1. Test

  2. Test

  3. Repeat previous steps

As I said in [part 1](http://watson-wilson.ca/cfengine-best-practices-testing/)
of this series, mistakes in CFEngine will be horrifyingly duplicated to
all of your hosts. This can be a career limiting event. A new version
of CFEngine can expose pre-existing bugs in your policy, or introduce
its own new bugs. An example of the former: in version 3.5.0 the syntax
checker became more strict, reporting errors that previous versions
missed. Examples of the latter include many fixed and outstanding
regression bugs. Trust is earned. Make CFEngine, and any other
software, earn your trust. Here's a more practical approach to
upgrading.

##### Steps to upgrading CFEngine, practical

  1. Keep watch on CFEngine bug and mailing list traffic.

  2. Keep policy compatible with both old and new versions until entire
    upgrade is complete.

  3. Upgrade the development server.

  4. Upgrade clients in batches.

  5. Repeat server and client upgrade steps for qa and production.

As release candidates come out, you'll get a chance to experience and
see what others experience with the proposed new version. Watch the
bugs that get resolved and those that remain open. There may be new
syntax or features that are not compatible with your current version of
CFEngine. Do not consider these until after the upgrade. Be sure your
policy runs properly on both versions. When you are ready to take the
plunge, upgrade the server first. When it passes all tests proceed with
clients, in small batches, enlarging the batches as you gain
confidence.

Reporting tools like [Delta Reporting](https://github.com/evolvethinking/delta_reporting)
log the promise and class status of all your agent hosts. This
information can help you spot problems in your upgrade and in normal
production.

Figure 1: Delta Reporting showing an ntp process promise on multiple
hosts
[![Reporting on ntp process promises](/static/images/dr-process-report.png)](/static/images/dr-process-report.png)

#### Upgrading policy ####

New versions of CFEngine ship with new base policy. The base policy is
in its own [repository](https://github.com/cfengine/masterfiles) so you
can upgrade it between CFEngine releases. Merging this new policy with
your existing one is always tedious, but your regimented use of version
control will make this easier. To reduce the merging work limit the
amount of changes you make to the shipped policy. I usually only
changes inputs, bundlesequence (to call my master methods bundle), and
variables and options set in *def.cf*.

Tip If you plan to use CFEngine on an IPV6 interface, beware that the
default policy will not work. You must change the server control body,
setting *bindtointerface* to a double colon (::). See [here](https://github.com/cfengine/masterfiles/pull/152)
and [here](https://docs.cfengine.com/latest/reference-components-cf-serverd.html#bindtointerface)
for more information.

#### Handling many clients with a single server ####

A single server can handle thousands of CFEngine clients, but there are
tricks to extend that number further. This simplest is splaytime. The
schedule daemon cf-exed checks its current hard classes versus the time
classes specified in its control body schedule attribute. If there is a
match, the *exec_command* is run. If you have a thousand hosts all of
them will start at the same time causing the server needless load and
dropped connections. Splaytime is set in cf-execd's control body. Each
agent generates a deterministic time between zero and splaytime minutes
and waits that amount of time before running the exec_command. Thus
your agent starts are splayed. Always set splaytime to the interval or
your run schedule less one minute.

Cf-serverd is a file server. Some agent promises can request a lot of
files from the server. To reduce this load, reduce the frequency of
these promises. Use the *ifelapsed* action body attribute. An ifelapsed
of 60 means the agent will not evaluate the promise more than once
every 60 minutes. This feature can also reduce agent load by running
high load promises, like packages, less frequently.

#### Redundant CFEngine servers ####

It would be nice if we could bootstrap an agent to multiple servers.
Sadly, this feature does not exist at this time, but you can [vote for
it](https://tracker.mender.io/browse/CFE-941). In the mean time we must
perform some tricks to make the agent contact redundant policy servers.

A *copy_from* body has a servers attribute that takes a list argument.
In spite of having no multi-server bootstrap, the agent can already
talk to multiple servers by populating the servers list. The agent
tries each server in the list, in order. Set your policy to randomize
this list using the *shuffle* function and you add load balancing.

The trouble with having no multi-server bootstrap is that we are left
to handle key exchanges between agents and multiple servers. There are
multiple ways to do this. I won't go into detail here, but give you a
high overview instead.

Recall that for agent and server to trust each other there must be
access promises, each must have the other's public key stored in the
ppkeys directory, and the server's allowconnects and allowallconnects
must include the agent. You can have all redundant servers share the
same private keys or give them separate keys. Either way you'll need to
sync some or all of the ppkeys directory between the servers so that
each has a copy of all agent public keys. Also, ensure that each client
has a copy of each server's public key.

#### Make policy that makes the agent self reliant ####

In spite of all your efforts, at some point your agents will not be
able to reach the server. What then? The agents will not be able to
fetch new policy, but they should be able to run existing policy if the
policy is robust enough. One best practice is to cache files that are
copied from the server. Rather than promising the final promiser file
direct from the policy server, promise the file from the policy server
to a cache location (/var/cache/cfengine/), then promise from the cache
location to the final location. If the server is unreachable the agent
cannot promise any new files, but it can continue to promise existing
ones.

Figure 2: Caching source files 

    files:
       "${efl_c.cache}/${${config_file[${s}]}}" -> { "${${promisee[${s}]}}" }
          comment => "Cache the source file",
          handle => "efl_service_files_cache",
          create => "true",
          copy_from => efl_cpf( "${${source_file[${s}]}}", "@{${${server[${s}]}}}" );
    
       "${${config_file[${s}]}}" -> { "${${promisee[${s}]}}" }
          comment => "Promise contents of configuration file from the cache",
          handle => "efl_service_files_config",
          create => "true",
          copy_from => efl_cpf( "${efl_c.cache}/${${config_file[${s}]}}", "localhost" );
       

#### Limiting agent input files ####

When using CFEngine's bootstrap feature all the contents of the
server's masterfiles directory is copied to the agent's inputs
directory. You may want to limit which input files are copied. A good
approach is to keep only the most basic files in masterfiles, including
policy for the agent to download other files from directories *outside*
of masterfiles.

You should only try to limit files that contain private information,
the same information what you would encrypt. Try not to be too paranoid
about limiting inputs because it adds complexity.

How will you restrict agent access to private data? You cannot use
classes because any agent can have any class using the -D command
switch. You must limit access using server access promises.

#### Summary ####

  1. Use version control, everywhere.

  2. CFEngine 2 and 3 can run in parallel for gradual migration.

  3. Upgrade policy and CFEngine 3 with extensive planning and testing.

  4. Use splaytime and ifelasped to reduce agent and server load.

  5. Make CFEngine policy servers in redundant pairs.

  6. Make policy reliable even when the server is unavailable.

  7. You can limit selected inputs to agents, but do so with caution.
