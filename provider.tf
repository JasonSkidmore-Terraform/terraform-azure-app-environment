# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version         = ">=2.20.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  #partner_id      = var.partner_id

  features {}
}

provider "acme" {

  #server_url = "https://acme-v02.api.letsencrypt.org/directory" # this is for production and has rate limits
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}
