# CLP Knowledge Base - Terraform Outputs

# =============================================================================
# RESOURCE GROUP
# =============================================================================

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}

# =============================================================================
# NETWORKING
# =============================================================================

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

# =============================================================================
# KEY VAULT
# =============================================================================

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

# =============================================================================
# STORAGE
# =============================================================================

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_primary_endpoint" {
  description = "Primary blob endpoint"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

# =============================================================================
# AZURE OPENAI
# =============================================================================

output "openai_endpoint" {
  description = "Endpoint for Azure OpenAI Service"
  value       = azurerm_cognitive_account.openai.endpoint
}

output "openai_id" {
  description = "ID of Azure OpenAI Service"
  value       = azurerm_cognitive_account.openai.id
}

# =============================================================================
# AZURE AI SEARCH
# =============================================================================

output "search_endpoint" {
  description = "Endpoint for Azure AI Search"
  value       = "https://${azurerm_search_service.main.name}.search.windows.net"
}

output "search_name" {
  description = "Name of Azure AI Search service"
  value       = azurerm_search_service.main.name
}

# =============================================================================
# COSMOS DB
# =============================================================================

output "cosmos_endpoint" {
  description = "Endpoint for Cosmos DB"
  value       = azurerm_cosmosdb_account.main.endpoint
}

output "cosmos_database_name" {
  description = "Name of the Cosmos DB database"
  value       = azurerm_cosmosdb_sql_database.main.name
}

# =============================================================================
# SPEECH SERVICES
# =============================================================================

output "speech_endpoint" {
  description = "Endpoint for Speech Services"
  value       = azurerm_cognitive_account.speech.endpoint
}

# =============================================================================
# APP SERVICE
# =============================================================================

output "api_app_url" {
  description = "URL of the API App Service"
  value       = "https://${azurerm_linux_web_app.api.default_hostname}"
}

output "console_app_url" {
  description = "URL of the Management Console App Service"
  value       = "https://${azurerm_linux_web_app.console.default_hostname}"
}

# =============================================================================
# AZURE FUNCTIONS
# =============================================================================

output "function_app_url" {
  description = "URL of the Ingestion Function App"
  value       = "https://${azurerm_linux_function_app.ingestion.default_hostname}"
}

# =============================================================================
# MONITORING
# =============================================================================

output "log_analytics_workspace_id" {
  description = "ID of Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "application_insights_connection_string" {
  description = "Connection string for Application Insights"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}