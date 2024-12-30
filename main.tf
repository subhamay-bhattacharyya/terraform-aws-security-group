/*
####################################################################################################
# Terraform Security Group Module Configuration
#
# Description: This module creates a Security Group in AWS with the specified rules.
#
# Author: Subhamay Bhattacharyya
# Created: 29-Dec-2024 
# Version: 1.0
#
####################################################################################################
*/



# Creates an AWS Security Group based on the provided configuration.
# 
# Arguments:
# - var.security-group-configuration.name: The name of the security group. If null, the resource is not created.
# - var.project-name: The name of the project, used to prefix the security group name.
# - var.security-group-configuration.description: The description of the security group.
# - var.vpc-id: The ID of the VPC where the security group will be created.
# - var.ci-build: The CI build identifier, used to suffix the security group name.
# 
# Tags:
# - Name: The name tag for the security group, formatted as "${var.project-name}-${var.security-group-configuration.name}-sg${var.ci-build}".
resource "aws_security_group" "security_group" {
  count       = var.security-group-configuration.name != null ? 1 : 0
  name        = "${var.project-name}-${var.security-group-configuration.name}-sg${var.ci-build}"
  description = var.security-group-configuration.description
  vpc_id      = var.vpc-id

  tags = {
    Name = "${var.project-name}-${var.security-group-configuration.name}-sg${var.ci-build}"
  }
}



# Creates an ingress rule for a security group in AWS VPC.
# 
# Arguments:
#   for_each: Iterates over the ingress rules defined in the variable `security-group-configuration["ingress"]`.
#   security_group_id: The ID of the security group to which the ingress rule will be applied. If the security group name is provided, it uses the ID of the created security group, otherwise it uses the provided security group ID.
#   cidr_ipv4: The CIDR blocks to allow access from. Defaults to null if not provided.
#   referenced_security_group_id: The ID of the referenced security group to allow access from. Defaults to null if not provided.
#   prefix_list_id: The ID of the prefix list to allow access from. Defaults to null if not provided.
#   ip_protocol: The IP protocol to allow (e.g., "tcp", "udp", "icmp").
#   from_port: The starting port to allow access from.
#   to_port: The ending port to allow access to.
#   description: A description for the ingress rule.
#   tags: A map of tags to assign to the ingress rule. Includes a "Name" tag with the value from the ingress rule configuration.
resource "aws_vpc_security_group_ingress_rule" "sg_ingress_rule" {
  for_each                     = var.security-group-configuration["ingress"]
  security_group_id            = var.security-group-configuration.name != null ? aws_security_group.security_group[0].id : var.security-group-configuration.security-group-id
  cidr_ipv4                    = each.value["cidr-blocks"] != null ? each.value["cidr-blocks"] : null
  referenced_security_group_id = each.value["referenced-sg-id"] != null ? each.value["referenced-sg-id"] : null
  prefix_list_id               = each.value["prefix-list-id"] != null ? each.value["prefix-list-id"] : null
  ip_protocol                  = each.value.protocol
  from_port                    = each.value.from
  to_port                      = each.value.to
  description                  = each.value.description

  tags = {
    "Name" : each.value.name
  }
}


# Creates an egress rule for a security group in AWS VPC.
# 
# Arguments:
#   for_each: Iterates over the egress rules defined in the variable `security-group-configuration["egress"]`.
#   security_group_id: The ID of the security group to which the egress rule will be applied. If the security group name is provided, it uses the ID of the created security group, otherwise it uses the provided security group ID.
#   cidr_ipv4: The CIDR blocks to which the egress rule applies. Defaults to null if not provided.
#   referenced_security_group_id: The ID of the referenced security group for the egress rule. Defaults to null if not provided.
#   prefix_list_id: The ID of the prefix list for the egress rule. Defaults to null if not provided.
#   ip_protocol: The IP protocol for the egress rule (e.g., "tcp", "udp", "icmp").
#   from_port: The starting port for the egress rule.
#   to_port: The ending port for the egress rule.
#   description: A description for the egress rule.
#   tags: A map of tags to assign to the egress rule, including a "Name" tag.
resource "aws_vpc_security_group_egress_rule" "sg_egress_rule" {
  for_each                     = var.security-group-configuration["egress"]
  security_group_id            = var.security-group-configuration.name != null ? aws_security_group.security_group[0].id : var.security-group-configuration.security-group-id
  cidr_ipv4                    = each.value["cidr-blocks"] != null ? each.value["cidr-blocks"] : null
  referenced_security_group_id = each.value["referenced-sg-id"] != null ? each.value["referenced-sg-id"] : null
  prefix_list_id               = each.value["prefix-list-id"] != null ? each.value["prefix-list-id"] : null
  ip_protocol                  = each.value.protocol
  from_port                    = each.value.from
  to_port                      = each.value.to
  description                  = each.value.description

  tags = {
    "Name" : each.value.name
  }
}