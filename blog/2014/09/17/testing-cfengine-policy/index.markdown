---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
    - content: devops
      domain: category
      nicename: devops
    - content: EFL
      domain: category
      nicename: efl
    - content: software testing
      domain: category
      nicename: software-testing
  post_type: post
  wp_menu_order: 0
  wp_post_id: 1036
  wp_post_name: testing-cfengine-policy
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/testing-cfengine-policy/
date: 2014-09-17 10:14:41
status: published
tags:
  - Cfengine
  - devops
  - EFL
  - software testing
title: Testing CFEngine policy
---
![f4-crashtest](http://watson-wilson.ca/wp-content/uploads/2014/07/f4-crashtest.jpg)

After 2 productive days at [Devopsdays Toronto](http://www.devopsdays.org/events/2014-toronto/)
I've been thinking more about how to test CFEngine policy. Not just
prototype, but production tests too. The ideal situation is that a
machine tests your would-be production policy and then deploys it fully
if the test suite passes. This is completely automatic. How do we get
there?

---

In my blog about [CFEngine best practices: testing](http://watson-wilson.ca/cfengine-best-practices-testing/)
I discussed unit testing, and test reporting. Let's expand on that.
I've recently created a new bundle in [EFL](https://github.com/evolvethinking/evolve_cfengine_freelib/commit/874dcc22f28fda3ba4b967c24bfb983156e75fe7)
for testing. If you are familiar with Perl's [Test::More](https://metacpan.org/pod/Test::More)
you will recognize the form. Efl_test_simple tests whether or not a
class is defined, you decide if the class being defined is a pass or
fail. The test class is actually a regular expression for added
flexibility.

We usually judge a promise's success with classes. The classes
attribute can define classes based on success, repair, or failure. EFL
promises define classes if kept, repaired, or

not kept automatically. These classes are in a predictable format:

` `

    <canonized promiser>_handle_<promise handle>_<kept, notkept, or repaired>

If you know the expected class you can test for its existence.
Elf_test_simple lets you define a test for a class and will return a
pass or fail. As with all EFL bundles we use an external parameter
file. It's data may look like this:

` `

    # class ;; test class ;; is or isnt true ;; name of test
    run_my_tests ;; _var_cfengine_modules_mymodule_pl_efl_command_commands_repaired ;; is ;; My module pass if 'repaired'
    run_my_tests ;; negative_test_never ;; is ;; Negative test, should always fail
    run_my_tests ;; danger_class ;; isnt ;; Fail if class is defined

If the agent is run with *run_my_tests* as true reports are generated.

`

    cf-agent -KD run_my_tests|grep 'R:'
    2014-09-15T12:13:16-0400   notice: R: PASS, _var_cfengine_modules_mymodule_pl_handle_efl_command_commands_repaired, My module pass if 'repaired'
    2014-09-15T12:13:16-0400   notice: R: FAIL, negative_test_never, Negative test, should always fail
    2014-09-15T12:13:16-0400   notice: R: PASS,  danger_class, Fail if class is defined
       

`

The test class can be a regular expression, so you could test for *.*_failed*
to flag any failed promises from EFL. Did you know that you can use
EFL's class body *elf_rkn* to define kept, not kept, and repaired
classes for your own custom promises?

#### Third party testing ####

To be extra sure of your policy you could use a tool other than
CFEngine to test CFEngine policy outcome. This eliminates false test
results due to CFEngine bugs. There are open source system test tool
available. Currently I'm looking at [Serverspec](http://serverspec.org/).
Serverspec is a Ruby based tool that can examine a local or remote host
using SSH and Sudo. Visit Serverspec for installation instructions and
note that a major new release is due in October. Here's an example spec
file that tests SSHD.

` `

    ~/src/serverspec$ cat spec/localhost/ssh_spec.rb 
    require 'spec_helper'
    
    describe package('openssh-server') do
      it { should be_installed }
    end
    
    describe service('/usr/sbin/sshd') do
      it { should be_running   }
    end
    
    describe port(22) do
      it { should be_listening }
    end
    
    describe file('/etc/ssh/sshd_config') do
      it { should be_file }
    end

There are four tests.

  1. The package *openssh-server* must be installed.

  2. The process */usr/sbin/sshd* must be running.

  3. A service on port 22 must answer.

  4. The file */etc/ssh/sshd_config* must exist and a be regular file.

####  ####

When I run it I'm prompted for my password to use with Sudo.

` `

    $ rake spec
    /tool/pandora64/.package/ruby-1.9.3-p0/bin/ruby -S rspec spec/localhost/ssh_spec.rb
    Password:  
    ....
    
    Finished in 7.29 seconds
    4 examples, 0 failures

The number of tests available is extensive, making Serverspec a good
option for third party testing.

I've only scratched the surface of *devops* style testing, but
hopefully you'll see the potential. I hope to follow up with more on
testing the in future.
