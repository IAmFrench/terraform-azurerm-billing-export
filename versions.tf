terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.113.0, < 5.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">= 2.0.0-beta, < 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.12.1, < 1.0.0"
    }
  }
}
