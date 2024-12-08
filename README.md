![](https://img.shields.io/github/commit-activity/t/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;![](https://img.shields.io/github/last-commit/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;![](https://img.shields.io/github/release-date/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;![](https://img.shields.io/github/repo-size/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;![](https://img.shields.io/github/directory-file-count/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;[](https://img.shields.io/github/issues/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;![](https://img.shields.io/github/languages/top/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;![](https://img.shields.io/github/commit-activity/m/subhamay-bhattacharyya/terraform-aws-security-group)&nbsp;![](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/bsubhamay/889647c4be2d0f8fb1ef2fb965f2daba/raw/terraform-aws-security-group.json?)

# Terraform AWS Security Group Module

### Example Usage:

```hcl
module "security_group" {
  source  = "app.terraform.io/subhamay-bhattacharyya/security-group/aws"
  version = "1.0.0"

  aws-region               = "us-east-1"
  project-name             = "your-project-name"
  environment-name         = "devl"
  vpc-id                   = "your-vpc-id"
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
        cidr_blocks = "0.0.0.0/0"
      }
    }
    egress = {
      all = {
        name        = "Allows all outbound traffic"
        description = "Allows all outbound traffic."
        from        = 0
        to          = 0
        protocol    = "-1"
        cidr_blocks = "0.0.0.0/0"
      }
    }
  }
  ci-build = "your-ci-build-string"
}
```

##### Default tags

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
```
#### Note


## Inputs

| Name                      | Description                                                                 | Type   | Default       | Required |
|- |- |- |- |- |
| aws-region                | The AWS region where the security group will be created                     | string | us-east-1     | yes      |
| project-name              | The name of the project                                                     | string | n/a           | yes      |
| environment-name          | The environment name (e.g., "devl")                                         | string | devl          | yes      |
| vpc-id                    | The VPC ID where the security group will be created                         | string | n/a           | yes      |
| security-group-configuration | Configuration for the security group                                      | object | n/a           | yes      |
| github-repo               | The GitHub repository name                                                  | string | ""            | no       |
| github-ref                | The GitHub reference (branch or tag)                                        | string | ""            | no       |
| github-url                | The GitHub URL                                                              | string | ""            | no       |
| github-sha                | The GitHub commit SHA                                                       | string | ""            | no       |
| ci-build                  | A string representing the CI build identifier                               | string | ""            | yes      |

## Outputs

| Name                  | Description                                      |
|- |- |
| security-group-id     | The ID of the security group.                    |
| security-group-name   | The name of the security group.                  |
| security-group-arn    | The ARN of the security group.                   |
| security-group-rules  | The security group rules (inbound and outbound). |