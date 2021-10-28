locals {
  lb_frontend_config_name = "PublicIPAddress"
  lb_backend_config_name  = "BackEndAddressPool-${random_pet.pip.id}"
}

resource "random_pet" "endpoint" {
  length = 2
}

resource "random_pet" "pip" {
  length = 1
}

resource "azurerm_public_ip" "lb" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = format("%s-lb-pubip-%s", var.project, random_pet.pip.id)
  sku                 = var.lb_sku #[Basic, Standard]
  allocation_method   = "Static"
  domain_name_label   = random_pet.endpoint.id
  tags                = var.tags
}

resource "azurerm_lb" "lb" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = format("%s-lb-%s", var.project, random_pet.pip.id)
  sku                 = var.lb_sku #[Basic, Standard]

  frontend_ip_configuration {
    name                 = local.lb_frontend_config_name
    public_ip_address_id = azurerm_public_ip.lb.id
  }
  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "lb" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = local.lb_backend_config_name
}

resource "azurerm_lb_probe" "vault" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "vault-health-probe"
  protocol            = "Http"
  request_path        = "/ui/health"
  port                = 8200
}

resource "azurerm_lb_probe" "consul" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "consul-health-probe"
  protocol            = "Http"
  request_path        = "/ui/health"
  port                = 8500
}

resource "azurerm_lb_rule" "lb-vault" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb.id
  probe_id                       = azurerm_lb_probe.vault.id
  name                           = "VaultRule"
  protocol                       = "Tcp"
  frontend_port                  = 8200
  backend_port                   = 8200
  frontend_ip_configuration_name = local.lb_frontend_config_name
}

resource "azurerm_lb_rule" "lb-consul" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb.id
  probe_id                       = azurerm_lb_probe.consul.id
  name                           = "AppRule"
  protocol                       = "Tcp"
  frontend_port                  = 8500
  backend_port                   = 8500
  frontend_ip_configuration_name = local.lb_frontend_config_name
}
