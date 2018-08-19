---
title: Automatic Subnets with Terraform
tags: terraform, networking, subnet, cloud
---

<a href="https://terraform.io/"><img style='float:right' alt='terraform logo' width='120px' src='https://raw.githubusercontent.com/hashicorp/terraform-website/master/content//source/assets/images/og-image.png' ></a>

Want to do automatic subnet division in Terraform?
---

Say your AWS VPC is 10.99.0.0/16 and you want to split it into a /20, or 4096 address subnets. With [sipcalc](https://github.com/sii/sipcalc):

    neil@luna:~$ sipcalc -s 20 10.99.0.0/16
    -[ipv4 : 10.99.0.0/16] - 0

    [Split network]
    Network			- 10.99.0.0       - 10.99.15.255
    Network			- 10.99.16.0      - 10.99.31.255
    Network			- 10.99.32.0      - 10.99.47.255
    Network			- 10.99.48.0      - 10.99.63.255
    Network			- 10.99.64.0      - 10.99.79.255
    Network			- 10.99.80.0      - 10.99.95.255
    Network			- 10.99.96.0      - 10.99.111.255
    Network			- 10.99.112.0     - 10.99.127.255
    Network			- 10.99.128.0     - 10.99.143.255
    Network			- 10.99.144.0     - 10.99.159.255
    Network			- 10.99.160.0     - 10.99.175.255
    Network			- 10.99.176.0     - 10.99.191.255
    Network			- 10.99.192.0     - 10.99.207.255
    Network			- 10.99.208.0     - 10.99.223.255
    Network			- 10.99.224.0     - 10.99.239.255
    Network			- 10.99.240.0     - 10.99.255.255

    neil@luna:~$ sipcalc 10.99.0.0/20
    -[ipv4 : 10.99.0.0/20] - 0

    [CIDR]
    Host address		- 10.99.0.0
    Host address (decimal)	- 174260224
    Host address (hex)	- A630000
    Network address		- 10.99.0.0
    Network mask		- 255.255.240.0
    Network mask (bits)	- 20
    Network mask (hex)	- FFFFF000
    Broadcast address	- 10.99.15.255
    Cisco wildcard		- 0.0.15.255
    Addresses in network	- 4096
    Network range		- 10.99.0.0 - 10.99.15.255
    Usable range		- 10.99.0.1 - 10.99.15.254

You can do this with terraform's [cidrsubnet function](https://www.terraform.io/docs/configuration/interpolation.html#cidrsubnet-iprange-newbits-netnum-). Terraform even has a console you can use for testing:

    neil@luna:~$ terraform console
    > cidrsubnet("10.99.0.0/16", 4, 0)
    10.99.0.0/20
    > cidrsubnet("10.99.0.0/16", 4, 1)
    10.99.16.0/20
    > cidrsubnet("10.99.0.0/16", 4, 2)
    10.99.32.0/20

Sadly the documentation about the function is poor.

1. The first argument is the VPC's complete cidr.
1. The second is the number to add to the slash number to get the new subnet slash number. In this case /16 + 4 = /20.
1. The third argument is the index of the list of new subnets. We are dividing 10.99.0.0/16 into multiple smaller subnets and 0 is the first. It's like an array.

Now use it in Terraform policy to create two subnets, 10.99.0.0/20 and 10.99.16.0/20.

    resource "aws_subnet" "sub01" {
      vpc_id     = "${aws_vpc.main.id}"
      # 10.99.0.0/20
      cidr_block = "${cidrsubnet("10.99.0.0/16", 4, 1)}"
      tags {
        Name = "01"
      }
    }
    resource "aws_subnet" "sub02" {
      vpc_id     = "${aws_vpc.main.id}"
      # 10.99.16.0/20
      cidr_block = "${cidrsubnet("10.99.0.0/16", 4, 2)}"
      tags {
        Name = "02"
      }
    }

A tip of the hat to [It's Just Code](http://blog.itsjustcode.net/blog/2017/11/18/terraform-cidrsubnet-deconstructed/) who explained this so well for me.

