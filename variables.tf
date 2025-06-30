/* ----------------- Storage Account to create the export in ---------------- */
variable "storage_account_name" {
  description = <<-EOT
  Name of the Storage Account.
  
  The Storage Account will be created with this name if `var.create_storage_account` is `true`.
  
  E.g.: `billingexports`
  EOT

  type     = string
  nullable = false

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "The field can contain only lowercase letters and numbers. Name must be between 3 and 24 characters."
  }
}

variable "storage_account_location" {
  description = <<-EOT
  Location of the Storage Account.
  
  If `null`, the Storage Account will be created in the location linked to the resource group.
  
  E.g.: `Switzerland North`
  EOT

  type     = string
  default  = null
  nullable = true
}

variable "storage_container_name" {
  description = <<-EOT
  Name of the Storage Container.
  
  The Storage Container will be created with this name if `var.create_storage_container` is `true`.
  
  E.g.: `focus-v1.0`
  EOT

  type     = string
  nullable = false
}

/* --- Option to create or not the storage account for the billing export --- */
variable "create_storage_account" {
  description = <<-EOT
  Option to create or not the storage account for the billing export.
  
  If set to `false`, this module will not create the storage account.

  E.g.: `true`, `false`
  EOT

  type     = bool
  default  = true
  nullable = false
}

/* ----- Option to create or not the container within a storage account ----- */
variable "create_storage_container" {
  description = <<-EOT
  Option to create or not the Storage Container for the billing export.
  
  If set to `false`, this module will not create the storage Container and will
  instead lookup for a storage container with `var.storage_container_name` in 
  the `var.storage_account_name` Storage Account.
  
  Note: If `var.create_storage_account` is set to `true`, then this variable 
  MUST be set to `true`.

  E.g.: `true`, `false`
  EOT

  type     = bool
  default  = true
  nullable = false
}

/* -------- Name of the resource group to place created resources in -------- */
variable "resource_group_name" {
  description = <<-EOT
  Name of the resource group where the Storage account is located in.
  
  E.g.: `rg-finops-export-001`
  EOT
  type        = string
  nullable    = false
}

/* --------------------- Location of the resource group --------------------- */
variable "resource_group_location" {
  description = <<-EOT
  Location of the Storage Account.
  
  Note: if `var.create_resource_group` is set to `true`, then this variable MUST
  be set.

  E.g.: `Switzerland North`
  EOT

  type     = string
  default  = null
  nullable = true
}

/* ---- Option to create or not the resource group for the billing export --- */
variable "create_resource_group" {
  description = <<-EOT
  Option to create or not the Resource Group for the billing export.
  
  If set to `false`, this module will not create the resource group and will 
  instead lookup for a resource group with the name `var.resource_group_name`.

  E.g.: `true`, `false`
  EOT

  type     = bool
  default  = false
  nullable = false
}

/* ------------------------------- Export type ------------------------------ */
variable "export_type" {
  description = <<-EOT
  Version of the billing export.
  
  Valid values: 
  - `FOCUS` for Cost and usage details (FOCUS), 
  - `AMORTIZED` for Cost and usage details (amortized), 
  - `ACTUAL` for Cost and usage details (usage only)

  Learn more about export types: https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-improved-exports#schedule-frequency
  
  E.g.: `FOCUS`, `AMORTIZED` or `ACTUAL`
  EOT

  type     = string
  nullable = false

  validation {
    condition = contains([
      # FOCUS
      # Cost and usage details (FOCUS)
      "FOCUS",

      # AMORTIZED
      # Cost and usage details (amortized)
      # "AMORTIZED",

      # ACTUAL
      # Cost and usage details (usage only)
      # "ACTUAL",
      ],
      var.export_type
    )
    error_message = "Unsupported export type. Only `FOCUS` export type is supported. More info: https://learn.microsoft.com/en-us/azure/cost-management-billing/dataset-schema/schema-index#latest-dataset-schema-files"
  }
}

/* ----------------------------- Export version ----------------------------- */
# More info: https://learn.microsoft.com/en-us/azure/cost-management-billing/dataset-schema/schema-index#latest-dataset-schema-files
variable "export_version" {
  description = <<-EOT
  Version of the billing export. Should be use with `export_type`.
  
  Valid values are:
  - `1.2-preview`, `1.0r2` & `1.0` for `FOCUS`
  - `2023-12-01-preview` for Cost and usage details (EA, MCA, MPA and CSP)
  - `2019-11-01` for Cost and usage details (MOSA)
  
  E.g.: `1.2-preview`, `1.0r2`, `1.0`, `2023-12-01-preview`, `2019-11-01`
  EOT

  type     = string
  nullable = false

  validation {
    condition = contains([
      # FOCUS for
      # - Enterprise Agreement (EA)
      # - Microsoft Customer Agreement (MCA)
      "1.2-preview",
      "1.0",
      "1.0r2",

      # Cost and usage details for
      # - Enterprise Agreement (EA)
      # - Microsoft Customer Agreement (MCA)
      # - Microsoft Partner Agreement (MPA)
      # - Cloud Service Provider (CSP) subscription
      "2023-12-01-preview",

      # Cost and usage details for:
      # - Pay-as-you-go (MOSA)
      "2019-11-01"

      # Older versions aren't supported by this module
    ], var.export_version)
    error_message = "Unsupported version. Please the check your `export_type` and the associated version. More info: https://learn.microsoft.com/en-us/azure/cost-management-billing/dataset-schema/schema-index#latest-dataset-schema-files"
  }
}

/* ------------------------------ Export scope ------------------------------ */
variable "export_scope_and_id" {
  description = <<-EOT
  Scope and the corresponding id for the billing export.
  
  Valid values for scope are:
  - `billing-account` for an export at the billing account level (recommended)
  - `subscription` for an export at the subscription level
  
  E.g.: 
  ```
  {
    scope = "billing-account"
    id    = "1234567890"
  }
  ```
  EOT

  type = object({
    scope = string
    id    = string
  })
  nullable = false

  validation {
    condition = contains([
      "billing-account",
      "subscription"],
    var.export_scope_and_id.scope)
    error_message = "Valid values are: `billing-account` and `subscription`"
  }
}

/* ------------------------------- Export Name ------------------------------ */
variable "export_name" {
  description = <<-EOT
  Name of the billing export. 
  
  Validation: Export name must be alphanumeric, without whitespace, and 3 to 
  64 characters in length.

  E.g.: `focus-export-for-sub-63aa77b3-5e14-4c6d-a895-27f9d8443e37` (57 
  characters)
  EOT

  type     = string
  nullable = false

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,64}$", var.export_name))
    error_message = "Export name must be alphanumeric, without whitespace, and 3 to 64 characters in length."
  }
}

/* ---------------------------- Export Directory ---------------------------- */
variable "export_directory" {
  description = <<-EOT
  Directory to place the billing export in.
  
  Validation: Directory name cannot end with a forward slash(/) or dot(.)

  E.g.: `subscription_63aa77b3-5e14-4c6d-a895-27f9d8443e37` with 
  `63aa77b3-5e14-4c6d-a895-27f9d8443e37` being the subscription id
  EOT

  type     = string
  nullable = false
}

/* ---------------------------- Export start date --------------------------- */
variable "export_start_date" {
  description = <<-EOT
  Start date of the export.
  You can go as far as 9 years in the past.
  
  Validation: Date should be in the past and it must be the first day of the month.

  E.g.: `2024-01-01`
  EOT

  type     = string
  default  = "2020-01-01"
  nullable = false

  validation {
    condition     = endswith(var.export_start_date, "-01")
    error_message = "Date should be in the past and it must be the first day of the month."
  }
}

variable "export_creation_date" {
  description = <<-EOT
  Creation date of the export.

  E.g.: `2024-07-22`
  EOT

  type     = string
  nullable = false
}

/* ----------------------------- Export end date ---------------------------- */
variable "export_end_date" {
  description = <<-EOT
  End date of the export.
  
  Validation: Date should be in the future and it must be the first day of the month.

  E.g.: `2050-01-01`
  EOT

  type     = string
  default  = "2050-01-01"
  nullable = false

  validation {
    condition     = endswith(var.export_end_date, "-01")
    error_message = "Date should be in the future and it must be the first day of the month."
  }
}

/* ------------------------- Enable export backfill ------------------------- */
variable "enable_backfill" {
  description = <<-EOT
  Option to enable or not a backfill for the export.

  E.g.: `true`, `false`
  EOT

  type     = bool
  default  = false
  nullable = false
}

/* ---------------------------------- Tags ---------------------------------- */
variable "tags" {
  description = <<-EOT
  Tags to apply to all created resources.
  
  E.g.:
  ```
  {
    createdBy = "Terraform"
  }
  ```
  EOT

  type = map(string)
  default = {
    createdBy = "Terraform"
  }
  nullable = false
}
