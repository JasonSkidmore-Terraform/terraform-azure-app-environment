#-----------------
# Create DNS Zone
#-----------------
# (comment if you already have a DNS Zone and just create the records instead)
resource "azurerm_dns_zone" "DNS" {
  name                = var.domain
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_dns_zone" "subdomain" {
  name                = local.hostname
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# resource "azurerm_private_dns_zone" "example-private" {
#   name                = var.domain
#   resource_group_name = var.resource_group_name
# }

resource "azurerm_dns_ns_record" "DNS" {
  name                = var.subdomain
  zone_name           = azurerm_dns_zone.DNS.name
  resource_group_name = var.resource_group_name
  ttl                 = 300

  records = azurerm_dns_zone.subdomain.name_servers

  tags = var.tags
}


#---------------
# Load Balancer
#---------------
resource "azurerm_dns_a_record" "DNS" {
  name      = "lb"
  zone_name = azurerm_dns_zone.subdomain.name # Uncomment if DNS zone managed by terraform
  #zone_name           = var.domain # Use this if DNS zone not managed by terraform
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [module.load-balancer-vault.public_ip]

  depends_on = [
    module.load-balancer-vault
  ]

  tags = var.tags
}



# #---------------
# # Postgres DB
# #---------------
# resource "azurerm_dns_a_record" "DNS" {
#   name                = "DB" # var.subdomain
#   zone_name           = azurerm_dns_zone.DNS.name # Uncomment if DNS zone managed by terraform
#   # zone_name           = var.domain                # Use this if DNS zone not managed by terraform
#   resource_group_name = var.resource_group_name
#   ttl                 = 300
#   records             = [module.load-balancer-vault.public_ip]

#   depends_on = [
#     module.load-balancer-vault
#   ]
# }
