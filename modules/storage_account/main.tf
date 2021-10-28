resource "random_pet" "sa-name" {
  length    = 3
  separator = ""
}

resource "azurerm_storage_account" "storage_account" {
  resource_group_name      = var.resource_group_name
  location                 = var.location
  name                     = lower(substr(format("%s0%s", var.project, random_pet.sa-name.id), 0, 24))
  account_tier             = var.storage_account.tier
  account_replication_type = var.storage_account.type

  # VNet integration
  network_rules {
    default_action             = "Allow"
    virtual_network_subnet_ids = [var.subnet_id]
    # (Optional) allows access to the PaaS from outside the Vnet
    ip_rules = var.public_ip_allowlist
  }

  tags = var.tags
}

resource "azurerm_storage_container" "storage_account" {
  storage_account_name  = azurerm_storage_account.storage_account.name
  name                  = "caas-api-state"
  container_access_type = "private"
}
