---
title: CFEngine as a crond alternative
tags: cfengine, configuration management, cron
---

CFEngine’s time based classes and promise theory make it an attractive
alternative to venerable crond.

---

It helps if the reader is familiar with CFEngine syntax. If not, then skip the
syntax and just be aware that what is described is possible.

Both crond and CFEngine have flexible time descriptions but, CFEngine offers
more.

### CFEngine versus Crond

<tr>
	<td>Time criteria</td>
	<td>Crond</td>
	<td>CFEngine</td>
</tr>
<tr>
	<td>Clock hour</td>
	<td>0, 1, 2 ... 23</td>
	<td>Hr00, Hr01, Hr03 ... Hr23</td>
</tr>
<tr>
	<td>Clock minutes</td>
	<td>0, 1, 2, .. 59</td>
	<td>Min00, Min01, Min02 ... Min59</td>
</tr>
<tr>
	<td>Day of week</td>
	<td>0, 1, 2 ... 7</td>
	<td>Sunday, Monday ... Friday</td>
</tr>
<tr>
	<td>Month</td>
	<td>1, 2, 3 .. 12</td>
	<td>January, February ... December</td>
</tr>
<tr>
	<td>Day of month</td>
	<td>1, 2, 3 .. 31</td>
	<td>Day1, Day2 ... Day31</td>
</tr>
<tr>
	<td>Year</td>
	<td>n/a</td>
	<td>Yr1997, Yr2009</td>
</tr>
<tr>
	<td>Six hour shift</td>
	<td>0,1,2,3,4,5</td>
	<td>Night, Morning, Afternoon, Evening</td>
</tr>

Let’s look at some time criteria and how both crond and CFEngine can be used to
describe them.

#### May 9 at 0900.
##### In cron

    0 9 9 6 *

##### In CFEngine

    May.Day9.Hr09.Min00::

#### Sundays at 0700.
##### In Cron

    0 7 * * 0

##### In CFEngine

    Sunday.Hr07.Min00::

#### Last Saturday of the month.

##### In Cron

Possible with an external shell script.

##### In CFEngine

Complicated but possible:

    January|March|May|July|August|October|December::
    "Last_Saturday" and => { "Saturday", classmatch("Day(2[5-9]|3[01])") };

    April|June|September|November::
    "Last_Saturday" and => { "Saturday", classmatch("Day(2[4-9]|30)") };

    February::
    "Last_Saturday" and => { "Saturday", classmatch("Day2[2-9]") };
 

You can also use CFEngine to account for organizational holidays. This allows
for jobs to be skipped on those days. For example.

    classes:
       "Holidays" or => { "January.Day1", "December.Day25" };

    commands:

       Hr07.Min00.!Holidays::
          "/usr/bin/tar .... etc";

### Reliability.

This is where CFEngine can outshine crond. If crond misses its time window or
if the command fails crond will not retry until the time window returns. Using
CFEngine, if the command fails CFEngine will not consider the promise kept.
It will try again during the next run. CFEngine runs as frequently as five
minute intervals. Consider this typical backup cron job.

    0 5 * * * * tar -czf /root/backup.tgz /home /etc /data

We know that the crond job will run at exactly 0500 hours. If something goes
wrong nothing will happen for another 24 hours. Now consider a CFEngine backup
job.

    Hr05::
       "/usr/bin/tar -czf /root/backup.tgz /home /etc /data"
          ifelapsed => if_elapsed("60");

The CFEngine job will attempt to execute the tar command during each of its
runs during the hour 0500. If the command fails CFEngine will try again during
its next run as long as it is during the 0500 hour. If the command succeeds
then CFEngine will not attempt to run the tar command again for another 60
minutes. Thus CFEngine promises to successfully execute the command once during
the hour 0500.

### Dependencies

Enterprise schedulers can run jobs based on the outcome of other jobs. This
works even between hosts. Try doing this with crond without custom work.
CFEngine does have this ability. CFEngine Nova, the commercial edition, has
something called remote classes. Without going into detail, remote classes
allow a host to determine the status of a job on another host. CFEngine can use
this status to set conditions and run jobs as desired.

### Conclusions

Most shops stick to standard cron jobs. A few make the leap to enterprise
schedulers. CFEngine offers a middle ground in terms of cost and offers the
usual features that it is renowned for, host configuration management.

