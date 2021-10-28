resource "random_string" "postgres-password" {
  length  = 24
  special = true
}

resource "random_pet" "postgres-name" {
  length    = 3
  separator = ""
}

resource "azurerm_postgresql_server" "postgres" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = lower(format("%s-postgresql-%s", var.project, random_pet.postgres-name.id))

  sku_name = var.postgres_sku_name

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  administrator_login          = var.postgres_user
  administrator_login_password = "#FRXtR0RR-Kd}Z]f#EN<G6<z" # random_string.postgres-password.result
  version                      = "11"
  # SSL mode
  ssl_enforcement_enabled = true

  tags = var.tags
}

resource "azurerm_postgresql_database" "postgres" {
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgres.name
  name                = "caas_api_db"
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_virtual_network_rule" "postgres" {
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgres.name
  subnet_id           = var.subnet_id
  name                = format("%s-pgsql-vnet-rule", var.project)
  # ignore_missing_vnet_service_endpoint = true
}

# (Optional) allows access to the PaaS from outside the Vnet
resource "azurerm_postgresql_firewall_rule" "postgres" {
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgres.name
  count               = length(var.public_ip_allowlist)
  name                = format("%s-pgsql-public-%s", var.project, count.index)
  start_ip_address    = var.public_ip_allowlist[count.index]
  end_ip_address      = var.public_ip_allowlist[count.index]
  # name                = "postgresql-public-0"
  # start_ip_address    = "0.0.0.0"
  # end_ip_address      = "255.255.255.255"
}
