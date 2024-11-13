terraform {
  required_version = ">= 1.1.0"

  required_providers {
    time = {
      source  = "hashicorp/time"
      version = ">= 0.12.1, < 1.0"
    }
  }
}
