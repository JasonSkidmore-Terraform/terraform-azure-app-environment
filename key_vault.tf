# ---------------------
# Key Vault
# ---------------------
resource "random_id" "keyvault" {
  byte_length = 4
}

data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "vault" {
  name                        = join("-vault-", [var.project, random_id.keyvault.hex])
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_deployment      = true
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id # var.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id # var.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "get",
      "list",
      "create",
      "delete",
      "update",
      "wrapKey",
      "unwrapKey",
      "purge"
    ]
  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
    # adding IP rules here will allow us to write to the AKV from local Terraform
    # ip_rules                   = formatlist("%s/32", var.public_ip_allowlist)
    # virtual_network_subnet_ids = [var.subnet_id]
  }

  tags = var.tags
}

# Grant access to the calling user to manage things inside the Key Vault
# resource "azurerm_key_vault_access_policy" "access" {
#   key_vault_id = azurerm_key_vault.vault.id
#
#   tenant_id = data.azurerm_client_config.current.tenant_id
#   object_id = data.azurerm_client_config.current.object_id
#
#   key_permissions = [
#     "get",
#     "List",
#     "Update",
#     "Restore",
#     "Backup",
#     "Recover",
#     "Delete",
#     "Import",
#     "Create",
#     "wrapKey",
#     "unwrapKey",
#   ]
# }

resource "azurerm_key_vault_key" "generated" {
  name         = format("%s-keyvaultkey-%s", var.project, var.key_name)
  key_vault_id = azurerm_key_vault.vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  depends_on = [
    azurerm_key_vault.vault,
  ]
}
