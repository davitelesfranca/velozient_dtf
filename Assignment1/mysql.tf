resource "azurerm_mssql_server" "sql_server" {
  name                         = "aztfmsqylservertest"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "sql_database" {
  name      = "appdb"
  server_id = azurerm_mssql_server.sql_server.id
  sku_name  = "Basic"
}