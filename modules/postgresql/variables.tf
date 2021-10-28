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

#------------
# Postgresql
#------------
variable "postgres_user" {
  description = "Postgres user name."
  default     = "psqladmin"
}

variable "postgres_sku_name" {
  description = "SKU Short name: tier + family + cores"
  type        = string
  default     = "GP_Gen5_2"
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