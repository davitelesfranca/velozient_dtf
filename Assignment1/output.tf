output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "load_balancer_ip" {
  value = azurerm_public_ip.lb_public_ip.ip_address
}

output "sql_server_name" {
  value = azurerm_mssql_server.sql_server.name
}

output "sql_database_name" {
  value = azurerm_mssql_database.sql_database.name
}
