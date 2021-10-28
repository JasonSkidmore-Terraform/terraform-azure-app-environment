# ----------------
# Azure Key Vault
# ----------------
variable "tenant_id" {
  default = ""
}

variable "key_name" {
  description = "Azure Key Vault key name"
  default     = "generated-key"
}

variable "location" {
  description = "Azure location where the Key Vault resource to be created"
  default     = "eastus"
}

variable "environment" {
  default = "learn"
}

# ----------------
# Virtual Machine
# ----------------

variable "subscription_id" {
  default = ""
}

variable "client_id" {
  default = ""
}

variable "client_secret" {
  default = ""
}

variable "vm_sku" {
  description = "Number of instances that you want for vmss"
  default     = "Standard_F2"
}

variable "domain" {
  description = "The domain you wish to use, this will be subdomained. `example.com`"
}

variable "subdomain" {
  description = "The subdomain you wish to use `mycompany-tfe`"
}

variable "certificate_path" {
  description = "The path on disk that has the PFX certificate."
  default     = "files/certificate.pfx"
}

variable "certificate_password" {
  description = "The PFX certificate password."
  default     = ""
}

variable "vault_vm_name" {
  default = "azure-vault-demo-vm"
}

variable "consul_vm_name" {
  default = "azure-consul-demo-vm"
}

variable "vault_download_url" {
  default = "https://releases.hashicorp.com/vault/1.5.3+ent/vault_1.5.3+ent_linux_amd64.zip"
}

variable "resource_group_name" {
  default = "vault-demo-azure-auth"
}

variable "project" {
  description = "Name to assign to resources for easy organization."
}

variable "tags" {
  description = "Tags to apply to the resource group/resources."
  type        = map
  default     = {}
}


# ----------------
# Network Vars
# ----------------
variable "vnet_address_space" {
  description = "The virtual network address CIDR."
  default     = "10.0.0.0/16"
}

variable "public_ip_allowlist" {
  description = "List of public IP addresses to allow into the network. This is required for access to the PaaS services (AKV, SA, Postgres) and the bastion."
  type        = list
  default = [
    "187.188.23.173"
  ]
}

variable "vm_admin_username" {
  description = "The username to login to the TFE Virtual Machines."
  default     = "azureuser"
}

variable "distribution" {
  description = "The images tested for the TFE submodule. (ubuntu or rhel)."
  #default     = "rhel"
  default = "ubuntu"
}

locals {
  hostname = join(".", [var.subdomain, var.domain])
  # These are the TFE images that have been tested. Select these with the var.distributon variable.
  ubuntu = {
    ubuntu = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    },
    rhel = {
      publisher = "RedHat"
      offer     = "RHEL"
      sku       = "7-RAW-CI"
      version   = "latest"
    }
  }
}

# ----------------
# Consul Tokens
# ----------------
# To generate the tokens:
# https://www.consul.io/docs/commands/keygen
# If you have problems with these tokens try to get tokens without arithmetic expressions or '/'

variable "consul_tokens" {
  description = "The required tokens for consul"
  type = object({
    encrypt_key       = string
    acl_master_token  = string
    acl_agent_token   = string
    acl_default_token = string
  })
}

variable "vault_service_image_name" {
  description = "The name of the image that will be used when building the Vault instance(s)."
  type        = string
}

variable "consul_service_image_name" {
  description = "The name of the image that will be used when building the Consul instance(s)."
  type        = string
}