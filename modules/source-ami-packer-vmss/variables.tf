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

variable "service_name" {
  description = "Service name to describe resources of the service."
}

variable "tags" {
  description = "The tags to apply to all resources."
  type        = map
  default     = {}
}

#-------
# VMSS
#-------
variable "service_image" {
  description = "Name of the Service Image to find. This was build in Packer"
}

variable "vm_sku" {
  description = "The VM instance SKU to use."
  default     = "Standard_D2s_v3"
}

variable "instances_count" {
  description = "Number of instances that you want for vmss"
  default     = 1
}

variable "vm_user" {
  description = "VM username and public ssh key."
  type = object({
    username   = string
    public_key = string
  })
}

variable "os_image" {
  description = "Marketplace image for VMSS."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

variable "startup_script" {
  description = "Startup script to install and configure Services."
  default     = ""
}

variable "zones" {
  description = "The Availability Zones to use for the VMSS. These values can not be looked up via any Azure API and vary per region  (Example: [\"1\",\"2\",\"3\"])."
  default     = []
}

variable "subnet_id" {
  description = "The subnet id to place the External Services in."
}


variable "storage_account_uri" {
  description = "Blob storage for the vm instance"
}

#---------------
# Load Balancer
#---------------
variable "lb" {
  description = "Load balancer to attach to the VMSS. Type must be one of the following ['ALB', 'AAG']."
  type = object({
    type                    = string
    backend_address_pool_id = string
    health_probe_id         = string
  })
  default = {
    type                    = ""
    backend_address_pool_id = ""
    health_probe_id         = ""
  }
}

#-----------
# Key Vault
#-----------
variable "keyvault" {
  description = "(Optional) The Azure KeyVault info to use for secrets."
  type = object({
    enabled = bool
    id      = string
  })
  default = {
    enabled = false
    id      = ""
  }
}