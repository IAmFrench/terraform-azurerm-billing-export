/* -------------------------------------------------------------------------- */
/*                           Billing Account Example                          */
/* -------------------------------------------------------------------------- */
/* -- Create a FOCUS export, resource group, storage account and container -- */

locals {
  billing_account_id = "123456789"
  export_start_date  = "2023-01-01"
}

provider "azapi" {

}

provider "azurerm" {
  features {}
}

resource "random_id" "resource_group" {
  prefix      = "rg-focus-export-"
  byte_length = 3
}

resource "random_id" "storage_account" {
  prefix      = "billingexport"
  byte_length = 3
}

/* -------------------------- FOCUS Billing export -------------------------- */
module "azurerm_billing_export" {
  source = "../.."

  create_resource_group   = true
  resource_group_name     = random_id.resource_group.dec
  resource_group_location = "Switzerland North"

  create_storage_account = true
  storage_account_name   = random_id.storage_account.dec

  create_storage_container = true
  storage_container_name   = "focus"

  export_type    = "FOCUS"
  export_version = "1.0"

  export_scope_and_id = {
    scope = "billing-account"
    id    = local.billing_account_id
  }

  export_start_date    = local.export_start_date
  export_creation_date = "2024-10-16"
  export_end_date      = "2050-01-01"

  enable_backfill = true

  export_directory = "billing_account_${local.billing_account_id}"

  export_name = substr("focus-export-for-billing-account-${local.billing_account_id}", 0, 64)
}
