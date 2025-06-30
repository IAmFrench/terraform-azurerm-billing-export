/* -------------------------------------------------------------------------- */
/*                           Billing Account Example                          */
/* -------------------------------------------------------------------------- */
/* -- Create a FOCUS export, resource group, storage account and container -- */

locals {
  billing_account_id = "123456789"
  export_start_date  = "2023-01-01"
}

provider "azurerm" {
  features {}
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.1"

  suffix = ["finops"]
}

/* -------------------------- FOCUS Billing export -------------------------- */
module "azurerm_billing_export" {
  source = "../.."

  create_resource_group   = true
  resource_group_name     = module.naming.resource_group.name_unique
  resource_group_location = "Switzerland North"

  create_storage_account = true
  storage_account_name   = module.naming.storage_account.name_unique

  create_storage_container = true
  storage_container_name   = "focus"

  export_type    = "FOCUS"
  export_version = "1.2-preview"

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
