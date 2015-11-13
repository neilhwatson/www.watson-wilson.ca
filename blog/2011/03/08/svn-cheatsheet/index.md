---
title: Subversion Cheatsheet
tags: subversion, svn, cheatsheet
---

<table>
<tr>
	<td>Add to working copy</td>
	<td>`svn add <file>`</td>
</tr>
<tr>
	<td>Backup to hot copy</td>
	<td>`hot-backup.py /opt/svn /opt/svn-backup`</td>
</tr>
<tr>
	<td>Change log view</td>
	<td>`svn log file:///opt/svn/scripts/firewall/firewall-new`</td>
</tr>
<tr>
	<td>Checkout</td>
	<td>`svn checkout file:///opt/svn/profile`</td>
</tr>
<tr>
	<td>Commit changes</td>
	<td>`svn commit --message "Your log message"`</td>
</tr>
<tr>
	<td>Copy to working copy</td>
	<td>`svn copy <file> <file>`</td>
</tr>
<tr>
	<td>Create respository</td>
	<td>`svnadmin create --fs-type fsfs /opt/svn`</td>
</tr>
<tr>
	<td>Delete from working copy</td>
	<td>`svn delete <file>`</td>
</tr>
<tr>
	<td>Diff changes</td>
	<td>`svn diff`</td>
</tr>
<tr>
	<td>Initial Import</td>
	<td>`svn import . file:///opt/svn --message "Initial import"`</td>
</tr>
<tr>
	<td>Merging to current directory</td>
	<td>`svn merge <merge to@REV> <merge from@REV>`</td>
</tr>
<tr>
	<td>Move file in working copy</td>
	<td>`svn move <file1> <file2>`</td>
</tr>
<tr>
	<td>Remote Checkout</td>
	<td>`svn checkout svn+ssh://<user>@<hostname>/opt/svn/<project>`</td>
</tr>
<tr>
	<td>Revert all changes</td>
	<td>`svn revert <file>`</td>
</tr>
<tr>
	<td>Review changes</td>
	<td>`svn status`</td>
</tr>
<tr>
	<td>Review commit log</td>
	<td>`svn log`</td>
</tr>
<tr>
	<td>Update working copy</td>
	<td>`svn update <file> (may overwrite changes)`</td>
</tr>
<tr>
	<td>View file</td>
	<td>`svn cat file:///opt/svn/profile/.profile`</td>
</tr>
<tr>
	<td>View repository tree</td>
	<td>`svnlook tree /opt/svn`</td>
</tr>
</table>
