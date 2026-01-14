# CLP Knowledge Base - Production Environment

environment = "prod"
location    = "eastasia"

# Networking
vnet_address_space              = ["10.0.0.0/16"]
subnet_app_prefix               = "10.0.1.0/24"
subnet_data_prefix              = "10.0.2.0/24"
subnet_private_endpoints_prefix = "10.0.3.0/24"

# Azure OpenAI - Full capacity for production
openai_deployments = [
  {
    name         = "gpt-4"
    model        = "gpt-4"
    version      = "0613"
    sku_name     = "Standard"
    sku_capacity = 20
  },
  {
    name         = "text-embedding-ada-002"
    model        = "text-embedding-ada-002"
    version      = "2"
    sku_name     = "Standard"
    sku_capacity = 240
  }
]

# Azure AI Search - Standard with redundancy
search_sku             = "standard"
search_replica_count   = 2
search_partition_count = 1

# App Service - Production tier
app_service_sku = "P2v3"

# Storage - Geo-redundant for production
storage_account_replication = "GRS"

# Retention - 10 years for compliance
retention_days = 3650

# Tags
tags = {
  project     = "clp-kb"
  managed_by  = "terraform"
  department  = "digital"
  cost_center = "ai-innovation"
  environment = "production"
}