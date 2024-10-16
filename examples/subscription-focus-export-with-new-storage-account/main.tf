/* -------------------------------------------------------------------------- */
/*                            Subscription Example                            */
/* -------------------------------------------------------------------------- */
/* -- Create a FOCUS export, Resource Group, Storage Account and Container -- */

data "azurerm_subscription" "current" {
}

locals {
  subscription_id = data.azurerm_subscription.current.subscription_id
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

module "azurerm_billing_export" {
  source = "../.."

  create_resource_group   = true
  resource_group_name     = random_id.resource_group.dec
  resource_group_location = "Switzerland North"

  create_storage_account = true
  storage_account_name   = random_id.storage_account.dec

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
