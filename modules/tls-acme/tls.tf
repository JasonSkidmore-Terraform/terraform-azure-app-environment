resource "tls_private_key" "acme" {
  algorithm = "RSA"
}

resource "acme_registration" "tls" {
  account_key_pem = tls_private_key.acme.private_key_pem
  email_address   = format("%s@azuredns-hostmaster.microsoft.com", var.domain) #format("%s@domainsbyproxy.com", var.domain) # 1) azuredns-hostmaster.microsoft.com
}

resource "acme_certificate" "tls" {
  account_key_pem = acme_registration.tls.account_key_pem
  common_name     = var.hostname

  dns_challenge {
    provider = "azure"

    config = {
      AZURE_CLIENT_ID       = var.client_id
      AZURE_CLIENT_SECRET   = var.client_secret
      AZURE_RESOURCE_GROUP  = var.resource_group_name
      AZURE_SUBSCRIPTION_ID = var.subscription_id
      AZURE_TENANT_ID       = var.tenant_id
    }
  }
}
