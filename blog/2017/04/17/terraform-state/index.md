---
title: Understanding Terraform State
tags: terraform, configuration management, cloud, AWS
---

<a href="https://terraform.io/"><img style='float:right' alt='terraform logo' width='120px' src='https://raw.githubusercontent.com/hashicorp/terraform/master/website/source/assets/images/og-image.png' ></a>

Terraform [state](https://www.terraform.io/docs/state/purpose.html) is a database kept by Terraform to help it reconcile Terraform resource dependencies, and reconcile between Terraform code and the actual state on the target infrastructure. For example, in the state, Terraform expects to find an entry that matches your AWS resource defining a Route53 record and in your Terraform code. Whether or not the entry exits determines if Terraform will make a change or not.

---

### A record's state

The following table describes what Terraform will do regarding a resource depending on whether or not it exists in state and in AWS.

<table>
<tr>
	<th>Exists in Terraform state</th>
	<th>Exist in AWS</th>
	<th>Terraform action</th>
</tr>
<tr>
	<td>Yes</td>
	<td>Yes</td>
	<td>None, all is well.</td>
</tr>
<tr>
	<td>Yes</td>
	<td>No</td>
	<td>Terraform will create this resource.</td>
</tr>
<tr>
	<td>No</td>
	<td>Yes</td>
	<td>Terraform will destroy this resource.</td>
</tr>
<tr>
	<td>No</td>
	<td>No</td>
	<td>None, all is well.</td>
</tr>
</table>

Terraform only considers resources that have a history in state. Resources that exist that were never in state are ignored. Thus you can have multiple states in multiple projects and not interfere with each other.

### Importing state

State is created by `terraform apply` or `terraform import`.  Import to import existing infrastructure into the state. You can further use [terraforming](https://github.com/dtan4/terraforming) to an imported resource into AWS Terraform resources code.

