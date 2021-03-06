---
title: Enterprise system administration using configuration management
tags: configuration management, sysadmin, cfengine
---

To maintain the large quantity of servers typically found in enterprise
organizations, systems administration must move beyond manual and custom
scripts toward a centralized configuration management service. This move can
save an organization considerable time and money.

---

[Introduction](#introduction)
[Stages of configuration management](#stages)
[Manual stage](#manual)
[Custom automation stage](#custom)
[Dedicated service stage](#dedicated)
[Practical Examples](#practical)
[Security](#security)
[Automated builds](#builds)
[Host replacement](#replacement)
[Self healing](#healing)
[Savings](#savings)
[Perception of control](#control)

## <a name='introduction'></a>Introduction

When talking about system administration in this paper I am referring to the
act of maintaining UNIX hosts and their services. System administration is more
than this but for this paper I will discuss only a subset of system
administration skills which I call configuration management. Configuration
management is the act of creating new hosts and maintaining existing ones and
their services according to the specifications of an organization's policies.

## <a name='stages'></a>Stages of configuration management

As an organization adds more and more hosts, both physical and virtual, its
system administrators must spend more and more time ensuring that all hosts
comply with policy. This results in an explosive demand in manpower.
Organizations can often find themselves constantly falling behind, never able
to finish projects on time or neglecting less visible infrastructure in order
to deliver other highly visible projects.

In order to prevent this situation the organization must grow its methods of
configuration management. The growth of configuration management usually has
three distinct phases: manual, custom automation, and dedicated service. Few
organizations grow beyond the manual stage. Fewer still beyond custom
automation.

### <a name='manual'></a>Manual stage

Management the manual way (see figure 1) involves copying files and issuing
manual commands repeatedly to every host. With this method a simple three
minute change applied to sixty hosts becomes a two hour job. Worse still, such
changes are static. There is no way to know if changes are still in place
without a manual audit.

##### Figure 1: Manual configuration management 
![Manual configuration management](/blog/2011/03/08/enterprise-sysadmin/manual-admin.png)

### <a name='custom'></a>Custom automation stage

Some administrators develop a kit of custom scripts (see figure 2) and files
that are deployed from host to host by a further set of custom scripts and
services. This method is effective by allowing the administrator to automate a
change across all hosts but does not scale well. More and more scripts must be
created and maintained as the number of hosts and services grow. Trying to
maintain an ever growing collection of dissimilar custom scripts can become a
project of its own. Further, new members of the system administrator team will
have to spend time learning this entirely custom environment.

##### Figure 2: Custom configuration management scripted-admin.png
![Custom configuration management](/blog/2011/03/08/enterprise-sysadmin/scripted-admin.png)


### <a name='dedicated'></a>Dedicated service stage

A dedicated configuration management service (see figure 3) offers the time
savings of automated custom scripts but in a more maintainable way. A Dedicated
service has built in methods for handling many configuration changes that
eliminate the need for custom scripts. Also, since this service is not entirely
custom it is possible to find new team members with previous experience.

##### Figure 3: Dedicated configuration management config-admin.png
![Dedicated configuration management](/blog/2011/03/08/enterprise-sysadmin/config-admin.png)

Dedicated configuration management allows system administrators to control
servers from a central location. Administrators are able to make a single
manual change and have that change automatically deployed to all desired hosts
across the network. The configuration management service continuously ensures
that these changes are applied. This can save an organization time and money.
All changes in a configuration management system are version controlled. This
means that all change history is recorded for auditing and disaster recovery.

## <a name='practical'></a>Practical Examples

The following are practical examples of how configuration management can save
an organization countless resources.

### <a name='secruticy'></a>Security

A tedious and constantly changing security policy must be maintained across
some or all hosts. Many aspects of a security policy define how a service or
host should be configured. A typical security policy may touch upon PAM files,
log file permissions, log history retention, home directory permissions and SSH
configuration to name a few. A configuration management service can be used to
maintain all of these examples and more. Using this service ensures that hosts
meet the current policy requirements. New hosts will have the policy
automatically applied. Policy changes need only be defined once then applied
automatically to all current and future hosts.

All configurations are stored in the configuration management service's master
files location. The master files are version controlled. With version control
one can easily determine every line that has been changed, when that change was
checked in and by whom.

### <a name='builds'></a>Automated builds

Jumpstart or kickstart services can only accomplish so much. Final
configurations are typically done by hand or by a collection of custom scripts.
A configuration management service can apply all additional custom policy
changes to the host automatically.

### <a name='replacement'></a>Host replacement

Host replacement either for end of life hosts or disaster recovery can be more
automated by using the configuration management service. All configurations of
the original host are pointed toward the new host where they will be applied
automatically.

### <a name='healing'></a>Self healing

Some organizations run services to ensure that services and processes are
running, or sometimes not running, on selected hosts. These services are often
given the name network management or network monitoring. Configuration
management cannot replace the essential service of network monitoring but it
can augment it.

Configuration management services can ensure that configuration files are
correct and whether or not services are running. Network monitoring services
typically send notification when services fail. Configuration management
services can actually make corrections preventing the need for notification.

Finally it is also possible for a network monitoring service to automatically
activate a configuration management service when it detects a failure. This
corrective action may repair the failure, again without the need for
notification.

## <a name='savings'></a>Savings

With manual tasks automated staff will now have more time to focus on important
projects. Large tasks like security audits or patch updates can now be
automated across all hosts. (See table 1)

Now consider service outages. Suppose that the configuration management”s self
healing nature prevents just two outages per year. How many employees had to
work, or could not work during those outages? Typically even a small outage can
cost an organization a considerable amount of lost time.

<table>
<tr>
	<td>Task</td>
	<td colspan='2'>Annual time saved in hours</td>
</tr>
<tr>
	<td>Per host</td>
	<td>100 hosts</td>
	<td>1000 hosts</td>
</tr>
<tr>
	<td>Security audit</td>
	<td>1</td>
	<td>100</td>
	<td>1000</td>
</tr>
<tr>
	<td>Patch deployment</td>
	<td>0.5</td>
	<td>50</td>
	<td>500</td>
</tr>
<tr>
	<td>New security change</td>
	<td>0.5</td>
	<td>50</td>
	<td>500</td>
</tr>
<tr>
	<td>Total savings</td>
	<td>2</td>
	<td>200</td>
	<td>2000</td>
</tr>


## <a name='control'></a>Perception of control

Some organizations are not comfortable with the kind of automation that
configuration management offers. They argue that such automation reduces their
control. It is safer, they argue, to have a system administrator oversee things
personally.

Consider that if administrators have to manually confirm that all host
configurations are current then they are already out of control. If a host's
configuration has diverged from policy it is going to take some time for an
administrator to manually discover the problem. It is more likely that a
customer will discover and report the problem first. Where is the control?

Now consider system administrators using a configuration management service.
The administrators can focus on developing their policy centrally while
allowing the configuration management service to ensure that each host conforms
the policy. Using this method both computer and the human administrator can
focus on what they are best at. The administrator can creatively develop
complicated host polices and the computers can continuously and autonomously
ensure compliance to them.

