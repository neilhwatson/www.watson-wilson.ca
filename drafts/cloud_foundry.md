---
title: Bosh and Cloud Foundry, an intro
tags: cloud, cloud foundry, bosh containers
---

TODO Logo

# Intro

[https://www.cloudfoundry.org/](Cloud Foundry) is an open source platform as a service product owned by Pivotal Software. CF allows you to deploy applications to containers on AWS, Azue, VMware vSphere, and others.

# Bosh

[http://bosh.io/](Bosh) is an open source tool collection for deploying and maintaining applications and their infrastructure. Imagine having a configuration file that defines the number and type of hosts and how to build and deploy your desired applications on each. This is Bosh. 

Bosh communicates with your cloud provider taking your application configuration, building cloud vms, and deploying your application. This is how Cloud Foundry is deployed. [https://github.com/cloudfoundry/cf-release](Cf-release) on Giithub provides the chief method for installing Cloud Foundry using Bosh.

# Installation

The installation of Bosh and CF is not for the faint of heart. I found the documentation to be lacking in details, but if you're careful and pay attention to detail you'll do fine. Some of the difficulties I had:

1. First you have to learn how to build and deploy a Bosh director.
1. The manifest file requires many encryption keys to be generated, but the documentation did not provide details on how.
1. The requirements are large. For a vSphere install: two subnets and about 30 VMs.
1. You need a working DNS. Your CF endpoints and applications must have DNS records. Most will point to the ha_proxy end point.
1. Applications are isolated by IP filtering, default deny. You have to deploy your own rules to allow traffic between applications or out to the public network.
1. The default amount of RAM and storage given to CF 'runner' VMs was not correct and had to be changed. See disk_mb and memory_mb in the CF docs for more info.

Though the time to build Bosh and CF is not short it's hands off once you get going. So you make a change, run the install, and come back later to see if it worked.

Each deployment of CF is built up on the one before it and Bosh remembers each. So you can deploy changes, including upgrades, to CF and Bosh will do so live. You can roll back to any older deployment too.

# Build packs

Once CF is working you can begin deploying applications. This is wonderfully simple. CF comes with build packs that know what your application is an how to deploy it. If you tell CF to deploy index.php it will build and deploy a PHP container in a single step. Using third party build packs I was able to deploy a custom Perl application too.

# High availability

Deployed applications can have multiple instances that reside on multiple Cloud Foundry hosts. All traffic is directed though CF's ha_proxy host.

Cloud Foundry itself has many redundant services. Remember that the CF VMs are configured and built by Bosh. If any host is destroyed or becomes unresponsive Bosh will automatically rebuilt it. Meanwhile CF will move or redeploy applications if they are lost by a downed CF host.

# Scaling

Runner hosts are the VMs that host the application containers. Add more and bigger runner VMs to add more capacity. [https://github.com/mesos/cloudfoundry-mesos](Cloud Foundry-Mesos) is a project to have [https://mesos.apache.org/](Mesos) supply resources to CF but development seems stalled. There is also [https://github.com/nttlabs/bosh-scaler](Bosh-scalar) that empowers Bosh to automatically add more runners.

# Conclusions
