# CLP Knowledge Base - Terraform Providers

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.85.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.0"
    }
  }

  # Remote state configuration - uncomment for production
  # backend "azurerm" {
  #   resource_group_name  = "rg-clp-kb-tfstate"
  #   storage_account_name = "stclpkbtfstate"
  #   container_name       = "tfstate"
  #   key                  = "clp-kb.tfstate"
  # }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
    cognitive_account {
      purge_soft_delete_on_destroy = false
    }
  }
}

provider "azuread" {}

provider "random" {}