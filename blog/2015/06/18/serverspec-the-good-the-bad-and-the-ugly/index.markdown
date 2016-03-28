---
author: nwatson
data:
  categories:
    - content: Cfengine
      domain: category
      nicename: cfengine
    - content: serverspec
      domain: category
      nicename: serverspec
    - content: software testing
      domain: category
      nicename: software-testing
    - content: testing
      domain: category
      nicename: testing
  post_type: post
  wp_menu_order: 0
  wp_post_id: 1111
  wp_post_name: serverspec-the-good-the-bad-and-the-ugly
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/serverspec-the-good-the-bad-and-the-ugly/
date: 2015-06-18 14:37:16
status: published
tags:
  - cfengine
  - serverspec
  - software testing
title: 'Serverspec, the good, the bad, and the ugly'
---


I've been using a talking about [Serverspec](http://serverspec.org)
lately. Let me tell you about the surprises I found.

---

## A Quick Introduction ##

Severspec is a Ruby powered tool the tests server configuration. You
write a description of a systems configuration (e.g. packages
installed, processes running, file hashes and contents) and Serverspec
tests one or more hosts against it. It uses SSH and Sudo to test remote
hosts and, optionally, with privileges.

## Goal: testing multiple hosts ##

I have a group of CFEngine servers that I want to test against a
desired standard. I could use CFEngine, but I prefer a third party tool
for better confirmation. The Serverspec file looks like this:

``

    require 'spec_helper'
    require 'socket'
    
    describe package('cfengine-community') do
       it { should be_installed }
    end
    
    describe command( '/var/cfengine/bin/cf-promises --version') do
       its(:stdout) { should match /3\.6\.5/ }
    end
    
    # Removed due to bug
    # describe service( 'cfengine3' ) do
       # it { should be_enabled }
    # end
    
    describe "CFEngine service should start at boot, chkconfig cfengine3" do
       describe command( '/sbin/chkconfig cfengine3' ) do
          its(:exit_status) { should eq 0 }
       end
    end
    
    for proc in [ 'execd', 'serverd', 'monitord' ]
       describe process( "cf-#{proc}" ) do
          it { should be_running }
          its(:user) { should eq 'root' }
       end
    end
    
    describe port(5308) do
      it { should be_listening }
    end

When you run the test with `rake spec` it makes all those tests against
the target machines and returns a report.

### Bug ###

As you see the example, I commented out a service test. This test is
supposed to examine the return code of `chkconfig --list cfengin3|grep
3:on` but it always failed. Serverspec's Github repository has issue
tracking disabled so I was not able to submit a bug report, and the
maintainer did not return my email.

### Testing multiple hosts ###

The Advanced Tips section of [serverspec.org](http://serverspec.org/advanced_tips.html)
provides tips on how to test multiple hosts against a single set of
tests. This didn't work well. Testing would stop after the first
failure rather continuing to each test and each host. With no
Serverspec community I was limited in who I could ask for help, but I
did ask a colleague who spoke about Serverspec at Devops Days Toronto.
He was not able to make this work either. Eventually I was able to get
help on [Stackoverflow](http://stackoverflow.com/questions/30867597/making-serverspec-mutlit-host-tests-continue-even-on-a-test-failure).
Thank you Arthur Maltson ([@amatlson](https://twitter.com/amaltson)),
and [egwspiti](http://stackoverflow.com/users/3464137/egwspiti) for
helping me.

## The good, the bad, and the ugly ##

### The good ###

A full range of testing features to cover most of your needs all in a
simple descriptive language.

### The bad ###

Documentation lacks detail.

### The ugly ###

A lack of community and creator support.

  * no bug submissions

  * no user mailing list or forum

  * dead irc channel on Freenode

  * Stackoverflow community is small, just 8 followers and 33
    questions.

  * Git maintainer did not answer my email
