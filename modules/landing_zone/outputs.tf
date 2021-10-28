output "networking" {
  description = "Networking configuration."
  value = {
    vnet_id   = azurerm_virtual_network.vnet.id
    vnet_name = azurerm_virtual_network.vnet.name
    # strip out the suffix to match name passed into the module.
    subnet_ids = azurerm_subnet.subnet.*.id
    pip        = azurerm_public_ip.bastion.*.name
  }
}

output "subnet_id" {
  value = azurerm_subnet.subnet.*.id
}

output "vm" {
  description = "Virtual Machine settings"
  value = {
    name                = azurerm_linux_virtual_machine.bastion.*.name
    resource_group_name = azurerm_linux_virtual_machine.bastion.*.resource_group_name
    admin_user          = azurerm_linux_virtual_machine.bastion.*.admin_username
  }
}

output "sg_rules" {
  value = {
    ssh_id    = azurerm_network_security_rule.rule-SSH.*.id
    nsg_id    = azurerm_network_security_rule.rule-nsg.id
    vault_id  = azurerm_network_security_rule.rule-vault.id
    consul_id = azurerm_network_security_rule.rule-consul.id
  }
}
