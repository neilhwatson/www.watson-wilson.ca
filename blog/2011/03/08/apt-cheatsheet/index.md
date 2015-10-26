---
title: Debian Apt Cheatsheet
tags: debian, apt, cheatsheet
---
Download and build source package   apt-get -b source <package name>
Download and install dependencies for source package  apt-get build-dep <package name>
Download source package    apt-get source <package name>
Install package “on demand”   auto-apt run <program>
List contents of a package    apt-file list <package name>
List installed packages    dpkg -l
Remove package and configuration files    apt-get --purge remove <package name>
Search for Debian Packages    http://www.debian.org/distrib/packages
Search for packages  apt-cache search <string>
Show package dependencies  apt-cache depends <string>
Show package information   apt-cache show <string>
Show package that supplies a given file   apt-file search <file name>
Show package that supplies a given file   COLUMNS=132 dpkg -S <file name>
Show source package information  apt-cache showsrc <package name>
Update apt-file and auto-apt database  apt-file update
