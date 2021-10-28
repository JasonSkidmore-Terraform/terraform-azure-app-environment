# Create a SG Rule for the SSH connection 
resource "azurerm_network_security_rule" "rule-SSH" {
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.sg_vnet.name
  count                       = length(var.public_ip_allowlist)
  name                        = "nsg-ssh-${count.index}"
  description                 = "SSH open for debugging from: ${var.public_ip_allowlist[count.index]}"
  priority                    = 100 + count.index
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.public_ip_allowlist[count.index]
  destination_address_prefix  = "*"
}

# Needed for Application Gateway rule on vnet
resource "azurerm_network_security_rule" "rule-nsg" {
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.sg_vnet.name
  name                        = "nsg-rule-001"
  description                 = "Port range required for Azure infrastructure communication."
  priority                    = 500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "65200-65535"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# Needed for Vault
resource "azurerm_network_security_rule" "rule-vault" {
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.sg_vnet.name
  name                        = "nsg-rule-vault"
  description                 = "Port range required for Azure infrastructure communication."
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8200"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

# Needed for Consul
resource "azurerm_network_security_rule" "rule-consul" {
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.sg_vnet.name
  name                        = "nsg-rule-consul"
  description                 = "Port range required for Azure infrastructure communication."
  priority                    = 1003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8500"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}