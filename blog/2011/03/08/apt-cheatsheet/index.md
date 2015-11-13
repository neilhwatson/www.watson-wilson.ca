---
title: Debian Apt Cheatsheet
tags: debian, apt, cheatsheet
---

<table>
<tr>
	<td>Download and build source package</td>
	<td>`apt-get -b source <package name>`</td>
</tr>
<tr>
	<td>Download and install dependencies for source package</td>
	<td>`apt-get build-dep <package name>`</td>
</tr>
<tr>
	<td>Download source package</td>
	<td>`apt-get source <package name>`</td>
</tr>
<tr>
	<td>Install package "on demand"</td>
	<td>`auto-apt run <program>`</td>
</tr>
<tr>
	<td>List contents of a package</td>
	<td>`apt-file list <package name>`</td>
</tr>
<tr>
	<td>List installed packages</td>
	<td>`dpkg -l`</td>
</tr>
<tr>
	<td>Remove package and configuration files</td>
	<td>`apt-get --purge remove <package name>`</td>
</tr>
<tr>
	<td>Search for Debian Packages</td>
	<td>`http://www.debian.org/distrib/packages`</td>
</tr>
<tr>
	<td>Search for packages</td>
	<td>`apt-cache search <string>`</td>
</tr>
<tr>
	<td>Show package dependencies</td>
	<td>`apt-cache depends <string>`</td>
</tr>
<tr>
	<td>Show package information</td>
	<td>`apt-cache show <string>`</td>
</tr>
<tr>
	<td>Show package that supplies a given file</td>
	<td>`apt-file search <file name>`</td>
</tr>
<tr>
	<td>Show package that supplies a given file</td>
	<td>`COLUMNS=132 dpkg -S <file name>`</td>
</tr>
<tr>
	<td>Show source package information</td>
	<td>`apt-cache showsrc <package name>`</td>
</tr>
<tr>
	<td>Update `apt-file and auto-apt database</td>
	<td>`apt-file update`</td>
</tr>
</table>
