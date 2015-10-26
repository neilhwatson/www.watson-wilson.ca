---
title: Template files using Cfengine
tags: cfengine, cfengine cookbook, configuration management
---

Problem

Sometimes a file’s contents depends upon the class of host that the file resides on. This makes file copy promises impractical. Who wants to copy a different file for so many hosts? Sysadmins are a lazy lot.

Solution

Template files consist of two promises. One promise copies a base file whilst the second promise edits the base file. The key is the contents of the base file. It contains the names of Cfengine variables. These variables are expanded during the edit.

bundle agent recipe {

  vars:
    mars::
      "manager" string => "Neil Watson";
      "phone" string => "555-555-5555";
      "email" string => "neil@example.com";

    venus::
      "manager" string => "Lisamarie Wilson";
      "phone" string => "555-555-5554";
      "email" string => "lisa@example.com";

  files:
    "/tmp/motd.tmp"
      handle => "motd_template",
      comment => "MOTD template file",
      perms => mog("0644","root","root"),
      copy_from => remote_cp ("/var/cf-masterfiles/motd.tmp","localhost");

    "/etc/motd"
      handle => "motd_file",
      comment => "Expand motd file from template",
      create => "true",
      edit_line => expand_template("/tmp/motd.tmp");
}

Here is our template file motd.tmp

###################################
This host is the property of Example.com.  Use is restricted to
authorized personnel only.

Manager:        ${recipe.manager}
Phone:          ${recipe.phone}
Email:          ${recipe.email}
###################################

Here is the verbose output from the agent.

cf3  !! Image file /tmp/motd.tmp out of date (should be copy of
/vars:/cf-masterfiles/motd.tmp)
cf3  -> Updated /tmp/motd.tmp from source /vars:/cf-masterfiles/motd.tmp
on localhost
cf3  -> Copy of regular file succeeded /vars:/cf-masterfiles/motd.tmp to
/tmp/motd.tmp.cfnew
cf3  -> Not attempting to preserve file permissions from the source
cf3  -> Object /tmp/motd.tmp had permission 600, changed it to 644
...
cf3  -> Using literal pathtype for /etc/motd
cf3  -> File "/etc/motd" exists as promised
cf3  -> Handling file existence constraints on /etc/motd
cf3  -> Handling file edits in edit_line bundle expand_template
cf3 
cf3       * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* *
cf3       BUNDLE expand_template( {'/tmp/motd.tmp'} )
cf3       * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
* *
cf3 
cf3     ? Augment scope expand_template with templatefile
cf3      ??  Private class context
cf3 
cf3 
cf3       = = = = = = = = = = = = = = = = = = = = = = = = = = = =>
cf3       insert_lines in bundle expand_template
cf3       = = = = = = = = = = = = = = = = = = = = = = = = = = = =>
cf3 
cf3 
cf3     .........................................................
cf3     Promise handle: 
cf3     Promise made by: /tmp/motd.tmp
cf3 
cf3     Comment:  Expand variables in the template file
cf3     .........................................................
cf3 
cf3  -> Promised file line "###################################" exists
within file /etc/motd (
cf3  -> Promised file line "This host is the property of
Example.com.  Use is restricted to aut
motd (promise kept)
cf3  -> Promised file line "" exists within file /etc/motd (promise
kept)
cf3  -> Inserting the promised line "Manager:   Lisamarie Wilson" into
/etc/motd after locator
cf3  -> Inserting the promised line "Phone:             555-555-5554"
into /etc/motd after loca
cf3  -> Inserting the promised line "Email:
lisa@example.com" into /etc/motd after 
cf3  -> Promised file line "###################################" exists
within file /etc/motd (
cf3      ??  Private class context

The output is slightly truncated to fit this page but its meaning is clear enough. First the agent copies motd.tmp to /tmp and then edits /etc/motd using /tmp/motd.tmp as a template and expanding the variables set in the bundle recipe. Note that the variables listed in the template file are specifically scoped to the bundle recipe. The resulting file is below.

###################################
This host is the property of Example.com.  Use is restricted to
authorized personal only.

Manager:        Lisamarie Wilson
Phone:          555-555-5554
Email:          lisa@example.com
###################################

Note that Cfengine edits are very efficient. Cfengine performs the edit in memory first and compares the result with the target file. These edits are only committed to the target file if there are actual changes thus sparing needless writes.

