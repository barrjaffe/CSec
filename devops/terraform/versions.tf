terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.0"
    }
  }

  backend "azurerm" {
    # TODO: Replace with your actual state storage account details
    # resource_group_name  = "your-tfstate-rg"
    # storage_account_name = "yourtfstateaccount"
    # container_name       = "tfstate"
    # key                  = "cyber-platform.tfstate"
    # Alternatively, use: terraform init -backend-config="..." to configure dynamically
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azapi" {}
