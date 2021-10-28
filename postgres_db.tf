# ---------------------
# Postgres DB
# ---------------------
module "postgres-DB" {
  source = "./modules/postgresql"

  resource_group_name = var.resource_group_name
  location            = var.location
  project             = var.project
  subnet_id           = module.landing_zone.networking.subnet_ids[1]
  public_ip_allowlist = ["0.0.0.0"] # concat(var.public_ip_allowlist, module.landing_zone.networking.pip)

  tags = var.tags
}
