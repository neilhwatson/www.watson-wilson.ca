---
title: Debian Apt Cheatsheet
tags: debian, apt, cheatsheet
---

<table>
<tr>
	<td>Download and build source package</td>
	<td><code>apt-get -b source <package name></code></td>
</tr>
<tr>
	<td>Download and install dependencies for source package</td>
	<td><code>apt-get build-dep <package name></code></td>
</tr>
<tr>
	<td>Download source package</td>
	<td><code>apt-get source <package name></code></td>
</tr>
<tr>
	<td>Install package "on demand"</td>
	<td><code>auto-apt run <program></code></td>
</tr>
<tr>
	<td>List contents of a package</td>
	<td><code>apt-file list <package name></code></td>
</tr>
<tr>
	<td>List installed packages</td>
	<td><code>dpkg -l</code></td>
</tr>
<tr>
	<td>Remove package and configuration files</td>
	<td><code>apt-get --purge remove <package name></code></td>
</tr>
<tr>
	<td>Search for Debian Packages</td>
	<td><code>http://www.debian.org/distrib/packages</code></td>
</tr>
<tr>
	<td>Search for packages</td>
	<td><code>apt-cache search <string></code></td>
</tr>
<tr>
	<td>Show package dependencies</td>
	<td><code>apt-cache depends <string></code></td>
</tr>
<tr>
	<td>Show package information</td>
	<td><code>apt-cache show <string></code></td>
</tr>
<tr>
	<td>Show package that supplies a given file</td>
	<td><code>apt-file search <file name></code></td>
</tr>
<tr>
	<td>Show package that supplies a given file</td>
	<td><code>COLUMNS=132 dpkg -S <file name></code></td>
</tr>
<tr>
	<td>Show source package information</td>
	<td><code>apt-cache showsrc <package name></code></td>
</tr>
<tr>
	<td>Update `apt-file and auto-apt database</td>
	<td><code>apt-file update</code></td>
</tr>
</table>
