---
title: CFEngine as a crond alternative
tags: cfengine, configuration management, cron
---

Cfengine’s time based classes and promise theory make it an attractive alternative to venerable crond.

---

It helps if the reader is familiar with Cfengine syntax. If not, then skip the syntax and just be aware that what is described is possible.

Both crond and Cfengine have flexible time descriptions but, Cfengine offers more.
Cfengine versus Crond Time criteria    Crond    Cfengine
Clock hour  0, 1, 2 ... 23    Hr00, Hr01, Hr03 ... Hr23
Clock minutes  0, 1, 2, .. 59    Min00, Min01, Min02 ... Min59
Day of week    0, 1, 2 ... 7  Sunday, Monday ... Friday
Month    1, 2, 3 .. 12  January, February ... December
Day of month   1, 2, 3 .. 31  Day1, Day2 ... Day31
Year  n/a   Yr1997, Yr2009
Six hour shift    0,1,2,3,4,5    Night, Morning, Afternoon, Evening

Let’s look at some time criteria and how both crond and Cfengine can be used to describe them.

    May 9 at 0900.
        In cron

        0 9 9 6 *

        In Cfengine

        May.Day9.Hr09.Min00::

    Sundays at 0700.
        In Cron

        0 7 * * 0

        In Cfengine

        Sunday.Hr07.Min00::

    Last Saturday of the month.
        In Cron: Possible with an external shell script.
        In Cfengine: Complicated but possible.

        January|March|May|July|August|October|December::
        "Last_Saturday" and => { "Saturday", classmatch("Day(2[5-9]|3[01])") };

        April|June|September|November::
        "Last_Saturday" and => { "Saturday", classmatch("Day(2[4-9]|30)") };

        February::
        "Last_Saturday" and => { "Saturday", classmatch("Day2[2-9]") };
         

You can also use Cfengine to account for organizational holidays. This allows for jobs to be skipped on those days. For example.

classes:
   "Holidays" or => { "January.Day1", "December.Day25" };

commands:

   Hr07.Min00.!Holidays::
      "/usr/bin/tar .... etc";

Reliability.

This is where Cfengine can outshine crond. If crond misses its time window or if the command fails crond will not retry until the time window returns. Using Cfengine, if the command fails Cfengine will not consider the promise kept. It will try again during the next run. Cfengine runs as frequently as five minute intervals. Consider this typical backup cron job.

0 5 * * * * tar -czf /root/backup.tgz /home /etc /data

We know that the crond job will run at exactly 0500 hours. If something goes wrong nothing will happen for another 24 hours. Now consider a Cfengine backup job.

Hr05::
   "/usr/bin/tar -czf /root/backup.tgz /home /etc /data"
      ifelapsed => if_elapsed("60");

The Cfengine job will attempt to execute the tar command during each of its runs during the hour 0500. If the command fails Cfengine will try again during its next run as long as it is during the 0500 hour. If the command succeeds then Cfengine will not attempt to run the tar command again for another 60 minutes. Thus Cfengine promises to successfully execute the command once during the hour 0500.
Dependencies

Enterprise schedulers can run jobs based on the outcome of other jobs. This works even between hosts. Try doing this with crond without custom work. Cfengine does have this ability. Cfengine Nova, the commercial edition, has something called remote classes. Without going into detail, remote classes allow a host to determine the status of a job on another host. Cfengine can use this status to set conditions and run jobs as desired.
Conclusions

Most shops stick to standard cron jobs. A few make the leap to enterprise schedulers. Cfengine offers a middle ground in terms of cost and offers the usual features that it is renowned for, host configuration management.

