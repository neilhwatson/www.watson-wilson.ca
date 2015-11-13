---
title: SSH public key distribution using CFEngine
tags: cfengine, cfengine cookbook, ssh, infosec
---

### Problem

You want to distribute public SSH keys.

---

### Solution

There are two possible methods for distributing SSH public keys. The first
involves a simple copy.

    bundle agent recipe {

     files:
       "/home/neil/.ssh/authorized_keys"
         handle => "neil_ssh_pub",
         comment => "Install Neil's public ssh key",
         perms => mog("0600", "neil", "neil"),
         copy_from => remote_cp("/var/cf-masterfiles/sshkeys/neil-pub","venus");
    }

This promise ensures the file is up to date, via timestamp, as well as the
owner, group and mode.

    cf3     Promise handle: neil_ssh_pub
    cf3     Promise made by: /home/neil/.ssh/authorized_keys
    cf3
    cf3     Comment:  Install Neil's public ssh key
    cf3     .........................................................
    cf3
    cf3  -> Handling file existence constraints on
    /home/neil/.ssh/authorized_keys
    cf3  -> Owner of /home/neil/.ssh/authorized_keys was 0, setting to 1000
    cf3  -> Group of /home/neil/.ssh/authorized_keys was 0, setting to 1000
    cf3  -> Object /home/neil/.ssh/authorized_keys had permission 600,
    changed it to 644
    cf3  -> Handling file existence constraints on
    /home/neil/.ssh/authorized_keys
    cf3  -> File permissions on /home/neil/.ssh/authorized_keys as promised
    cf3  -> Copy file /home/neil/.ssh/authorized_keys from
    /vars:/cf-masterfiles/sshkeys/neil-pub check
    cf3 No existing connection to 192.168.0.15 is established...
    cf3 Set cfengine port number to 5308 = 5308
    cf3  -> Connect to venus = 192.168.0.15 on port 5308
    cf3  -> Last saw venus (+192.168.0.15) now
    cf3 Loaded /vars:/cfengine/ppkeys/root-192.168.0.15.pub
    cf3 .....................[.h.a.i.l.].................................
    cf3 Strong authentication of server=venus connection confirmed
    cf3  -> Destination file "/home/neil/.ssh/authorized_keys" already
    exists
    cf3  -> Not attempting to preserve file permissions from the source
    cf3  -> File permissions on /home/neil/.ssh/authorized_keys as promised
    cf3  -> File /home/neil/.ssh/authorized_keys is an up to date copy of
    source
    cf3 Performance(Copy(venus:/vars:/cf-masterfiles/sshkeys/neil-pub >
    /home/neil/.ssh/authorized_keys)): time=0.0001 secs, av=0.0005 +/-
    0.0022

An alternative method would be to edit authorized_keys instead. This allows you
to append the file without overwriting any existing information that might be
required.

    bundle agent recipe {

      vars:
        "keys" slist => { 
          "ssh-rsa AAAAB31yc2E...EZFcqZ0CSQ1OPw== neil@pearl.watson-wilson.ca",
          "ssh-rsa AAAAB31yc2E...NezfCQz0CSQ1OPw== neil@ruby.watson-wilson.ca"
        };

      files:
        "/home/neil/.ssh/authorized_keys"
          handle => "neil_ssh_pub",
          comment => "Install Neil's public ssh keys",
          perms => mog("0644","neil","neil"),
          edit_line => append_if_no_lines( "@{recipe.keys}" );
    }

This bundle appends authorized_keys with the given key lines. Note that we pass
the list to the edit_line bundle “append_if_no_lines” as “@{recipe.keys}”. Were
we to pass just “@{keys}” to the body part that part would think the list is
scoped locally and would be blank. By qualifying it with the bundle's name the
correct list is used.

    cf3     Promise handle: 
    cf3     Promise made by: ssh-rsa
    AAAAB3NzaC1yc2EAAAABIwAAAQEA0Rg/vwLT9Hk4+wp5rVtKRgn9cHC3zHWHAW
    cf3 
    cf3     Comment:  Append lines to the file if they don't already exist
    cf3     .........................................................
    cf3 
    cf3  -> Inserting the promised line "ssh-rsa
    AAAAB3NzaC1yc2EAAAABIwAAAQEA0Rg/vwLT9Hk4+wp5rVtKRg
    n-wilson.ca" into /home/neil/.ssh/authorized_keys after locator
    cf3 
    cf3     .........................................................
    cf3     Promise handle: 
    cf3     Promise made by: ssh-rsa
    AAAAB3NzaC1yc2EaaaabiWaaaqea0rG/VWlt9hK4+WP5RvTkrGN9Chc3Zhwhaw
    cf3 
    cf3     Comment:  Append lines to the file if they don't already exist
    cf3     .........................................................
    cf3 
    cf3  -> Inserting the promised line "ssh-rsa
    AAAAB3NzaC1yc2EaaaabiWaaaqea0rG/VWlt9hK4+WP5RvTkrG
    -wilson.ca" into /home/neil/.ssh/authorized_keys after locator

