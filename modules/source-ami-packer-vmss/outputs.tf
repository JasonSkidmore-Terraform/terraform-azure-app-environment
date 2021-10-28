output "ids" {
  value = {
    id           = azurerm_linux_virtual_machine_scale_set.vmss.id
    unique_id    = azurerm_linux_virtual_machine_scale_set.vmss.unique_id
    principal_id = azurerm_linux_virtual_machine_scale_set.vmss.identity[0].principal_id
  }
}

output "domain_name_label" {
  value = "${data.azurerm_public_ip.vmss.domain_name_label}.eastus.cloudapp.azure.com"
}

output "public_ip_address" {
  value = data.azurerm_public_ip.vmss.ip_address
}