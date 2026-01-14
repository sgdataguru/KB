# CLP Knowledge Base - Development Environment

environment = "dev"
location    = "eastasia"

# Networking
vnet_address_space              = ["10.1.0.0/16"]
subnet_app_prefix               = "10.1.1.0/24"
subnet_data_prefix              = "10.1.2.0/24"
subnet_private_endpoints_prefix = "10.1.3.0/24"

# Azure OpenAI - Reduced capacity for dev
openai_deployments = [
  {
    name         = "gpt-4"
    model        = "gpt-4"
    version      = "0613"
    sku_name     = "Standard"
    sku_capacity = 5
  },
  {
    name         = "text-embedding-ada-002"
    model        = "text-embedding-ada-002"
    version      = "2"
    sku_name     = "Standard"
    sku_capacity = 60
  }
]

# Azure AI Search - Basic tier for dev
search_sku             = "basic"
search_replica_count   = 1
search_partition_count = 1

# App Service - Lower tier for dev
app_service_sku = "B1"

# Storage - Local redundancy for dev
storage_account_replication = "LRS"

# Tags
tags = {
  project     = "clp-kb"
  managed_by  = "terraform"
  department  = "digital"
  cost_center = "ai-innovation"
  environment = "development"
}