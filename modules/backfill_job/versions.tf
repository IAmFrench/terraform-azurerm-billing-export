terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = ">= 2.0.0-beta, < 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.12.1, < 1.0"
    }
  }
}
