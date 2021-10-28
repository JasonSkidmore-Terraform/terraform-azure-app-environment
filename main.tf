#----------------------------------
# Imported existing resource group
#----------------------------------
# resource "azurerm_resource_group" "RG" {
#   name     = "prima-test"
#   location = "eastus"
# }

#-------------------
# Networking for RG
#-------------------
module "landing_zone" {
  source = "./modules/landing_zone"

  resource_group_name = var.resource_group_name
  location            = var.location

  project = var.project

  vnet_address_space = var.vnet_address_space

  public_ip_allowlist = var.public_ip_allowlist

  subnet_address_spaces = [
    {
      name          = var.project
      address_space = cidrsubnet(var.vnet_address_space, 8, 0) # Bastion
    }
    ,
    {
      address_space = cidrsubnet(var.vnet_address_space, 8, 1) #  postgresDB, StorageAccount and Keyvault
    }
    ,
    {
      address_space = cidrsubnet(var.vnet_address_space, 8, 2) # Vault VM
    }
    ,
    {
      address_space = cidrsubnet(var.vnet_address_space, 8, 3) # Consul VM
    }
  ]

  bastion = {
    username   = var.vm_admin_username
    public_key = module.ssh_keys.ssh_public_key
  }

  tags = var.tags
}

#-------------
# SSH Keys
#-------------
module "ssh_keys" {
  source = "./modules/ssh"

  # path_to_pem = "<Pathtofile>" # example: "./tfe_rsa.pem"
  # path_to_pub = "<Pathtofile>" # example: "./tfe_rsa.pub"
}

# ---------------------
# Vault tpl file
# ---------------------
data "template_file" "setup_vault" {
  template = file("${path.module}/config_templates/vault.sh.tpl")

  vars = {
    tenant_id           = var.tenant_id
    vault_name          = azurerm_key_vault.vault.name
    key_name            = azurerm_key_vault_key.generated.name
    cluster_name        = "vault"
    raft_multiplier     = "1"
    resource_group_name = var.resource_group_name
    consul_vmss         = format("%s-vmss-%s", var.project, var.consul_vm_name)
    encrypt_key         = var.consul_tokens.encrypt_key
    acl_agent_token     = var.consul_tokens.acl_agent_token
    acl_default_token   = var.consul_tokens.acl_default_token
    vault_consul_token  = var.consul_tokens.acl_master_token
    consul_address      = "http://${module.load-balancer-vault.load_balancer_domain_label}:8500"
    vault_address       = "http://${module.load-balancer-vault.load_balancer_domain_label}:8200"
  }
}

# Render a multi-part cloud-init config making use of the part
# above, and other source files
data "template_cloudinit_config" "config_vault" {
  gzip          = false
  base64_encode = false

  # Main cloud-config configuration file.
  part {
    filename     = "vault.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.setup_vault.rendered
  }
}

#--------------
# VMSS Vault
#--------------
module "vmss-vault" {
  source = "./modules/source-ami-packer-vmss"

  resource_group_name = var.resource_group_name
  location            = var.location
  service_name        = var.vault_vm_name
  service_image       = var.vault_service_image_name # "VaultImageWorkable"
  project             = var.project
  vm_sku              = var.vm_sku
  instances_count     = 1
  subnet_id           = module.landing_zone.networking.subnet_ids[2]

  startup_script = data.template_cloudinit_config.config_vault.rendered
  os_image       = local.ubuntu[var.distribution]

  keyvault = {
    enabled = true
    id      = azurerm_key_vault.vault.id
  }
  storage_account_uri = module.storage-account.object_storage_config.blob

  vm_user = {
    username   = var.vm_admin_username
    public_key = module.ssh_keys.ssh_public_key
  }

  lb = {
    type                    = "ALB"
    backend_address_pool_id = module.load-balancer-vault.backend_address_pool_id
    health_probe_id         = module.load-balancer-vault.health_probe_id
  }

  depends_on = [
    module.vmss-consul
  ]

  tags = var.tags
}


# ---------------------
# Consul tpl file
# ---------------------
data "template_file" "setup_consul" {
  template = file("${path.module}/config_templates/consul.sh.tpl")

  vars = {
    tenant_id               = var.tenant_id
    cluster_name            = "consul"
    consul_bootstrap_expect = "1"
    resource_group_name     = var.resource_group_name
    consul_vmss             = format("%s-vmss-%s", var.project, var.consul_vm_name)
    encrypt_key             = var.consul_tokens.encrypt_key
    acl_agent_token         = var.consul_tokens.acl_agent_token
    acl_default_token       = var.consul_tokens.acl_default_token
    acl_master_token        = var.consul_tokens.acl_master_token
  }
}

# Render a multi-part cloud-init config making use of the part
# above, and other source files
data "template_cloudinit_config" "config_consul" {
  gzip          = false
  base64_encode = false

  # Main cloud-config configuration file.
  part {
    filename     = "consul.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.setup_consul.rendered
  }
}

#--------------
# VMSS Consul
#--------------
module "vmss-consul" {
  source = "./modules/source-ami-packer-vmss"

  resource_group_name = var.resource_group_name
  location            = var.location
  service_name        = var.consul_vm_name
  service_image       = var.consul_service_image_name
  project             = var.project
  vm_sku              = var.vm_sku
  instances_count     = 1
  subnet_id           = module.landing_zone.networking.subnet_ids[3]

  startup_script = data.template_cloudinit_config.config_consul.rendered
  os_image       = local.ubuntu[var.distribution]

  keyvault = {
    enabled = true
    id      = azurerm_key_vault.vault.id
  }

  storage_account_uri = module.storage-account.object_storage_config.blob

  vm_user = {
    username   = var.vm_admin_username
    public_key = module.ssh_keys.ssh_public_key
  }

  lb = {
    type                    = "ALB"
    backend_address_pool_id = module.load-balancer-vault.backend_address_pool_id
    health_probe_id         = module.load-balancer-vault.health_probe_id
  }

  tags = var.tags
}

#---------------
# Load Balancer Vault
#---------------
module "load-balancer-vault" {
  source = "./modules/public-load-balancer"

  resource_group_name = var.resource_group_name
  location            = var.location
  project             = var.project

  tags = var.tags
}