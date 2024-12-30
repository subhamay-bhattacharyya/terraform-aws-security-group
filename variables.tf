/*
####################################################################################################
# Terraform Security Group Module Variabls Configuration
#
# Description: This module creates a Security Group in AWS with the specified rules.
#
# Author: Subhamay Bhattacharyya
# Created: 29-Dec-2024 
# Version: 1.0
#
####################################################################################################
*/

######################################## Project Name ##############################################
# This variable defines the name of the project.
# It is a string type variable with a default value of "your-project-name".
# You can override this default value by providing a different project name.
variable "project-name" {
  description = "The name of the project"
  type        = string
  default     = "your-project-name"
}

######################################## Security Group #########################################
# This variable defines the VPC ID where the security group will be created.
# - description: A brief explanation of the variable's purpose.
# - type: The data type of the variable, which is a string in this case.
# - default: The default value for the variable, which is an empty string.
variable "vpc-id" {
  description = "The VPC ID where the security group will be created."
  type        = string
  default     = ""
}

# 
# This variable defines the configuration for the security group.
# 
# Variable: security-group-configuration
# 
# Description: Configuration for the security group.
# 

variable "security-group-configuration" {
  description = "Configuration for the security group."
  type = object({
    name              = optional(string)
    description       = optional(string)
    security-group-id = optional(string)
    ingress = map(object({
      name             = string
      description      = string
      from             = number
      to               = number
      protocol         = string
      cidr-blocks      = optional(string)
      referenced-sg-id = optional(string)
      prefix-list-id   = optional(string)
    }))
    egress = map(object({
      name             = string
      description      = string
      from             = number
      to               = number
      protocol         = string
      cidr-blocks      = optional(string)
      referenced-sg-id = optional(string)
      prefix-list-id   = optional(string)
    }))
  })
  default = {
    name        = "ec2-sg"
    description = "EC2 Security Group"
    ingress = {
      ssh = {
        name        = "Allows SSH"
        description = "Allows outbound SSH traffic on port 22 to ec2 instance security group."
        from        = 22
        to          = 22
        protocol    = "tcp"
        cidr-blocks = "0.0.0.0/0"
      }
    }
    egress = {
    }
  }
}

# This variable defines the ID of the security group to reference.
# 
# Type: string
# Default: ""
# 
# Usage:
# This variable should be set to the ID of an existing security group that you want to reference in your Terraform configuration.
# variable "referenced-sg-id" {
#   description = "The ID of the security group to reference."
#   type        = string
#   default     = ""
# }

######################################## GitHub ####################################################
# The CI build string
# This variable defines the CI build string.
# It is a string type variable with a default value of an empty string.
variable "ci-build" {
  description = "The CI build string"
  type        = string
  default     = ""
}