# ---------------------
# Outputs
# ---------------------
output "container_registry_name" {
  value = azurerm_container_registry.acr.name
}

output "domain_name_servers" {
  value = azurerm_dns_zone.DNS.name_servers
}

output "domain_zone_id" {
  value = azurerm_dns_zone.DNS.id
}

output "domain_zone_name" {
  value = azurerm_dns_zone.DNS.name
}

output "subdomain_zone_name" {
  value = azurerm_dns_zone.subdomain.name
}

output "key_vault_name" {
  value = azurerm_key_vault.vault.name
}

output "postgres_data" {
  value = {
    postgres_host   = module.postgres-DB.postgres_config.netloc
    postgres_pass   = module.postgres-DB.postgres_config.password
    postgres_user   = module.postgres-DB.postgres_config.user
    postgres_bdname = module.postgres-DB.postgres_config.dbname
    postgres_port   = 5432
  }
}

output "vnet_data" {
  description = "netowrking configuration"
  value = {
    vnet_id    = module.landing_zone.networking.vnet_id
    vnet_name  = module.landing_zone.networking.vnet_name
    subnet_ids = module.landing_zone.networking.subnet_ids
    pip        = module.landing_zone.networking.pip
  }
}

output "subnet_id" {
  value = module.landing_zone.subnet_id
}

output "sg_data" {
  description = "netowrking configuration"
  value = {
    ssh_id    = module.landing_zone.sg_rules.ssh_id
    nsg_id    = module.landing_zone.sg_rules.nsg_id
    vault_id  = module.landing_zone.sg_rules.vault_id
    consul_id = module.landing_zone.sg_rules.consul_id
  }
}

output "public_ip_allowlist" {
  value = var.public_ip_allowlist
}

output "login_server" {
  value = data.azurerm_container_registry.acr.login_server
}

# Vault
output "vault-network" {
  value = {
    # DNS       = "http://${module.load-balancer-vault.load_balancer_domain_label}:8200"
    DNS = "http://${azurerm_dns_a_record.DNS.fqdn}:8200"
  }
}

output "vault_dns" {
  value = azurerm_dns_a_record.DNS.fqdn
}

# Consul
output "consul-network" {
  value = {
    # DNS       = "http://${module.load-balancer-vault.load_balancer_domain_label}:8500"
    DNS = "http://${azurerm_dns_a_record.DNS.fqdn}:8500"
  }
}

output "consul_dns" {
  value = azurerm_dns_a_record.DNS.fqdn
}


output "NS_for_domain" {
  value = azurerm_dns_zone.subdomain.name
}

#AKS
output "cluster_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "host" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.host
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
}

output "cluster_ca_certificate" {
  value = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)}"
}


output "client_key" {
  value = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)}"
}

output "client_certificate" {
  value = "${base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)}"
}


output "cluster_username" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.username
}

output "cluster_password" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.password
}

output "ssh_public_key" {
  value     = module.ssh_keys.ssh_public_key
  sensitive = true
}

output "ssh_private_key" {
  value     = module.ssh_keys.ssh_private_key
  sensitive = true
}