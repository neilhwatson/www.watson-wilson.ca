---
title: Introduction to Terraform
tags: terraform, cloud, configuration management
---

<a href="https://terraform.io/"><img style='float:right' alt='terraform logo' width='120px' src='https://raw.githubusercontent.com/hashicorp/terraform/master/website/source/assets/images/logo-static.png' ></a>

[Terraform](https://terraform.io/) allows you to manage your AWS, and other
cloud infrastructure, the same way you would manage servers using configuration
management products like CFEngine or Puppet. Terraform is idempotent and
convergent so only required changes are applied.

---

I whipped up this example to build:

1. An SSH public key to be installed on the created EC2 instance.
1. A security group allowing HTTP and HTTPS.
1. A security group allowing SSH.
1. A tc2.micro EC2 instance with the above applied to it.

The 'provider' part of the file indicates to terraform to use its AWS provider
with the given credentials. If you know AWS at all the terraform code is not
hard to follow.

Create a file in your current directory called demo.tf. When you run terrafrom
it searches the current directory for .tf files and reads them according to
your instructions. For example:

* <code>Terraform plan</code> will report what must be done, but perform no changes.
* <code>Terraform apply</code> will make the changes shown above.
* <code>Terraform show</code> will show the current state.
* <code>Terraform destroy</code> will <em>destroy everything that is defined</em>.

Note that there seems to be a built in order in which terraform runs that is
not related to the order of the file. This is much like normal ordering in
CFEngine. For example, when I run this code with nothing configured in AWS, it
will try to build the server instance first, but fails because the groups and keys
are not yet defined. But the groups and keys will be created next, so,
run terraform a second time and it will converge, by creating just the instance
while leaving the already existing groups and keys as they are.

<pre><code>
provider "aws" {
   access_key = "your_key_here"
   secret_key = "your_secret_here"
   region = "us-east-1"
}

resource "aws_key_pair" "neptune" {
   key_name = "neptune"
   public_key = "ssh-rsa AAA removed for brevity 1XCr neil@neptune"
}

resource "aws_security_group" "ssh" {
   name = "ssh"
   description = "Allow inbound ssh"
   ingress = {
      from_port = 0
      to_port   = 22
      protocol  = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
   }
}

resource "aws_security_group" "http" {
   name = "http"
   description = "Allow inbound http"
   ingress = {
      from_port = 0
      to_port   = 80 
      protocol  = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
   }
   egress = {
      from_port = 0
      to_port   = 80
      protocol  = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
   }
   egress = {
      from_port = 0
      to_port   = 443
      protocol  = "tcp"
      cidr_blocks = [ "0.0.0.0/0" ]
   }
}

resource "aws_instance" "tfdemo" {

    ami = "ami-60b6c60a"
    instance_type = "t2.micro"

   key_name = "neptune"
   security_groups = [ "ssh", "http", "default" ]
}
</code></pre>

I've shown only a small portion of what terraform can do. Most
[things](https://terraform.io/docs/providers/aws/index.html) you might want to
do in AWS can be defined in Terraform and not just AWS. Terraform also supports
Cloudflare, DigitalOcean, Docker, Google Cloud, vSphere, Azure, and
[more](https://terraform.io/docs/providers/index.html).
