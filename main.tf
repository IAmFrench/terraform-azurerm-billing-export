/* -------------------------------------------------------------------------- */
/*                            Azure billing export                            */
/* -------------------------------------------------------------------------- */

/* ----------------------------- Resource Group ----------------------------- */
resource "azurerm_resource_group" "main" {
  # Create the Resource Group only if var.create_resource_group is true
  count = var.create_resource_group ? 1 : 0

  name     = var.resource_group_name
  location = var.resource_group_location

  tags = var.tags
}

data "azurerm_resource_group" "main" {
  # The Resource Group already exist only if var.create_resource_group is false
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

/* ----------------------------- Storage Account ---------------------------- */
resource "azurerm_storage_account" "export" {
  # Create the storage account only if var.create_storage_account is true
  count = var.create_storage_account ? 1 : 0

  name                     = var.storage_account_name
  resource_group_name      = var.create_resource_group ? azurerm_resource_group.main[0].name : data.azurerm_resource_group.main[0].name
  location                 = var.storage_account_location != null ? var.storage_account_location : var.create_resource_group ? azurerm_resource_group.main[0].location : data.azurerm_resource_group.main[0].location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  # Required to create the billing export
  shared_access_key_enabled = true

  tags = var.tags
}

data "azurerm_storage_account" "export" {
  # The Storage Account already exists only if var.create_storage_account is false
  count = var.create_storage_account ? 0 : 1

  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

data "azurerm_storage_container" "focus" {
  # The Storage Container already exists only if var.create_storage_container is false
  count = var.create_storage_container ? 0 : 1

  storage_account_name = var.create_storage_account ? azurerm_storage_account.export[0].name : data.azurerm_storage_account.export[0].name
  name                 = var.storage_container_name
}

/* ------------------- Container (of the Storage Account) ------------------- */
resource "azurerm_storage_container" "focus" {
  # Create the storage container if `var.create_storage_container` is `true`
  count = var.create_storage_container ? 1 : 0

  name                 = var.storage_container_name
  storage_account_name = var.create_storage_account ? azurerm_storage_account.export[0].name : data.azurerm_storage_account.export[0].name
}

/* -------------------------- Export creation date -------------------------- */
resource "time_static" "export_creation_date" {
  triggers = {
    export_id = azapi_resource.focus_export[0].id
  }
}

locals {
  billing_scope = var.export_scope_and_id.scope == "subscription" ? "subscriptions" : "providers/Microsoft.Billing/billingAccounts"
}

/* ------------------- FOCUS export for a billing account ------------------- */
resource "azapi_resource" "focus_export" {
  # Create the FOCUS billing export only if `var.export_type` is `FOCUS`
  count = var.export_type == "FOCUS" ? 1 : 0

  type = "Microsoft.CostManagement/exports@2023-07-01-preview"

  # Scope of the billing export
  # /subscriptions/id for a FOCUS export at the Subscription level
  # /providers/Microsoft.Billing/billingAccount/id for a FOCUS export at the Billing Account level
  parent_id = "/${local.billing_scope}/${var.export_scope_and_id.id}"

  # Name of the export
  name     = var.export_name
  location = "global"

  body = {
    properties = {
      definition = {
        # Export type (focus)
        type = "FocusCost"
        # Export period (Month to date)
        timeframe = "MonthToDate"
        dataSet = {
          configuration = {
            # Version of the export
            # 1.0 for FOCUS v1.0
            dataVersion = var.export_version
          }
          granularity = "Daily"
        }
      }
      deliveryInfo = {
        "destination" : {
          # Id of the Storage Account
          resourceId = var.create_storage_account ? azurerm_storage_account.export[0].id : data.azurerm_storage_account.export[0].id
          # Id of the Container
          container = var.create_storage_container ? azurerm_storage_container.focus[0].name : data.azurerm_storage_container.focus[0].name
          # Export directory
          rootFolderPath = var.export_directory
          type           = "AzureBlob"
        }
      }
      schedule = {
        recurrence : "Daily"
        recurrencePeriod = {
          from = "${var.export_start_date}T00:00:00Z"
          to   = "${var.export_end_date}T00:00:00Z"
        }
        status = "Active"
      }
      format                = "Parquet"
      partitionData         = true
      dataOverwriteBehavior = "OverwritePreviousReport"
      compressionMode       = "snappy"
      exportDescription     = "FOCUS export for ${var.export_scope_and_id.scope} ${var.export_scope_and_id.id}"
    }
  }
}


/* -------------------- Get a list of months to backfill -------------------- */
# List of month is accessible using
# module.months_to_backfill.months_to_backfill
module "months_to_backfill" {
  source = "./modules/months_to_backfill"

  # Create the list of months only if `var.export_type` is `FOCUS`
  count = var.export_type == "FOCUS" ? 1 : 0

  # Start date of the export (can be in the past)
  export_start_date = var.export_start_date
  # Creation date of the export (should be the date where this module is first used)
  export_creation_date = var.export_creation_date
  # End date of the export (in the future, e.g.: 2025-01-01)
  export_end_date = var.export_end_date
}

/* ------------------------------ Backfill job ------------------------------ */
resource "azapi_resource_action" "backfill_job" {
  # Create backfill jobs only if `var.enable_backfill` is `true` and `var.export_type` is `FOCUS`
  count = var.enable_backfill && var.export_type == "FOCUS" ? length(module.months_to_backfill[0].months_to_backfill) : 0

  type                   = "Microsoft.CostManagement/exports@2023-07-01-preview"
  resource_id            = azapi_resource.focus_export[0].id
  action                 = "run"
  response_export_values = ["*"]
  body = {
    timePeriod = {
      from = module.months_to_backfill[0].months_to_backfill[count.index].start_date
      to   = module.months_to_backfill[0].months_to_backfill[count.index].end_date
    }
  }
  locks = ["${azapi_resource.focus_export[0].id}/run"]

  retry = {
    error_message_regex = [
      "Too many requests"
    ]
  }

  timeouts {
    read = "10m"
  }
}
