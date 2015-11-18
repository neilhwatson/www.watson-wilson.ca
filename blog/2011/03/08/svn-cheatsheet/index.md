---
title: Subversion Cheatsheet
tags: subversion, svn, cheatsheet
---

<table>
<tr>
	<td>Add to working copy</td>
	<td><code>svn add <file></code></td>
</tr>
<tr>
	<td>Backup to hot copy</td>
	<td><code>hot-backup.py /opt/svn /opt/svn-backup</code></td>
</tr>
<tr>
	<td>Change log view</td>
	<td><code>svn log file:///opt/svn/scripts/firewall/firewall-new</code></td>
</tr>
<tr>
	<td>Checkout</td>
	<td><code>svn checkout file:///opt/svn/profile</code></td>
</tr>
<tr>
	<td>Commit changes</td>
	<td><code>svn commit --message "Your log message"</code></td>
</tr>
<tr>
	<td>Copy to working copy</td>
	<td><code>svn copy <file> <file></code></td>
</tr>
<tr>
	<td>Create respository</td>
	<td><code>svnadmin create --fs-type fsfs /opt/svn</code></td>
</tr>
<tr>
	<td>Delete from working copy</td>
	<td><code>svn delete <file></code></td>
</tr>
<tr>
	<td>Diff changes</td>
	<td><code>svn diff</code></td>
</tr>
<tr>
	<td>Initial Import</td>
	<td><code>svn import . file:///opt/svn --message "Initial import"</code></td>
</tr>
<tr>
	<td>Merging to current directory</td>
	<td><code>svn merge <merge to@REV> <merge from@REV></code></td>
</tr>
<tr>
	<td>Move file in working copy</td>
	<td><code>svn move <file1> <file2></code></td>
</tr>
<tr>
	<td>Remote Checkout</td>
	<td><code>svn checkout svn+ssh://<user>@<hostname>/opt/svn/<project></code></td>
</tr>
<tr>
	<td>Revert all changes</td>
	<td><code>svn revert <file></code></td>
</tr>
<tr>
	<td>Review changes</td>
	<td><code>svn status</code></td>
</tr>
<tr>
	<td>Review commit log</td>
	<td><code>svn log</code></td>
</tr>
<tr>
	<td>Update working copy</td>
	<td><code>svn update <file> (may overwrite changes)</code></td>
</tr>
<tr>
	<td>View file</td>
	<td><code>svn cat file:///opt/svn/profile/.profile</code></td>
</tr>
<tr>
	<td>View repository tree</td>
	<td><code>svnlook tree /opt/svn</code></td>
</tr>
</table>
