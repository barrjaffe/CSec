output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}

output "application_insights_connection_string" {
  value     = azurerm_application_insights.main.connection_string
  sensitive = true
}

output "storage_account_name" {
  value = azurerm_storage_account.evidence.name
}

output "postgresql_fqdn" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}
