output "postgres_config" {
  description = "Database storage configuration."
  value = {
    dbname       = azurerm_postgresql_database.postgres.name
    netloc       = "${azurerm_postgresql_server.postgres.fqdn}:5432"
    user         = "${azurerm_postgresql_server.postgres.administrator_login}@${azurerm_postgresql_server.postgres.name}"
    password     = azurerm_postgresql_server.postgres.administrator_login_password
    extra_params = "sslmode=require"
  }
}
