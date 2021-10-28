locals {
  msi_foreach = toset(var.keyvault.enabled ? ["msi"] : [])
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_role_definition" "vmss_reader" {
  name        = format("vmss-reader-%s", azurerm_linux_virtual_machine_scale_set.vmss.name)
  scope       = data.azurerm_resource_group.rg.id
  description = "Custom role to retrieve NIC VMSS properties"

  permissions {
    actions = ["Microsoft.Compute/virtualMachineScaleSets/networkInterfaces/read"]
  }

  assignable_scopes = [
    data.azurerm_resource_group.rg.id
  ]
}

resource "azurerm_role_assignment" "msi_vmss_reader" {
  for_each             = local.msi_foreach
  principal_id         = azurerm_linux_virtual_machine_scale_set.vmss.identity[0].principal_id
  role_definition_name = azurerm_role_definition.vmss_reader.name
  scope                = data.azurerm_resource_group.rg.id
}

# Add keyvault policy so that the MSI can create secrets and keys for autounsealing vault
resource "azurerm_key_vault_access_policy" "msi" {
  for_each     = local.msi_foreach
  key_vault_id = var.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_virtual_machine_scale_set.vmss.identity[0].principal_id

  secret_permissions = ["set"]

  key_permissions = [
    "create",
    "get",
    "list",
    "wrapKey",
    "UnwrapKey"
  ]
}
