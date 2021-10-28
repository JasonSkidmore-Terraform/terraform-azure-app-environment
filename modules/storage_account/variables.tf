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
  description = "The tags to apply to all resources."
  type        = map
  default     = {}
}

#-----------------
# Storage Account
#-----------------
# Valid "tier" [Standard, Premium]
# Valid "type" [LRS, GRS, RAGRS and ZRS]
# Non-Prod, you can get away with Standard-ZRS
# Prod, should be at least Standard-ZRS or Standard-GRS
variable "storage_account" {
  description = "Storage Account Azure settings."
  type = object({
    tier = string
    type = string
  })
  default = {
    tier = "Standard"
    type = "LRS"
  }
}

#---------
# Network
#---------
variable "subnet_id" {
  description = "The subnet id to place the External Services in."
}

variable "public_ip_allowlist" {
  description = "List of public IPs that need direct access to the PaaS in the Vnet (Optional)."
  type        = list(string)
  default     = []
}