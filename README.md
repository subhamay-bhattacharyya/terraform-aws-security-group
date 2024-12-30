![](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;![](https://img.shields.io/github/last-commit/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;![](https://img.shields.io/github/release-date/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;![](https://img.shields.io/github/repo-size/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;![](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;[](https://img.shields.io/github/issues/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;![](https://img.shields.io/github/languages/top/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;![](https://img.shields.io/github/commit-activity/m/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;![](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/889647c4be2d0f8fb1ef2fb965f2daba/raw/terraform-aws-security-group.json?)

## Terraform AWS Security Group Module

### Usage

* Terraform module to create security groups.
* Module source: app.terraform.io/subhamay-bhattacharyya/security-group/aws
* Version: 1.0.0

### Required Inputs:
- `project-name`: The name of the project.
- `vpc-id`: The ID of the VPC where the security group will be created.
- `security_group_configuration`: A map defining the security group wilth associated rules.
- `ci-build`: A string representing the CI build identifier.

### Example Usage:

```hcl
module "security_group" {
  source  = "app.terraform.io/subhamay-bhattacharyya/security-group/aws"
  version = "1.0.0"

  project-name                 = "your-project-name"
  vpc-id                       = "your-vpc-id"
  security-group-configuration = "your-security-group-configuration"
  ci-build                     = "your-ci-build-string"
}
```

### Security Group configuration

##### Configure the security group with associated rules as a map type variable
```hcl
  security-group-configuration = {
    name        = "ec2-sg"
    description = "EC2 Security Group"
    ingress = {
      ssh = {
        name        = "Allows SSH"
        description = "Allows inbound SSH traffic on port 22 from anywhere."
        from        = 22
        to          = 22
        protocol    = "tcp"
        cidr-blocks = "0.0.0.0/0"
      }
      ssh = {
        name             = "Allows SSH"
        description      = "Allows inbound traffic from ec2 instance connect endpoints on port 22."
        from             = 22
        to               = 22
        protocol         = "tcp"
        referenced-sg-id = module.ecic_security_group.security-group-id
    }
    egress = {
      https = {
        name           = "Allows HTTPS"
        description    = "Allows outbound traffic from ec2 instance security group to s3 prefix list."
        from           = 443
        to             = 443
        protocol       = "tcp"
        prefix-list-id = data.aws_ec2_managed_prefix_list.s3_vpce_prefix_list.id
      }
    }
  }
```

##### Default tags

Use local variables to configure the default tags.
_The default resource tags are implemented using the CI/CD Pipeline. The following mao just refers to it._
```hcl
locals {
  tags = {
    Environment      = var.environment-name
    ProjectName      = var.project-name
    GitHubRepository = var.github-repo
    GitHubRef        = var.github-ref
    GitHubURL        = var.github-url
    GitHubSHA        = var.github-sha
  }
}

Use local variable to configure the security group configuration.

locals {
  vpc-endpoint-sg = {
    name        = "vpc-endpoint"
    description = "VPC Endpoint Security Group"
    ingress = {
      https = {
        name        = "Allows HTTPS"
        description = "Allows inbound traffic from the VPC on port 443."
        from        = 443
        to          = 443
        protocol    = "tcp"
        cidr-blocks = var.vpc-cidr
      }
    }
    egress = {}
  }

  ec2-instance-sg = {
    name        = "ec2-instance"
    description = "EC2 Instance Security Group"
    ingress     = {}
    egress = {}
  }

  ec2-instance-connect-sg = {
    name        = "ec2-instance-connect"
    description = "EC2 Instance Connect Security Group"
    ingress     = {}
    egress      = {}
  }

  ec2-instance-sg-rules = {
    security-group-id = module.ec2_security_group.security-group-id
    ingress = {
      ssh = {
        name             = "Allows SSH"
        description      = "Allows inbound traffic from ec2 instance connect endpoints on port 22."
        from             = 22
        to               = 22
        protocol         = "tcp"
        referenced-sg-id = module.ecic_security_group.security-group-id
      }
    }
    egress = {
      https = {
        name             = "Allows HTTPS"
        description      = "Allows outbound traffic to the endpoints on port 443."
        from             = 443
        to               = 443
        protocol         = "tcp"
        referenced-sg-id = module.vpce_security_group.security-group-id
      }
      https1 = {
        name           = "Allows HTTPS"
        description    = "Allows outbound traffic from ec2 instance security group to s3 prefix list."
        from           = 443
        to             = 443
        protocol       = "tcp"
        prefix-list-id = data.aws_ec2_managed_prefix_list.s3_vpce_prefix_list.id
      }
    }
  }

  ec2-instance-connect-sg-rules = {
    security-group-id = module.ecic_security_group.security-group-id
    ingress           = {}
    egress = {
      ssh = {
        name             = "Allows SSH"
        description      = "Allows outbound SSH traffic on port 22 to ec2 instance security group."
        from             = 22
        to               = 22
        protocol         = "tcp"
        referenced-sg-id = module.ec2_security_group.security-group-id
      }
    }
}

```
#### Note


## Inputs

| Name                      | Description                                                                 | Type   | Default       | Required |
|- |- |- |- |- |
| project-name              | The name of the project                                                     | string | n/a           | yes      |
| vpc-id                    | The VPC ID where the security group will be created                         | string | n/a           | yes      |
| security-group-configuration | Configuration for the security group                                      | object | n/a           | yes      |
| ci-build                  | A string representing the CI build identifier                               | string | ""            | yes      |

## Outputs

| Name                  | Description                                      |
|- |- |
| security-group-id     | The ID of the security group.                    |
| security-group-name   | The name of the security group.                  |
| security-group-arn    | The ARN of the security group.                   |
| security-group-rules  | The security group rules (inbound and outbound). |