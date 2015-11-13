---
title: Multipathd testing
tags: multipathd, iscsi, san
---

1. Format and mount the SAN LUN.
1. Start a write to the mounted filesystem `cat /dev/zero >> /pathto/mnt/testfile &`
1. Now connect to the multipath daemon in interactive mode `multipathd -k`
1. View current paths with show maps topology

    multipathd> show maps topology
    reload: mpath5 (360060e801045249004f2a5f900000031) dm-7 HITACHI,DF600F
    [size=128G][features=0][hwhandler=0][rw]
    \_ round-robin 0 [prio=1][active]
     \_ 1:0:0:4 sdb 8:16  [active][ready]
    \_ round-robin 0 [prio=0][enabled]
     \_ 2:0:0:4 sdc 8:32  [active][ready]

1. There are two paths shown as sdb and sdc. Delete one path.
        del path sdb
1. Suspend with ctrl-z and check that the write is still happening.
        ls -l /pathto/mnt If testfile is still growing then the path sdc is working.
1. Resume multipath with fg 2. Re-add the path.
        add path sdb
1. Now remove the other path.
        del path sdc
1. Again suspend iwth ctrl-z and check that the test file is growing. If so
   then resume multipath and re-add the path.
        add path sdc
1. Testing complete. Exit with ctrl-c. Kill the write job with kill %1. Remove
   the test file.
