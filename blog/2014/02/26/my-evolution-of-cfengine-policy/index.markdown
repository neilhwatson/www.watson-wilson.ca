---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
    - content: EFL
      domain: category
      nicename: efl
  post_type: post
  wp_menu_order: 0
  wp_post_id: 826
  wp_post_name: my-evolution-of-cfengine-policy
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/my-evolution-of-cfengine-policy/
date: 2014-02-26 10:32:53
status: published
tags:
  - cfengine
  - EFL
title: My evolution of CFEngine policy
---
![Evolution of fire](/static/images/fire-240.jpg)

My style and approach to CFEngine policy writing has evolved over the
years. Recently I discussion this with someone new to CFEngine. He was
on the same path I had taken, but a few steps behind. I hope he'll
evolve to the next stage or to a stage that is new to both of us. I'm
going to share with you the stages of my CFEngine evolution. Perhaps
you'll recognize yourself.

---

### Stage one, self contained bundles ###

My first approach to policy writing were logical bundles, each having a
single high level purpose. This simple approach helped me to learn
CFEngine's declarative and convergent nature.

    bundle agent ntp
    {
       packages:
          "ntpd"
             package_policy => "add",
             package_method => generic;
    
       files:
          "/etc/ntp.conf"
             copy_from => remote_dcp(
                "${sys.workdir}/sitefiles/ntp.conf", "${sys.policy_hub}" ),
             classes   => if_repaired( "restart_ntp" );
    
          "/etc/ntp.conf"
             perms => mog( "644", "root", "root" );
    
       processes:
          "ntpd"
             process_select => by_name( "^(/usr/sbin/)*ntpd" ),
             restart_classs => "restart_ntp";
    
       commands:
          restart_ntp::
             "/sbin/service ntpd restart"
                comtain => silent;
    }
    
    bundle agent ssh
    {
       packages:
          "sshd"
             package_policy => "add",
             package_method => generic;
    
       files:
          "/etc/sshd_conf"
             copy_from => remote_dcp(
                "${sys.workdir}/sitefiles/sshd_conf", "${sys.policy_hub}" ),
             classes   => if_repaired( "restart_ssh" );
    
          "/etc/sshd_conf"
             perms => mog( "644", "root", "root" );
    
       processes:
          "sshd"
             process_select => by_name( "^(/usr/sbin/)*sshd" ),
             restart_classs => "restart_ssh";
    
       commands:
          restart_ssh::
             "/sbin/service sshd restart"
                comtain => silent;
    }
    
    bundle agent security
    {
       files:
          "/etc/passwd"
             perms => mog( "644", "root", "root" );
    
          "/etc/shadow"
             perms => mog( "600", "root", "root" );
    
          "/tmp/."
             perms => mog( "777", "root", "root" );
    
    }

As I wrote more of these bundles I noticed how alike they were and how
much duplication I was suffering. There were package promises in each
service bundle plus another package bundle for packages not related to
services. If I changed something in one bundle, I often had to make the
same change in many bundles. I knew I had to move on to something more
efficient.

### Stage two, reusable method calls. ###

CFEngine's early documentation hinted at methods and reusable policy.
In those days the documentation was sparse and good examples were rare,
but after stage one I had many examples and I saw how methods could be
employed.

    bundle agent security
    ( path, mode, owner, group )
    {
       files:
          "${path}"
             perms => mog( "${mode}", "${owner}", "${group}" );
    }
    
    bundle agent service
    ( package, config_file, process, command, mode, owner, group )
    {
       packages:
          "${package}"
             package_policy => "add",
             package_method => generic;
    
       files:
          "${config_file}"
             copy_from => remote_dcp( "${sys.workdir}/sitefiles/${config_file}", "${sys.policy_hub}" ),
             classes   => if_repaired( "restart_${process}" );
    
          "${config_file}"
             perms => mog( "${mode}", "${owner}" "${group}" );
    
       processes:
          "${process}"
             process_select => by_name( "${process}" ),
             restart_classs => "restart_${process}";
    
       commands:
          "${command}"
             ifvarclass => canonify( "restart_${process}" ),
             comtain    => silent;
    }
    
    bundle agent main
    {
       vars:
          "service[ntp][package]"     string => "ntpd";
          "service[ntp][config_file]" string => "/etc/ntp.conf";
          "service[ntp][process]"     string => "^/usr/sbin/ntpd";
          "service[ntp][command]"     string => "/sbin/service ntp restart";
          "service[ntp][mode]"        string => "644";
          "service[ntp][owner]"       string => "root";
          "service[ntp][group]"       string => "root";
    
          "service[ssh][package]"     string => "openssh-server";
          "service[ssh][config_file]" string => "/etc/ssh/sshd_conf";
          "service[ssh][process]"     string => "^/usr/sbin/sshd";
          "service[ssh][command]"     string => "/sbin/service sshd restart";
          "service[ssh][mode]"        string => "644";
          "service[ssh][owner]"       string => "root";
          "service[ssh][group]"       string => "root";
    
          "svc" slist => getindices( "service" );
    
          "security[passwd][path]"  string => "/etc/passwd";
          "security[passwd][mode]"  string => "644";
          "secuirty[passwd][owner]" string => "root";
          "security[passwd][group]" string => "root";
    
          "security[shadow][path]"  string => "/etc/shadow";
          "security[shadow][mode]"  string => "600";
          "secuirty[shadow][owner]" string => "root";
          "security[shadow][group]" string => "root";
    
          "security[tmp][path]"  string => "/tmp/.";
          "security[tmp][mode]"  string => "777";
          "secuirty[tmp][owner]" string => "root";
          "security[tmp][group]" string => "root";
    
          "sec" slist => getindices( "security" );
    
       methods:
          "${service[${svc}][package]}"
             usebundle => service(
                "${service[${svc}][package]}",
                "${service[${svc}][confi_file]}",
                "${service[${svc}][process]}",
                "${service[${svc}][command]}"
                "${service[${svc}][mode]}"
                "${service[${svc}][owner]}"
                "${service[${svc}][group]}"
                );
    
          "${security[${sec}][path]}"
             usebundle => security(
                "${security[${sec}][path]}",
                "${security[${sec}][mode]}"
                "${security[${sec}][owner]}"
                "${security[${sec}][group]}"
                );
    }

There were further steps I could take to reduce the above code, but the
tedious variable syntax remained. I was so lazy, and still am, that
even the long list of methods promises drove me to find a better way.

### Stage three, reusable data driven policy. ###

CFEngine promise types are low level: files, processes, command,
packages, etc. My need for order drove me to group promises as I've
shown, but must I be so literal? Why can't I write policy at a similar
low level, but with conceptual rather than literal logical groupings?
This is when EFL was born. Low level reusable bundles driven by simple
data files. EFL has bundles similar to stage two, but more low level
and more flexible. There are bundles for package promises, services,
file permissions, and much more.

Here is the more condensed data for file permissions with less syntax.

#### efl_files_perms.json

    [
      {
         "leaf_regex" : ".*",
         "group" : "security",
         "negate" : "644",
         "owner" : "root",
         "file_promiser" : "/etc/passwd",
         "class" : "any",
         "mode" : "root",
         "recurse_level" : "no"
      },
      {
         "leaf_regex" : ".*",
         "owner" : "root",
         "group" : "security",
         "negate" : "600",
         "class" : "any",
         "file_promiser" : "/etc/shadow",
         "recurse_level" : "no",
         "mode" : "root"
      },
      {
         "leaf_regex" : ".*",
         "owner" : "root",
         "group" : "security",
         "negate" : "777",
         "class" : "any",
         "file_promiser" : "/tmp",
         "recurse_level" : "no",
         "mode" : "root"
      }
    ]


Here is the more condensed data for services with less syntax.

#### efl_services.json

    [
      {
         "template" : "no",
         "restart_cmd" : "/sbin/service ntp restart",
         "class" : "any",
         "config_file" : "/etc/ntp.conf",
         "server" : "efl_c.policy_servers",
         "config_file_src" : "${sys.workdir}/sitefiles/etc/ntp.conf",
         "promisee" : "ntp time sync",
         "mode" : "644",
         "owner" : "root",
         "encrypt" : "no",
         "group" : "root",
         "process_regex" : "^/usr/sbin/ntpd"
      },
      {
         "encrypt" : "no",
         "group" : "root",
         "mode" : "644",
         "owner" : "root",
         "process_regex" : "^/usr/sbin/sshd",
         "class" : "any",
         "config_file" : "/etc/ssh/sshd_conf",
         "template" : "no",
         "restart_cmd" : "/sbin/service sshd restart",
         "promisee" : "sshd remote access, security",
         "server" : "efl_c.policy_servers",
         "config_file_src" : "${sys.workdir}/sitefiles/etc/ssh/sshd_conf"
      }
    ]

Here is the more condensed data for method promises to call the EFL
bundles.

#### efl_main.json

    [
      {
         "promiser" : "File permissions",
         "promisee" : "file permissions",
         "class" : "any",
         "parameter" : "${sys.workdir}/inputs/params/efl_file_perms.txt",
         "bundle" : "efl_file_perms",
         "ifelapsed" : "1"
      },
      {
         "ifelapsed" : "1",
         "parameter" : "${sys.workdir}/inputs/params/efl_services.txt",
         "bundle" : "efl_services",
         "class" : "any",
         "promisee" : "services",
         "promiser" : "services"
      }
    ]

Now I don't have to add new policy to make new promises. I simply edit
the data files. But are these promisers still logically grouped? Yes
they are. Each data files has a promisee in the last column. The same
promisee, or key words in the promisee, in multiple records or files
represents the logical relationship between the promisers. Finding a
logical group is only a grep away. Does this sound familiar?

### Further reading ###

  * [How to use EFL.](/simple-cfengine-server-access-promises-using-efl/)

  * [Promising sysctlt with EFL.](/secure-sysctl-settings-with-cfengine/)

  * [Promising cf-serverd access promises with EFL.](/simple-cfengine-server-access-promises-using-efl/)

  * [Building soft classes with EFL.](/bulding-cfengine-classes-using-efl/)
