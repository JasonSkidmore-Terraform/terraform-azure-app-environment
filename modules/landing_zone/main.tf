# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = format("%s-vnet", var.project)
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Create a Subnet for the Virtual Network
resource "azurerm_subnet" "subnet" {
  name                 = format("%s-subnet-${count.index}", var.project)
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  count                = length(var.subnet_address_spaces)
  address_prefixes     = [var.subnet_address_spaces[count.index].address_space]

  service_endpoints = [
    "Microsoft.Sql",
    "Microsoft.Storage",
    "Microsoft.KeyVault"
  ]
}

# Create Security Group
resource "azurerm_network_security_group" "sg_vnet" {
  name                = format("%s-nsg", var.project)
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Associate SG with the Subnet
resource "azurerm_subnet_network_security_group_association" "sg_association" {
  count     = length(var.subnet_address_spaces)
  subnet_id = azurerm_subnet.subnet[count.index].id
  #subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.sg_vnet.id
}
