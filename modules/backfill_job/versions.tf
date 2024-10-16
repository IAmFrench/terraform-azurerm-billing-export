terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "2.0.0-beta"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.12.1"
    }
  }
}
