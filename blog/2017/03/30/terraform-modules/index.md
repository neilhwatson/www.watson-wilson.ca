---
title: Terraform modules
tags: terraform, cloud, configuration management
---

<a href="https://terraform.io/"><img style='float:right' alt='terraform logo' width='120px' src='https://raw.githubusercontent.com/hashicorp/terraform/master/website/source/assets/images/logo-static.png' ></a>

Here's what I've learned so far using Terraform and its modules. I've just scratched the surface so test and research on your own.

---

Modules allow you to build parameterized reusable code as you would in programming. Terraform scopes its variables strictly, denying access to variables outside of the running module or inside of another. More later.

In our main terraform file we call a module. Terraform is odd in that if you do a terraform plan it will error out until you 'get' the module. So always do a 'terraform get' first.

    # Create an s3 bucket with the given name
    module "my-s3-bucket" {
        source = "./s3/make_bucket"
        name   = "my-s3-bucket"
    }


The module is all .tf files under ./s3/make_bucket/. In this example we have just one file: main.tf by convention.

    # Must declare expected inputs:
    variable "name" {}

    # Build a named bucket
    resource "aws_s3_bucket" "web_bucket" {

       bucket = "${var.name}"
       force_destroy = true
       acl = "public-read"
        tags = {
            layer = "terraform"
        }
       policy = <<POLICY
    {
      "Version":"2012-10-17",
      "Statement":[{
        "Sid":"PublicReadForGetBucketObjects",
            "Effect":"Allow",
          "Principal": "*",
          "Action":"s3:GetObject",
          "Resource":["arn:aws:s3:::${var.name}/*"
          ]
        }
      ]
    }
    POLICY
      
       website {
          index_document = "index.html"
    # TODO 404.html
       }
    }

    # Allow the bucket id to be dereferenced form outside
    output "bucket_id"
       value = "${aws_s3_bucket.web_bucket.id}"
    }

Now if we want to use this bucket in a later policy the output of the module allows us to call

    ${module.my-s3-bucket.bucket_id}

You should read more over at [terraform.io](https://www.terraform.io/docs/index.html).

### Other things I've learned about terraform

- There are no loops. You can't pass a module a list of data for it to loop over. You must call the module multiple times by hand.

- Use [remote state](https://www.terraform.io/docs/state/remote.html).

- Use a [role based host](https://www.terraform.io/docs/providers/aws/index.html) like at an AWS EC2 host with IAM to authorize terraform to access your provider. Avoid storing passwords.

- Terraform plan, plan, and plan more while you get the hang of it.

- If using [Route53](https://aws.amazon.com/route53/details/) for your DNS but your domain is registered else where you'll get new NS AWS servers when create a new zone. So if you destroy and recreate a zone you'll have to update your registrar.

