# ---------------------
# Storage Account
# ---------------------
module "storage-account" {
  source = "./modules/storage_account"

  resource_group_name = var.resource_group_name
  location            = var.location
  project             = var.project
  subnet_id           = module.landing_zone.networking.subnet_ids[1]
  public_ip_allowlist = var.public_ip_allowlist

  storage_account = {
    tier = "Standard" # Valid "tier" [Standard, Premium]
    type = "LRS"      # Valid "type" [LRS, GRS, RAGRS and ZRS]
  }

  tags = var.tags
}
