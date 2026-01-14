# CLP Knowledge Base - Terraform Variables

# =============================================================================
# GENERAL
# =============================================================================

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "clp-kb"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}

variable "location" {
  description = "Azure region for resources - Hong Kong for data residency"
  type        = string
  default     = "eastasia"  # Azure Hong Kong region
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    project     = "clp-kb"
    managed_by  = "terraform"
    department  = "digital"
    cost_center = "ai-innovation"
  }
}

# =============================================================================
# NETWORKING
# =============================================================================

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_app_prefix" {
  description = "Address prefix for application subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_data_prefix" {
  description = "Address prefix for data subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "subnet_private_endpoints_prefix" {
  description = "Address prefix for private endpoints subnet"
  type        = string
  default     = "10.0.3.0/24"
}

# =============================================================================
# AZURE OPENAI
# =============================================================================

variable "openai_sku" {
  description = "SKU for Azure OpenAI Service"
  type        = string
  default     = "S0"
}

variable "openai_deployments" {
  description = "List of OpenAI model deployments"
  type = list(object({
    name       = string
    model      = string
    version    = string
    sku_name   = string
    sku_capacity = number
  }))
  default = [
    {
      name         = "gpt-4"
      model        = "gpt-4"
      version      = "0613"
      sku_name     = "Standard"
      sku_capacity = 10
    },
    {
      name         = "text-embedding-ada-002"
      model        = "text-embedding-ada-002"
      version      = "2"
      sku_name     = "Standard"
      sku_capacity = 120
    }
  ]
}

# =============================================================================
# AZURE AI SEARCH
# =============================================================================

variable "search_sku" {
  description = "SKU for Azure AI Search"
  type        = string
  default     = "standard"  # standard for vector search support
}

variable "search_replica_count" {
  description = "Number of search replicas"
  type        = number
  default     = 1
}

variable "search_partition_count" {
  description = "Number of search partitions"
  type        = number
  default     = 1
}

# =============================================================================
# COSMOS DB
# =============================================================================

variable "cosmos_throughput" {
  description = "Provisioned throughput for Cosmos DB"
  type        = number
  default     = 400
}

variable "cosmos_consistency_level" {
  description = "Consistency level for Cosmos DB"
  type        = string
  default     = "Session"
}

# =============================================================================
# APP SERVICE
# =============================================================================

variable "app_service_sku" {
  description = "SKU for App Service Plan"
  type        = string
  default     = "P1v3"  # Production tier with better performance
}

# =============================================================================
# STORAGE
# =============================================================================

variable "storage_account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication" {
  description = "Storage account replication type"
  type        = string
  default     = "LRS"  # Use GRS for production
}

# =============================================================================
# DATA GOVERNANCE
# =============================================================================

variable "retention_days" {
  description = "Data retention period in days (7-10 years)"
  type        = number
  default     = 3650  # 10 years
}

variable "soft_delete_retention_days" {
  description = "Soft delete retention period for Key Vault"
  type        = number
  default     = 90
}

# =============================================================================
# PHASE 2 - BLUEPRINT VARIABLES (For future use)
# =============================================================================

variable "enable_ai_avatar" {
  description = "Enable AI Avatar infrastructure (Phase 2)"
  type        = bool
  default     = false
}

variable "enable_video_indexer" {
  description = "Enable Video Indexer for large-scale processing (Phase 2)"
  type        = bool
  default     = false
}

variable "gpu_node_count" {
  description = "Number of GPU nodes for AI Avatar (Phase 2)"
  type        = number
  default     = 0
}