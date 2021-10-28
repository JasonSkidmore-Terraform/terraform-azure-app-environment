variable "enable_bastion_host" {
  # when value=false does not create Bastion
  default = true
}

resource "random_pet" "bastion" {
  # (if) ? then : else
  count  = var.enable_bastion_host ? 1 : 0
  length = 2
}

resource "azurerm_public_ip" "bastion" {
  count = var.enable_bastion_host ? 1 : 0

  resource_group_name = var.resource_group_name
  location            = var.location
  name                = format("%s-bastion-pip", var.project)
  allocation_method   = "Dynamic"
  domain_name_label   = random_pet.bastion.0.id
  tags                = var.tags
}

resource "azurerm_network_interface" "bastion" {
  count = var.enable_bastion_host ? 1 : 0

  resource_group_name = var.resource_group_name
  location            = var.location
  name                = format("%s-bastion-nic", var.project)

  ip_configuration {
    name = "ipconfig"
    # just drop in first subnet - hacky
    subnet_id                     = azurerm_subnet.subnet[0].id
    public_ip_address_id          = azurerm_public_ip.bastion.0.id
    private_ip_address_allocation = "dynamic"
  }
  tags = var.tags
}


resource "azurerm_linux_virtual_machine" "bastion" {
  count = var.enable_bastion_host ? 1 : 0

  resource_group_name   = var.resource_group_name
  location              = var.location
  name                  = format("%s-bastion-vm", var.project)
  network_interface_ids = [azurerm_network_interface.bastion.0.id]
  size                  = "Standard_D1_v2"
  admin_username        = var.bastion.username

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = var.bastion.username
    public_key = var.bastion.public_key
  }

  tags = var.tags
}