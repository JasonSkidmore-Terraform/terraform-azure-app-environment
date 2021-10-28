#-----------------
# ACR
#-----------------
resource "azurerm_container_registry" "acr" {
  name                = format("acr%s", replace(var.project, "-", "")) # "AcrLH" # alpha numeric characters only are allowed in "name"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard" # Possible values are Basic, Standard and Premium.
  admin_enabled       = false
  # georeplication_locations = ["West US", "West Europe"] # only be applied when using the Premium Sku.

  tags = var.tags
}

data "azurerm_container_registry" "acr" {
  name                = azurerm_container_registry.acr.name
  resource_group_name = var.resource_group_name

  depends_on = [
    azurerm_container_registry.acr,
  ]
}

#-----------------
# AKS
#-----------------
data "azurerm_client_config" "aks" {}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = format("%s-example-aks1", var.project)
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  service_principal {
    client_id     = data.azurerm_client_config.aks.client_id
    client_secret = var.client_secret
  }

  # identity {
  #   type = "SystemAssigned"
  # }

  role_based_access_control {
    enabled = true
  }

  tags = var.tags
}

resource "azurerm_role_assignment" "acrpull_role" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = data.azurerm_client_config.aks.object_id #data.azuread_service_principal.aks_principal.id
  # skip_service_principal_aad_check = true
}

# output "client_certificate" {
#   value = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
# }

# output "kube_config" {
#   value = azurerm_kubernetes_cluster.example.kube_config_raw
# }
