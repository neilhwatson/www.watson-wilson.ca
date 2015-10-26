---
title: Subversion Cheatsheet
tags: subversion, svn, cheatsheet
---

Add to working copy  svn add <file>
Backup to hot copy   hot-backup.py /opt/svn /opt/svn-backup
Change log view   svn log file:///opt/svn/scripts/firewall/firewall-new
Checkout    svn checkout file:///opt/svn/profile
Commit changes    svn commit --message "Your log message"
Copy to working copy    svn copy <file> <file>
Create respository   svnadmin create --fs-type fsfs /opt/svn
Delete from working copy   svn delete <file>
Diff changes   svn diff
Initial Import    svn import . file:///opt/svn --message "Initial import"
Merging to current directory  svn merge <merge to@REV> <merge from@REV>
Move file in working copy  svn move <file1> <file2>
Remote Checkout   svn checkout svn+ssh://<user>@<hostname>/opt/svn/<project>
Revert all changes   svn revert <file>
Review changes    svn status
Review commit log    svn log
Update working copy  svn update <file> (may overwrite changes)
View file   svn cat file:///opt/svn/profile/.profile
View repository tree    svnlook tree /opt/svn
