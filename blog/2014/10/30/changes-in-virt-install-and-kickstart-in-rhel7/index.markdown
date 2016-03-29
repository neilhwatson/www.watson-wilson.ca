---
author: nwatson
data:
  categories:
    - content: debian
      domain: category
      nicename: debian
    - content: devops
      domain: category
      nicename: devops
    - content: kickstart
      domain: category
      nicename: kickstart
    - content: kvm
      domain: category
      nicename: kvm
    - content: linux
      domain: category
      nicename: linux
    - content: provisioning
      domain: category
      nicename: provisioning
    - content: redhat
      domain: category
      nicename: redhat
  post_type: post
  wp_menu_order: 0
  wp_post_id: 1066
  wp_post_name: changes-in-virt-install-and-kickstart-in-rhel7
  wp_post_parent: 0
  wp_post_path: http://watson-wilson.ca/changes-in-virt-install-and-kickstart-in-rhel7/
date: 2014-10-30 10:10:50
status: published
tags:
  - ipv6
  - debian
  - devops
  - kickstart
  - kvm
  - linux
  - provisioning
  - redhat
title: Changes in virt-install and Kickstart in RHEL7
---
![army provisions](/static/images/mre-case.jpg)

If you are planning to move to RHEL7 you may have to change your
kickstart and [virt-install](http://linux.die.net/man/1/virt-install)
scripts. The virt-install changes will also apply to Debian based
hosts.

---

Below is a working example of a virt-install script. I had to make
changed to the console related bits. Console allows for headless
operation using *virsh console*, without having to fiddle with VNC or
other clumsy graphic interfaces.

A virt-install script

    #!/bin/sh
    
    virt-install -n altair -r 1024 --vcpus 1 \
            --description='rhel7 DR development' \
            -l http://mirror.csclub.uwaterloo.ca/centos/7/os/x86_64/ \
            --os-type=linux --os-variant=rhel7 \
            --disk pool=vg,bus=virtio,size=40 \
            --network bridge=br0,model=virtio \
            --autostart \
       --graphics none \
       --console pty,target_type=serial \
       --extra-args "console=ttyS0,115200n8 serial \
    inst.sshd ks=http://172.16.100.1/ks/altair.cfg"

The Anaconda syntax for kickstart is a little different or more strict
that it was previously. I had to account for the following changes.

  1. Added *url* line.

  2. Added *repo* line.

  3. Added *%end* tags.

#### IPv6 warning ####

Sadly, Anaconda still does not support IPv6 fully. The thorn in my
tests was the *gateway* setting. Anaconda allows only one gateway
network setting which prevents you from configuring a dual stack host.
What is needed is a [gateway and a gateway6](https://bugzilla.redhat.com/show_bug.cgi?id=715574)
option. A work around is to configure one stack in the post section.

Kickstart for RHEL/CentOS 7 

    # Kickstat file manually created by Neil Watson.
    
    install
    text
    
    #
    # KS server TODO
    #
    url --url=http://mirror.csclub.uwaterloo.ca/centos/7/os/x86_64/
    repo --name "CentOS 7" --baseurl=http://mirror.csclub.uwaterloo.ca/centos/7/os/x86_64/ --cost=100
    
    # 
    # Language support TODO
    #
    lang en_US.UTF-8
    keyboard us
    
    #
    # Network settings TODO
    #
    network --device=eth0 --bootproto=dhcp --hostname=altair.watson-wilson.ca
    # Not shown, but configure ipv6 in the %post section.
    
    #
    # Security TODO
    #
    rootpw XXXXXXX
    sshpw --username=root XXXXXX
    
    firewall --disabled
    selinux --disabled
    authconfig --enableshadow --enablemd5
    timezone America/Toronto
    
    bootloader --location=mbr --append="rhgb quiet"
    # Extra console bits probably not neeeded any more.
    #bootloader --location=mbr --append="rhgb quiet console=tty0 console=ttyS0,115200n8"
    
    #
    # Users TODO
    #
    user --name=neil --password=XXXXXXX
    
    #
    # Partitioning and filesystems TODO
    #
    # The following is the partition information you requested
    # Note that any partitions you deleted are not expressed
    # here so unless you clear all partitions first, this is
    # not guaranteed to work
    
    # HP proliants with RIAD use desk device cciss/c0d0
    # Standard scisi disk is sda
    # KVM guests use vda
    
    zerombr
    clearpart --initlabel --all
    
    part /boot --fstype ext4 --size=200 --ondisk=vda --asprimary
    part pv.3 --size=100 --grow --ondisk=vda
    volgroup vg01 pv.3
    logvol / --fstype ext4 --name=lv01 --vgname=vg01 --size=3072 --grow
    logvol swap --fstype swap --name=swaplv01 --vgname=vg01 --size=1024
     
    #
    # Packages TODO
    #
    %%packages --ignoremissing
    vim*
    screen
    tmux
    openssl-devel
    pcre-devel
    make
    gcc
    fakeroot
    %%end
     
    %%post
    
    chvt 3
    
    #
    # SSH TODO
    #
    mkdir /home/neil/.ssh
    chown neil:neil /home/neil/.ssh
    chmod 700 /home/neil/.ssh
    cat <> /home/neil/.ssh/authorized_keys
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQ...
    EOF
    
    %%end

#### Ifconfig not longer in RHEL7 ####

The venerable *ifconfig* has finally been removed from the default
install. This should not be a surprise to anyone. The replacement, [ip](http://linux.die.net/man/8/ip),
has been available for many years, yet [some folks](https://dev.cfengine.com/issues/6126)
have still been caught off guard.
