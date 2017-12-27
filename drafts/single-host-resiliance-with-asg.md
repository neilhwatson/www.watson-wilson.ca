---
title: AWS single host resiliance with autoscaling groups
tags: aws, cloud, asg, autoscaling, ha, terrafom
---

Make even a single EC2 host highly available using autoscaling groups. Here's example using ASG, EFS for persistent data, and Terraform for easy automation.

---

Although this example is about AWS other cloud providers can have similar concepts for you to use. My goal for this exercise was to create a single host for some remote work, have it resiliant agains zone outages, and have persistent data if the host is recreated.

## Key Concetps

* [Autoscaling](http://docs.aws.amazon.com/autoscaling/latest/userguide/WhatIsAutoScaling.html) is a way to duplication VMs on demand.
* [EFS](http://docs.aws.amazon.com/efs/latest/ug/how-it-works.html) Hint: *It's NFS*
* [Terraform](http://docs.aws.amazon.com/efs/latest/ug/how-it-works.html) Is way to build your infrastructure with code. Hint: *Like [CloudFormation](http://docs.aws.amazon.com/efs/latest/ug/how-it-works.html) but better*
* [Terraform Modules](https://github.com/neilhwatson/terraform-modules) used in this example.

## TOOD Diagram

## Code for EFS

EFS, to spite Amazon's aweful namgin schemes, is simple a managed NFS service. You define a file system, and then a mount target (exports for NFS verterans) in any subnet where your EC2 instance may reside.

EFS works on TCP port 2049. [Configure your security groups](http://docs.aws.amazon.com/efs/latest/ug/security-considerations.html) as required. Id did this, binding the EFS required rules to a security group that will be use by my insance:

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

Back to EFS, here is how we define an EFS file system and a mount target for each of my two subnets:

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

The autoscaling group or ASG, defines what my instance should look like including, it's size (the default), what SSH key to use, security groups to assign, VPC subnets, and the user data to provion it. Note that I'm use a [Terraform Module](http://docs.aws.amazon.com/efs/latest/ug/security-considerations.html) and it's details are [here](https://github.com/neilhwatson/terraform-modules/blob/master/aws/ec2/asg/00_main.tf).

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

Terraform has a template feature. In this case my user-data.sh is template and I instruct Terraform to render it, repacing the given vars. In this case subnets and the EFS target DNS names.

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

Each EFS mount target has a different hostname. Dig into the script and you'll see how I figure out witch EFS target to point to.

## DNS

If the instance respaws, and with a different IP address, how to ensure it's DNS records are current

# TODO
