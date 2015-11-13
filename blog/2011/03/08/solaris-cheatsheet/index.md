---
title: Solaris and Sun/Oracle cheatsheet
tags: solaris, sun, oracle, cheatsheet
---

### Init levels

<table>
<tr>
	<td>0</td>
	<td>Go into boot prompt (OK).</td>
</tr>
<tr>
	<td>1</td>
    <td>Put the system in system administrator mode. All file systems are
    mounted. Only a small set of essential kernel processes are left running.
    This mode is for administrative tasks such as installing optional utility
    packages. All files are accessible and no users are logged in on the
    system.</td>
</tr>
<tr>
	<td>2</td>
    <td>Put the system in multi-user mode. All multi-user environment terminal
    processes and daemons are spawned. This state is commonly referred to as
    the multi-user state.</td>
</tr>
<tr>
	<td>3</td>
    <td>Start the remote file sharing processes and dae mons. Mount and
    advertise remote resources. Run level 3 extends multi-user mode and is
    known as the remote-file-sharing state.</td>
</tr>
<tr>
	<td>4</td>
    <td>Is available to be defined as an alternative multi-user environment
    configuration. It is not necessary for system operation and is usually not
    used.</td>
</tr>
<tr>
	<td>5</td>
    <td>Shut the machine down so that it is safe to remove the power. Have the
    machine remove power, if possible.</td>
</tr>
<tr>
	<td>6</td>
    <td>Stop the operating system and reboot to the state defined by the
    initdefault entry in /etc/inittab.</td>
</tr>
<tr>
	<td><code><pre>reboot -- -x</pre></code></td>
    <td>Reboot and issue boot -x (boot to non-cluster mode) at boot
    prompt.</td>
</tr>
<tr>
	<td><code><pre>`reboot -- -xs`</pre></code></td>
    <td>Reboot and issue `boot -xs` (single user, non-cluster mode) at boot
    prompt.</td>
</tr>
<tr>
	<td><code><pre>`reboot -- -r`</pre></code></td>
	<td>Reboot and issue boot -r (reconfigure) at boot prompt.</td>
</tr>
</table>

---

### elom and ilom commands

#### Upload elom firmware  

    cd /SP/TftpUpdate
    set ServerIP=<tftp IP address>
    set Filename=Telom_X6250-053_040.ROM
    stop /SYS
    set Update=action
    # wait for upload and reboot

#### Upload ilom firmware    

    load -source tftp://<tftp IP address>/file.pkg

### Sun Cluster

<table>
<tr>
	<td>Backup cluster confuration</td>
	<td>`cluster export > clusterconfig.xml`</td>
</tr>
<tr>
	<td>Offline device group.</td>
	<td>`cldg offline <group>`</td>
</tr>
<tr>
	<td>Offline resource group.</td>
	<td>`clrg offline <group>`</td>
</tr>
<tr>
	<td>Onine device group.</td>
	<td>`cldg online <group>`</td>
</tr>
<tr>
	<td>Onine resource group.</td>
	<td>`clrg online <group>`</td>
</tr>
<tr>
	<td>Restore cluster configuration</td>
	<td>`clintr delete --force`<br>`clinst add clusterconfig.xml`</td>
</tr>
<tr>
	<td>Show cluster configuration</td>
	<td>`cluster show`</td>
</tr>
<tr>
	<td>Status of cluster.</td>
	<td>`scstat or cluster status`</td>
</tr>
<tr>
	<td>Status of device group.</td>
	<td>`cldg status`</td>
</tr>
<tr>
	<td>Status of resource group.</td>
	<td>`clrg status`</td>
</tr>
<tr>
	<td>Swtich device group to another node.</td>
	<td>`cldg switch -n <node> <group>`</td>
</tr>
<tr>
	<td>Swtich resource group to another node.</td>
	<td>`clrg switch -n <node> <group>`</td>
</tr>
</table>
