#--------
# Common
#--------
variable "resource_group_name" {
  description = "Name of the Resource Group to place resources in."
}

variable "location" {
  description = "The Azure region to deploy all infrastructure to."
}

variable "project" {
  description = "Name to assign to resources for easy organization."
}

variable "tags" {
  description = "Tags to apply to the resource group/resources."
  type        = map
  default     = {}
}

#---------
# Network
#---------
variable "vnet_address_space" {
  description = "List of public IPs that need direct access to the PaaS in the Vnet."
}

variable "public_ip_allowlist" {
  description = "List of public IPs that need direct access to the PaaS in the Vnet."
  type        = list(string)
  default     = []
}

variable "subnet_address_spaces" {
  description = "A list of subnet address spaces and names."
  type = list(object({
    address_space = string
  }))
}

#---------
# Bastion
#---------
variable "bastion" {
  description = "Bastion public ssh username and key."
  type = object({
    username   = string
    public_key = string
  })
  default = {
    username   = ""
    public_key = ""
  }
}