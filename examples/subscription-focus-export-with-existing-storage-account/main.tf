/* -------------------------------------------------------------------------- */
/*                            Subscription Example                            */
/* -------------------------------------------------------------------------- */
/* ----------------------- Create only a FOCUS export ----------------------- */
/* ------- with existing resource group, storage account and container ------ */

data "azurerm_subscription" "current" {
}

locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
}

provider "azurerm" {
  features {}
}

module "azurerm_billing_export" {
  source = "../.."

  create_resource_group   = false
  resource_group_name     = "rg-finops-focus-export-001"
  resource_group_location = "Switzerland North"

  create_storage_account = false
  storage_account_name   = "billingexportdsakjhds"

  create_storage_container = false
  storage_container_name   = "focus"

  export_type       = "FOCUS"
  export_version    = "1.0r2"
  export_start_date = "2024-01-01"

  export_scope_and_id = {
    scope = "subscription"
    id    = local.subscription_id
  }

  export_creation_date = "2024-08-16"

  enable_backfill = true

  export_directory = "subcription_${local.subscription_id}"

  export_name = substr("focus-export-for-subscription-${local.subscription_id}", 0, 64)
}
