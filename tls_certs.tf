#-------------
# TLS Certs
#-------------
/*
module "tls" {
  source = "./modules/tls-acme" # Let's Encrypt
  # source               = "../azure-landing-zone/landing-zone/modules/tls-private" # Self-Signed
  domain               = var.domain
  hostname             = local.hostname
  certificate_path     = var.certificate_path
  certificate_password = var.certificate_password
  resource_group_name  = var.resource_group_name
  client_id            = var.client_id
  client_secret        = var.client_secret
  subscription_id      = var.subscription_id
  tenant_id            = var.tenant_id

  depends_on = [
    azurerm_dns_zone.DNS,
    azurerm_dns_zone.subdomain
  ]
}
*/