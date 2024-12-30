/*
####################################################################################################
# Terraform Security Group Module Outputs Configuration
#
# Description: This module creates a Security Group in AWS with the specified rules.
#
# Author: Subhamay Bhattacharyya
# Created: 29-Dec-2024 
# Version: 1.0
#
####################################################################################################
*/


# This output provides the ID of the security group.
# The ID can be used to reference the security group in other resources.
output "security-group-id" {
  description = "The ID of the security group."
  value       = try(aws_security_group.security_group[0].id, "No security group ID.")
}

# This output provides the name of the security group.
# The name can be used to identify the security group in the AWS console.
output "security-group-name" {
  description = "The ID of the security group."
  value       = try(aws_security_group.security_group[0].name, "No security group name.")
}

# This output provides the ARN (Amazon Resource Name) of the security group.
# The ARN is a unique identifier for the security group.
output "security-group-arn" {
  description = "The ARN of the security group."
  value       = try(aws_security_group.security_group[0].arn, "No security group ARN.")
}

# This output provides the security group rules.
# It includes both inbound and outbound rules.
# If there are no rules, it will return a message indicating no rules are present.
output "security-group-rules" {
  description = "The security group rules."
  value = {
    inbound  = try(aws_vpc_security_group_egress_rule.sg_egress_rule.*, "No inbound rules."),
    outbound = try(aws_vpc_security_group_ingress_rule.sg_ingress_rule.*, "No outbound rules.")
  }
}