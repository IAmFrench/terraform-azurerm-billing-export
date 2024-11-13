/* -------------------------------------------------------------------------- */
/*                            Subscription Example                            */
/* -------------------------------------------------------------------------- */
/* -- Create a FOCUS export, Resource Group, Storage Account and Container -- */

data "azurerm_subscription" "current" {
}

locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
}

provider "azurerm" {
  features {}
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.1"

  suffix = ["finops"]
}

module "azurerm_billing_export" {
  source = "../.."

  create_resource_group   = true
  resource_group_name     = module.naming.resource_group.name_unique
  resource_group_location = "Switzerland North"

  create_storage_account = true
  storage_account_name   = module.naming.storage_account.name_unique

  create_storage_container = true
  storage_container_name   = "focus"

  export_type       = "FOCUS"
  export_version    = "1.0"
  export_start_date = "2024-01-01"

  export_scope_and_id = {
    scope = "subscription"
    id    = local.subscription_id
  }

  export_creation_date = "2024-09-03"

  enable_backfill = true

  export_directory = "subcription_${local.subscription_id}"

  export_name = substr("focus-export-for-subscription-${local.subscription_id}", 0, 64)
}
