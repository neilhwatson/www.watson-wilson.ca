---
title: AWS single host resilience with autoscaling groups
tags: AWS, cloud, asg, autoscaling, high availability, terraform
---

<a href="https://aws.amazon.com/"><img style='float:right' alt='aws logo' width='120px' src='/static/images/aws.png' ></a>

Make even a single AWS EC2 host highly available using autoscaling groups. Here's example using ASG, EFS for persistent data, and Terraform for easy automation.

---

Although this example is about AWS, other cloud providers can have similar concepts for you to use. My goal for this exercise was to create a single host for some remote work, have it resilient against zone outages, and have persistent data if the host is recreated.

## Key Concepts

* [Autoscaling](http://docs.aws.amazon.com/autoscaling/latest/userguide/WhatIsAutoScaling.html) is a way to duplication VMs on demand.
* [EFS](https://aws.amazon.com/efs/) Hint: *It's NFS*
* [Terraform](https://www.terraform.io/) Is way to build your infrastructure with code. Hint: *Like [CloudFormation](https://aws.amazon.com/cloudformation/) but better*
* [Terraform Modules](https://github.com/neilhwatson/terraform-modules) used in this example.

## Code for EFS

EFS, to spite Amazon's [awful naming schemes](https://www.expeditedssl.com/aws-in-plain-english), is simply a managed NFS service. You define a file system, and then a mount target (exports for NFS veterans) in any subnet where your EC2 instance may reside.

EFS works on TCP port 2049. [Configure your security groups](http://docs.aws.amazon.com/efs/latest/ug/security-considerations.html) as required. I did this, binding the EFS required rules to a security group that will be use by my instance:

    resource "aws_security_group" "nfs01" {
        vpc_id      = "${data.terraform_remote_state.vpc01.vpc}"
        tags        = "${var.tag}"

        ingress {
            from_port        = 2049
            to_port          = 2049
            protocol         = "tcp"
            security_groups  = [ "${aws_security_group.sg01.id}" ]
        }
    }

Back to EFS, here is how I define an EFS file system and a mount target for each of my two subnets:

    resource "aws_efs_file_system" "neil" {
      creation_token = "neil-home"
      tags           = "${var.tag}"
    }
    resource "aws_efs_mount_target" "neil01" {
      file_system_id  = "${aws_efs_file_system.neil.id}"
      subnet_id       = "${data.terraform_remote_state.vpc01.subnet01_id}"
      security_groups = [ "${aws_security_group.nfs01.id}" ]
    }
    resource "aws_efs_mount_target" "neil02" {
      file_system_id  = "${aws_efs_file_system.neil.id}"
      subnet_id       = "${data.terraform_remote_state.vpc01.subnet02_id}"
      security_groups = [ "${aws_security_group.nfs01.id}" ]
    }


## Code for ASG

The autoscaling group or ASG, defines what my instance should look like, including it's size (the default), what SSH key to use, security groups to assign, VPC subnets, and the user data to provision it. Note that I use a [Terraform Module](http://docs.aws.amazon.com/efs/latest/ug/security-considerations.html) and it's details are [here](https://github.com/neilhwatson/terraform-modules/blob/master/aws/ec2/asg/00_main.tf).

    module "asg" {
       asg_name            = "jumpbox"
       min_size            = 0
       desired_capacity    = 1
       source              = "github.com/neilhwatson/terraform-modules//aws/ec2/asg"
       ami_id              = "${module.ami01.image_id}"
       ssh_key             = "luna"
       instance_profile    = "${aws_iam_instance_profile.route53_upsert.id}"
       security_groups     = [ "${aws_security_group.sg01.id}" ]
       user_data           = "${data.template_file.user-data.rendered}"
       tag                 = "${var.tag}"
       associate_public_ip = "true"
       vpc_zone_ids        = [ "${data.terraform_remote_state.vpc01.subnet01_id}"
                         , "${data.terraform_remote_state.vpc01.subnet02_id}" ]
    }

The magic is in the minimum size and the desired_capacity. It means that there should be between 0 and 1 instances and that 1 is the ideal. This ensures that there will always be one instance, never more than one, and if for any reason an instance dies, another one will be created.

## User data

User data is AWS speak for a basic provisioning script. Mine is quite large, but hears the key points:

### Its a template

Terraform has a [template feature](https://www.terraform.io/docs/providers/template/d/file.html). In this case my user-data.sh is template and I instruct Terraform to render it, replacing the given vars. In this case subnets and the EFS target DNS names.

    data "template_file" "user-data" {
      template = "${file("user_data.sh")}"

      vars {
         subnet01    = "${data.terraform_remote_state.vpc01.subnet01_id}"
         subnet02    = "${data.terraform_remote_state.vpc01.subnet02_id}"
         nfstarget01 = "${aws_efs_mount_target.neil01.dns_name}"
         nfstarget02 = "${aws_efs_mount_target.neil01.dns_name}"
      }
    }

Earlier in my ASG setup, I passed this parameter, the user data template:

    user_data = "${data.template_file.user-data.rendered}"

### EFS

Functions to mount EFS and put the mount in fstab:

    function mount_nfs() {
       host=$1

       mkdir /home/neil
       mount -t nfs -o \
          nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 \
          $${host}:/ /home/neil
    }

    function add_mount_to_fstab() {
       host=$1

       echo "$${host}:/ /home/neil nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0" \
          >> /etc/fstab

    }

Each EFS mount target has a different hostname. Dig into the script and you'll see how I figure out which EFS target to point to.

## DNS

If the instance re-spawns, and with a different IP address, how can I ensure it's DNS records are current? An elastic IP is an obvious choice, but I can do it cheaper.  I configured my VPC to automatically assign public IPs to hosts. Now I just need to get that IP? The [instance metadata](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html) will provide, and once I know that I use [cli53](https://github.com/barnybug/cli53) to set or change my A and AAAA records for the new IP address.


## The script

This is a [Terraform template](https://www.terraform.io/docs/providers/template/d/file.html) of the script ${} variables will be substituted by Terraform. $${} variables are normal shell variables.

%= highlight Bash => begin
    #!/bin/bash -x

    set -e
    echo "########### Starting user data ##########"

    A_RECORD=orion
    DOMAIN=watson-wilson.ca.
    cli53=https://github.com/barnybug/cli53/releases/download/0.8.12/cli53-linux-amd64

    meta_host=http://169.254.169.254/latest/meta-data
    mac_addr=$(curl -s $${meta_host}/network/interfaces/macs/)
    subnet01=${subnet01}
    subnet02=${subnet02}
    nfstarget01=${nfstarget01}
    nfstarget02=${nfstarget02}

    function get_ipv4() {
       ipv4=$(curl -s $${meta_host}/public-ipv4)

       echo $ipv4
    }

    function get_ipv6() {

       ipv6=$(curl -s $${meta_host}/network/interfaces/macs/$${mac_addr}ipv6s)

       echo $ipv6
    }

    function get_subnet_id() {
       id=$(curl -s $${meta_host}/network/interfaces/macs/$${mac_addr}/subnet-id)

       echo $id
    }

    function mount_nfs() {
       host=$1

       mkdir /home/neil
       mount -t nfs -o \
          nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 \
          $${host}:/ /home/neil
    }

    function add_mount_to_fstab() {
       host=$1

       echo "$${host}:/ /home/neil nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0" \
          >> /etc/fstab

    }

    # For buggy ubuntu ipv6 config
    echo "iface eth0 inet6 dhcp" >> /etc/network/interfaces.d/60-default-with-ipv6.cfg
    dhclient -6

    add-apt-repository -y ppa:ansible/ansible
    apt-get -y update
    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
    apt-get -y install \
        curl \
        git \
        ansible \
        awscli \
        nfs-common

    #
    # NFS mount
    #
    subnetid=$(get_subnet_id)
    if [[ $subnetid = $subnet01 ]]
    then
       nfshost=$nfstarget01
    elif [[ $subnetid = $subnet02 ]]
    then
       nfshost=$nfstarget02
    else
       echo "ERROR cannot find subnet and nfs target"
       exit 1
    fi

    mount_nfs $nfshost
    add_mount_to_fstab $nfshost

    #
    # Set this host's IP address to the desired DNS name.
    #
    curl -sLo /usr/local/bin/cli53 $cli53
    chmod 755 /usr/local/bin/cli53

    hostname=$(curl -s $${meta_host}/public-hostname)

    ipv4=$(get_ipv4)
    cli53 rrcreate --replace $DOMAIN "$A_RECORD 60 A $ipv4"

    ipv6=$(get_ipv6)
    cli53 rrcreate --replace $DOMAIN "$A_RECORD 60 AAAA $ipv6"

    #
    # Setup access to provisioning repo
    #
    cat <<'END_PULL' > /etc/cron.hourly/ansible-pull
    #!/bin/bash

    ansible-pull -f -U https://git-codecommit.ca-central-1.amazonaws.com/v1/repos/instance-provisioner jump-box.yml

    END_PULL

    chmod 755 /etc/cron.hourly/ansible-pull

    export HOME="/root"
    cd $HOME
    git config --global credential.helper '!aws codecommit credential-helper $@'
    git config --global credential.UseHttpPath true
    aws configure set region ca-central-1

    /etc/cron.hourly/ansible-pull

    ansible-pull -U https://git-codecommit.ca-central-1.amazonaws.com/v1/repos/instance-provisioner cfbot.yml
% end
