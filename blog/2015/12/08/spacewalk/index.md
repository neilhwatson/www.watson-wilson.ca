---
title: Installing Spacewalk
tags: satellite, spacewalk, provisioning, patching, red hat
---

Here's a quick procedure for installing [Spacewalk](http://spacewalk.redhat.com/).
---

### Server 
1. You'll need a big partition for /var/satellite to store all the packages for every repository you keep.
1. Install the Spacewalk RPM: <code>rpm -Uvh http://yum.spacewalkproject.org/2.3/RHEL/7/x86_64/spacewalk-repo-2.3-4.el7.noarch.rpm</code>.
1. Repos required for server and all client hosts
<code><pre>
    cat > /etc/yum.repos.d/jpackage-generic.repo << EOF
    [jpackage-generic]
    name=JPackage generic
    mirrorlist=http://www.jpackage.org/mirrorlist.php?dist=generic&type=free&release=5.0
    enabled=1
    gpgcheck=1
    gpgkey=http://www.jpackage.org/jpackage.asc
    EOF
</pre></code>
1. <code>yum install spacewalk-setup-postgresql</code>
1. <code>yum install spacewalk-postgresql</code>
1.  Spacewalk answer file
<code><pre>
    admin-email = ops@example.com
    ssl-set-org = Example
    ssl-set-org-unit = Operations
    ssl-set-city = Toronto
    ssl-set-state = Ontario
    ssl-set-country = CA
    ssl-password = XXXXXXXXXX
    ssl-set-email = ops@example.com
    ssl-config-sslvhost = Y
    db-backend=postgresql
    db-name=spaceschema
    db-user=spaceuser
    db-password=XXXXXXXXXX
    db-host=localhost
    db-port=5432
    enable-tftp=Y
</pre></code>
1. <code>spacewalk-setup --disconnected --answer-file=<answer-file></code>
1. Point your browser to https://spacewalk.example.com/rhn/YourRhn.do

###  Client

1. <code>yum install rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin</code>
1. <code>rhnreg_ks --serverUrl=http://pmanager/XMLRPC --activationkey=1-xxxxxxxxxxxx</code>
1. Remove all past repositories.

Configuration management fans will automate this!

### OSA

OSA is an extra agent that allows for near real time patching.

1. On client
<code><pre>
    rpm --import http://yum.spacewalkproject.org/RPM-GPG-KEY-spacewalk-2014
    rpm -Uvh http://pmanager/pub/rhn-org-trusted-ssl-cert-1.0-1.noarch.rpm
    yum install osad 
</pre></code>
1. On server <code>yum install osa-dispatcher</code>

### Spacewalk workflow suggestions

1. Parent channels are empty and represent testing and production.
1. All packages are synced in testing child channels.
1. All packages for production are from cloned testing child channels.

### Sign on using external LDAP

1. Install pam-devel package
1. Create pam file
<code><pre>
    cat << EOF > /etc/pam.d/rhn-satellite
    auth        required      pam_env.so
    auth        sufficient    pam_sss.so 
    auth        required      pam_deny.so
    account     sufficient    pam_sss.so
    account     required      pam_deny.so
    EOF
</pre></code>
1. Restart Spacewalk and sign on.

### Further reading
1. [http://jensd.be/566/linux/install-and-use-spacewalk-2-3-on-centos-7](http://jensd.be/566/linux/install-and-use-spacewalk-2-3-on-centos-7)
1. [https://community.oracle.com/docs/DOC-921379](https://community.oracle.com/docs/DOC-921379)
