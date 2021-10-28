variable "domain" {
  description = "The domain you wish to use, this will be subdomained. `example.com`"
}

variable "hostname" {
  description = "The full hostname that will be used. `tfe.example.com`."
}

variable "certificate_path" {
  description = "The path on disk that has the PFX certificate."
}

variable "certificate_password" {
  description = "The PFX certificate password."
}

variable "resource_group_name" {
  description = "Name of the Resource Group to place resources in."
}

variable "tenant_id" {
  default = ""
}

variable "subscription_id" {
  default = ""
}

variable "client_id" {
  default = ""
}

variable "client_secret" {
  default = ""
}
