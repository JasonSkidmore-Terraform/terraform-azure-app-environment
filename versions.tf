terraform {
  required_providers {
    acme = {
      source = "terraform-providers/acme"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = "~> 0.13"
}
