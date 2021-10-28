output "object_storage_config" {
  description = "Object storage configuration."
  value = {
    account_name = azurerm_storage_account.storage_account.name
    account_key  = azurerm_storage_account.storage_account.primary_access_key
    container    = azurerm_storage_container.storage_account.name
    blob         = azurerm_storage_account.storage_account.primary_blob_endpoint
  }
}