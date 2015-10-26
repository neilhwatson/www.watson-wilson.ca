---
title: Solaris and Sun/Oracle cheatsheet
tags: solaris, sun, oracle, cheatsheet
---

0  Go into boot prompt (OK).
1  Put the system in system administrator mode. All file systems are mounted. Only a small set of essential kernel processes are left running. This mode is for administrative tasks such as installing optional utility packages. All files are accessible and no users are logged in on the system.
2  Put the system in multi-user mode. All multi-user environment terminal processes and daemons are spawned. This state is commonly referred to as the multi-user state.
3  Start the remote file sharing processes and dae mons. Mount and advertise remote resources. Run level 3 extends multi-user mode and is known as the remote-file-sharing state.
4  Is available to be defined as an alternative multi-user environment configuration. It is not necessary for system operation and is usually not used.
5  Shut the machine down so that it is safe to remove the power. Have the machine remove power, if possible.
6  Stop the operating system and reboot to the state defined by the initdefault entry in /etc/inittab.

reboot -- -x

   Reboot and issue boot -x (boot to non-cluster mode) at boot prompt.

reboot -- -xs

   Reboot and issue boot -xs (single user, non-cluster mode) at boot prompt.

reboot -- -r

   Reboot and issue boot -r (reconfigure) at boot prompt.

elom and ilom commands Upload elom firmware  

cd /SP/TftpUpdate
set ServerIP=<tftp IP address>
set Filename=Telom_X6250-053_040.ROM
stop /SYS
set Update=action
# wait for upload and reboot

Upload ilom firmware    

load -source tftp://<tftp IP address>/file.pkg

Sun Cluster (under review) Backup cluster confuration    cluster export > clusterconfig.xml
Offline device group.   cldg offline <group>
Offline resource group.    clrg offline <group>
Onine device group.  cldg online <group>
Onine resource group.   clrg online <group>
Restore cluster configuration    clintr delete --force +
clinst add clusterconfig.xml +
Show cluster configuration    cluster show
Status of cluster.   scstat or cluster status
Status of device group.    cldg status
Status of resource group.  clrg status
Swtich device group to another node.   cldg switch -n <node> <group>
Swtich resource group to another node.    clrg switch -n <node> <group>

