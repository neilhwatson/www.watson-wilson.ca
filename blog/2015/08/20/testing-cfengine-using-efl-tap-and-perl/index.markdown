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
    - content: devops
      domain: category
      nicename: devops
    - content: EFL
      domain: category
      nicename: efl
    - content: software testing
      domain: category
      nicename: software-testing
    - content: testing
      domain: category
      nicename: testing
  post_type: post
  wp_menu_order: 0
  wp_post_id: 1128
  wp_post_name: testing-cfengine-using-efl-tap-and-perl
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/testing-cfengine-using-efl-tap-and-perl/
date: 2015-08-20 15:33:18
status: published
tags:
  - Cfengine
  - devops
  - EFL
  - software testing
title: 'Testing CFEngine policy using EFL, TAP, and Perl'
---
![Prove and TAP output](http://watson-wilson.ca/static/images/efl_tests.png)

It's a dirty secret that few test their CFEngine policies, and fewer
still test them well. Now EFL has two bundles for testing that produce
TAP output.

---

### What is TAP? ###

The [*Test Anything Protocol*](https://en.wikipedia.org/wiki/Test_Anything_Protocol)
was invented for unit testing Perl. It's simple yet powerful with a
format like this:

``

    (start test number)..(end test number)
    (ok|not ok) (test number) - Test name in free form

Here's and example output:

``

    R: efl_data_efl_test_vars_efl_global_strings_json_26ca18b4fe77f2fc4a494be
    1..3
    R: efl_data_efl_test_vars_efl_global_strings_json_26ca18b4fe77f2fc4a494be
    ok 1 - main_efl_dev [Neil H. Watson (neil@watson-wilson.ca)]
    R: efl_data_efl_test_vars_efl_global_strings_json_26ca18b4fe77f2fc4a494be
    ok 2 - gateway [2001:DB8::1]
    R: efl_data_efl_test_vars_efl_global_strings_json_26ca18b4fe77f2fc4a494be
    ok 3 - cfe version [3]

Visually the reader can quickly understand results. The Perl utility *prove*
will summarize them for you.

EFL comes with two testing bundles that generate TAP output via reports
promises. *Efl_test_classes* tests if a class is defined or not, and *efl_test_vars*
tests the value of a variable. Let's look at some examples. Note that I
assume you have working CFEngine master framework policy and [EFL
installed](https://github.com/evolvethinking/evolve_cfengine_freelib/blob/master/INSTALL.md)

### elf_test_classes ###

Suppose I want to test for the presence of the class *am_middleware_host*.
Efl_test_classes takes a parameter file like this:

``

    [
       {
          "class"         : "test_for_am_middleware_host",
          "class_to_test" : "am_middleware_host",
          "test_type"     : "is",
          "name"          : "Testing if 'am_middleware_host is set"
       }
    ]

The test type works like Perl's [Test::More module](https://metacpan.org/pod/Test::More).
Available test types are is, isnt, like, and unlike. The above test
will pass if *class_to_test* is defined. Let's run it.

``

    cf-agent -D run_test_suite,test_for_am_middleware_host
    R: efl_test_classes_json_bbb9ad33c9792ef54f738a641bb72abfc75640a4
    1..1
    R: efl_test_classes_json_bbb9ad33c9792ef54f738a641bb72abfc75640a4
    ok 1 - Testing if 'am_middleware_host is set

At this point you might say "Neil, why don't you just grep verbose
output to see if the class is true?". Sure, that type of adhoc testing
is fine, but the testing offered here is for automatic testing, so you
can script this test using Perl's prove. Below we encapsulate the
cf-agent command into *cf-test.t* because prove works by running files
ending in .t and parsing TAP output.

``

    #!/bin/sh
    
    cf-agent -D run_test_suite,test_for_am_middleware_host

Now run it with prove:

``

    prove ./cf-test.t
    ./efl_test_classes.t .. ok   
    All tests successful.
    Files=1, Tests=1,  2 wallclock secs ( 0.02 usr  0.00 sys +  0.65 
    Result: PASS

Promises can be shown to kept, repaired, or not kept by using a [classes
attribute](https://docs.cfengine.com/docs/master/reference-promise-types.html#classes).
So, if your promises define kept, repaired, or failed classes, then you
can test for them in your test suite. Further, if you use ELF these
classes are automatically defined:

``

    body classes efl_rkn( promiser, handle )
    {
          promise_kept      => { "${promiser}_handle_${handle}_kept" };
          promise_repaired  => { "${promiser}_handle_${handle}_repaired" };
          repair_failed     => { "${promiser}_handle_${handle}_notkept" };
          repair_denied     => { "${promiser}_handle_${handle}_notkept" };
          repair_timeout    => { "${promiser}_handle_${handle}_notkept" };
    }

Now that you know the expected class outcome you can test for it. You
can have test cases for any new policy.

### elf_test_vars ###

Efl_test_vars is similar to efl_test_classes. You compare the value of
a given variable against a give string or regex. Again it uses is,
isnt, like, and unlike. Here's an example from EFL's own test suite:

``

    [
       {
          "test_case" : "Neil H. Watson (neil@watson-wilson.ca)",
          "test_type" : "is",
          "class" : "any",
          "name" : "main_efl_dev [${efl_global_strings.main_efl_dev}]",
          "var_to_test" : "${efl_global_strings.main_efl_dev}"
       },
       {
          "test_type" : "is",
          "class" : "any",
          "name" : "gateway [${efl_global_strings.gateway}]",
          "var_to_test" : "${efl_global_strings.gateway}",
          "test_case" : "2001:DB8::1"
       },
       {
          "test_case" : "3",
          "test_type" : "is",
          "class" : "any",
          "var_to_test" : "${efl_global_strings.cf_major}",
          "name" : "cfe version [${efl_global_strings.cf_major}]"
       }
    ]

This data is used by EFL's test suite to test that the bundle
efl_global_strings correctly defines variables. Here's the raw output:

``

    t/31_efl_global_strings_json.t
    R: efl_data_efl_test_vars_efl_global_strings_json_26ca18b4fe77f2fc4a494be0
    1..3
    R: efl_data_efl_test_vars_efl_global_strings_json_26ca18b4fe77f2fc4a494be0
    ok 1 - main_efl_dev [Neil H. Watson (neil@watson-wilson.ca)]
    R: efl_data_efl_test_vars_efl_global_strings_json_26ca18b4fe77f2fc4a494be0
    ok 2 - gateway [2001:DB8::1]
    R: efl_data_efl_test_vars_efl_global_strings_json_26ca18b4fe77f2fc4a494be0
    ok 3 - cfe version [3]

And here's the output from prove: ``

    prove t/31_efl_global_strings_json.t 
    t/31_efl_global_strings_json.t .. ok   
    All tests successful.
    Files=1, Tests=3,  1 wallclock secs ( 0.03 usr  0.00 sys +  0.88 cusr  
    Result: PASS

I hope this has given you some ideas on how you can improve your policy
testing. Feel free to contact me if you have questions or if you'd like
a consulting engagement. Happy testing!
