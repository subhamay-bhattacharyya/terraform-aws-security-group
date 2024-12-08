/*
####################################################################################################
# Terraform Security Group Module Configuration
#
# Description: This module creates a Security Group in AWS with the specified rules.
#
# Author: Subhamay Bhattacharyya
# Created: 07-Dec-2024 
# Version: 1.0
#
####################################################################################################
*/


# Creates an AWS Security Group with the specified configuration.
# 
# Arguments:
#   name        - The name of the security group, constructed using project name, security group configuration name, and CI build identifier.
#   description - A description of the security group, provided by the security group configuration.
#   vpc_id      - The ID of the VPC where the security group will be created.
# 
# Tags:
#   Name - A tag for the security group, constructed using project name, security group configuration name, and CI build identifier.
resource "aws_security_group" "security_group" {
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
#   security_group_id: The ID of the security group to which the ingress rule will be applied.
#   cidr_ipv4: The CIDR blocks to allow access from. If `cidr_blocks` is not empty, it will be used; otherwise, it will be null.
#   referenced_security_group_id: The ID of the referenced security group. Used if `cidr_blocks` is null.
#   ip_protocol: The IP protocol for the rule (e.g., "tcp", "udp", "icmp").
#   from_port: The starting port for the rule.
#   to_port: The ending port for the rule.
#   description: A description for the rule.
#   tags: A map of tags to assign to the rule, including a "Name" tag.
resource "aws_vpc_security_group_ingress_rule" "sg_ingress_rule" {
  for_each                     = var.security-group-configuration["ingress"]
  security_group_id            = aws_security_group.security_group.id
  cidr_ipv4                    = each.value["cidr_blocks"] != [] ? each.value["cidr_blocks"] : null
  referenced_security_group_id = each.value["cidr_blocks"] == null ? var.referenced-sg-id : null
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
#   security_group_id: The ID of the security group to which this egress rule will be applied.
#   cidr_ipv4: The CIDR blocks to which this egress rule applies. Defaults to null if not specified.
#   ip_protocol: The IP protocol for the egress rule (e.g., "tcp", "udp", "icmp").
#   from_port: The starting port for the egress rule.
#   to_port: The ending port for the egress rule.
#   description: A description for the egress rule.
#   tags: A map of tags to assign to the egress rule, including a "Name" tag.
resource "aws_vpc_security_group_egress_rule" "sg_egress_rule" {
  for_each          = var.security-group-configuration["egress"]
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = each.value["cidr_blocks"] != null ? each.value["cidr_blocks"] : null
  ip_protocol       = each.value.protocol
  from_port         = each.value.from
  to_port           = each.value.to
  description       = each.value.description
  tags = {
    "Name" : each.value.name
  }
}