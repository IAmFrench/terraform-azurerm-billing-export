# Microsoft Azure Billing export Terraform Module

Terraform module witch creates billing export on Azure.

[FOCUS v1.2](https://github.com/FinOps-Open-Cost-and-Usage-Spec/FOCUS_Spec/releases/tag/v1.2) billing export is now now available on Azure!

This module will create a storage account for Azure billing exports.

## What is FOCUS™?

The FinOps Cost and Usage Specification (FOCUS™) is an open-source specification that defines clear requirements for cloud vendors to produce consistent cost and usage datasets.

Supported by the FinOps Foundation, FOCUS™ aims to reduce complexity for FinOps Practitioners so they can drive data-driven decision-making and maximize the business value of cloud, while making their skills more transferable across clouds, tools, and organizations.

Learn more about FOCUS in this [FinOps Foundation Insights article](https://www.finops.org/insights/focus-1-0-available/).

## Usage

Detailed examples are available under the [`./examples`](./examples/) directory.

<details>

<summary>Create a FOCUS export for a billing account with a new resource group, storage account and container</summary>

```hcl
module "azurerm_billing_export" {
  source = "IAmFrench/billing-export/azurerm"

  version = "1.1.2" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  create_resource_group   = true
  resource_group_name     = "rg-focus-export-001"
  resource_group_location = "Switzerland North"

  create_storage_account = true
  storage_account_name   = "billingexportokjdlksa"

  create_storage_container = true
  storage_container_name   = "focus"

  export_type    = "FOCUS"
  export_version = "1.2-preview"

  export_scope_and_id = {
    scope = "billing-account"
    id    = "123456789"
  }

  export_start_date    = "2024-01-01"
  export_creation_date = "2025-07-01"
  export_end_date      = "2050-01-01"

  enable_backfill = true

  export_directory = "billing_account_123456789"

  export_name = "focus-export-for-billing-account-123456789"
}
```

</details>


<details>

<summary>Create a FOCUS export for a billing account with an existing resource group, storage account and container</summary>

```hcl
module "azurerm_billing_export" {
  source = "IAmFrench/billing-export/azurerm"

  version = "1.1.2" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  create_resource_group   = false
  resource_group_name     = "rg-focus-export-001"
  resource_group_location = "Switzerland North"

  create_storage_account = false
  storage_account_name   = "billingexportokjdlksa"

  create_storage_container = false
  storage_container_name   = "focus"

  export_type    = "FOCUS"
  export_version = "1.2-preview"

  export_scope_and_id = {
    scope = "billing-account"
    id    = "123456789"
  }

  export_start_date    = "2024-01-01"
  export_creation_date = "2025-07-01"
  export_end_date      = "2050-01-01"

  enable_backfill = true

  export_directory = "billing_account_123456789"

  export_name = "focus-export-for-billing-account-123456789"
}
```

</details>


<details>

<summary>Create a FOCUS export for a subcription with a existing resource group but new storage account and container</summary>

```hcl
module "azurerm_billing_export" {
  source = "IAmFrench/billing-export/azurerm"

  version = "1.1.2" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  create_resource_group   = false
  resource_group_name     = "rg-focus-export-001"
  resource_group_location = "Switzerland North"

  create_storage_account = true
  storage_account_name   = "billingexportzfcxfd"

  create_storage_container = true
  storage_container_name   = "focus"

  export_type    = "FOCUS"
  export_version = "1.2-preview"

  export_scope_and_id = {
    scope = "subscription"
    id    = "12345-uuid-6789"
  }

  export_start_date    = "2024-01-01"
  export_creation_date = "2025-07-01"
  export_end_date      = "2050-01-01"

  enable_backfill = true

  export_directory = "subscription_12345-uuid-6789"

  export_name = "focus-export-for-subscription-12345-uuid-6789"
}
```

</details>


## Roadmap & Features

- [X] FOCUS `1.2-preview` export 
- [X] FOCUS `1.0` & `1.0r2` export ([Improved export experience](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-improved-exports))
- [X] Subscription export (`export_scope_and_id` = `subscription`)
- [X] Billing Account export (`export_scope_and_id` = `billing-account`)
- [X] Automatic backfill from `export_start_date` to export's creation date (`export_creation_date`)
- [X] Retry implementation (if we hit the rate limit `429 Too Many Requests`)

## Limitations

- Id of backfill jobs is not returned by the [microsoft API](https://learn.microsoft.com/en-us/rest/api/cost-management/exports/execute) on job submission, therefore returned id is incorrect

## Common errors

### FocusCost is not supported

<details>

<summary>FocusCost is not supported</summary>

```bash
╷
│ Error: Failed to create/update resource
│
│   with module.azurerm_billing_export.azapi_resource.focus_export[0],
│   on ../../main.tf line 100, in resource "azapi_resource" "focus_export":
│  100: resource "azapi_resource" "focus_export" {
│
│ creating/updating Resource: (ResourceId
│ "/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/focus-export-for-subscription-xxxx-xxxx-xxxx-xxxx"
│ / Api Version "2023-07-01-preview"): PUT
│ https://management.azure.com/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/focus-export-for-subscription-xxxx-xxxx-xxxx-xxxx
│ --------------------------------------------------------------------------------
│ RESPONSE 400: 400 Bad Request
│ ERROR CODE: BadRequest
│ --------------------------------------------------------------------------------
│ {
│   "error": {
│     "code": "BadRequest",
│     "message": "Request properties validation failed: Export type: FocusCost is not supported for Agreement Type: WebDirect and Subscription."
│   }
│ }
│ --------------------------------------------------------------------------------
│
╵
```

</details>

Check if your subscription type is supported here: https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-improved-exports#understand-data-types

### RP Not Registered

<details>

<summary>RP Not Registered</summary>

```bash
╷
│ Error: Failed to create/update resource
│
│   with module.azurerm_billing_export.azapi_resource.focus_export[0],
│   on .terraform/modules/azurerm_billing_export/main.tf line 76, in resource "azapi_resource" "focus_export":
│   76: resource "azapi_resource" "focus_export" {
│
│ creating/updating Resource: (ResourceId
│ "/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/focus-export-for-subscription-xxxx-xxxx-xxxx-xxxx"
│ / Api Version "2023-07-01-preview"): PUT
│ https://management.azure.com/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/focus-export-for-subscription-xxxx-xxxx-xxxx-xxxx
│ --------------------------------------------------------------------------------
│ RESPONSE 400: 400 Bad Request
│ ERROR CODE: 400
│ --------------------------------------------------------------------------------
│ {
│   "error": {
│     "code": "400",
│     "message": "RP Not Registered. Register destination storage account subscription with Microsoft.CostManagementExports. Please refer https://docs.microsoft.com/en-us/rest/api/resources/providers/register"
│   }
│ }
│ --------------------------------------------------------------------------------
│
╵
```

</details>

Register `Microsoft.CostManagementExports` from the source subscription (`var.export_scope_and_id.id`).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | >= 2.0.0-beta, < 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.113.0, < 5.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.12.1, < 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | >= 2.0.0-beta, < 3.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.113.0, < 5.0 |
| <a name="provider_time"></a> [time](#provider\_time) | >= 0.12.1, < 1.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_months_to_backfill"></a> [months\_to\_backfill](#module\_months\_to\_backfill) | ./modules/months_to_backfill | n/a |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.focus_export](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource_action.backfill_job](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource_action) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_storage_account.export](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.focus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [time_static.export_creation_date](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.export](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_storage_container.focus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_container) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_resource_group"></a> [create\_resource\_group](#input\_create\_resource\_group) | Option to create or not the Resource Group for the billing export.<br/><br/>If set to `false`, this module will not create the resource group and will <br/>instead lookup for a resource group with the name `var.resource_group_name`.<br/><br/>E.g.: `true`, `false` | `bool` | `false` | no |
| <a name="input_create_storage_account"></a> [create\_storage\_account](#input\_create\_storage\_account) | Option to create or not the storage account for the billing export.<br/><br/>If set to `false`, this module will not create the storage account.<br/><br/>E.g.: `true`, `false` | `bool` | `true` | no |
| <a name="input_create_storage_container"></a> [create\_storage\_container](#input\_create\_storage\_container) | Option to create or not the Storage Container for the billing export.<br/><br/>If set to `false`, this module will not create the storage Container and will<br/>instead lookup for a storage container with `var.storage_container_name` in <br/>the `var.storage_account_name` Storage Account.<br/><br/>Note: If `var.create_storage_account` is set to `true`, then this variable <br/>MUST be set to `true`.<br/><br/>E.g.: `true`, `false` | `bool` | `true` | no |
| <a name="input_enable_backfill"></a> [enable\_backfill](#input\_enable\_backfill) | Option to enable or not a backfill for the export.<br/><br/>E.g.: `true`, `false` | `bool` | `false` | no |
| <a name="input_export_creation_date"></a> [export\_creation\_date](#input\_export\_creation\_date) | Creation date of the export.<br/><br/>E.g.: `2024-07-22` | `string` | n/a | yes |
| <a name="input_export_directory"></a> [export\_directory](#input\_export\_directory) | Directory to place the billing export in.<br/><br/>Validation: Directory name cannot end with a forward slash(/) or dot(.)<br/><br/>E.g.: `subscription_63aa77b3-5e14-4c6d-a895-27f9d8443e37` with <br/>`63aa77b3-5e14-4c6d-a895-27f9d8443e37` being the subscription id | `string` | n/a | yes |
| <a name="input_export_end_date"></a> [export\_end\_date](#input\_export\_end\_date) | End date of the export.<br/><br/>Validation: Date should be in the future and it must be the first day of the month.<br/><br/>E.g.: `2050-01-01` | `string` | `"2050-01-01"` | no |
| <a name="input_export_name"></a> [export\_name](#input\_export\_name) | Name of the billing export. <br/><br/>Validation: Export name must be alphanumeric, without whitespace, and 3 to <br/>64 characters in length.<br/><br/>E.g.: `focus-export-for-sub-63aa77b3-5e14-4c6d-a895-27f9d8443e37` (57 <br/>characters) | `string` | n/a | yes |
| <a name="input_export_scope_and_id"></a> [export\_scope\_and\_id](#input\_export\_scope\_and\_id) | Scope and the corresponding id for the billing export.<br/><br/>Valid values for scope are:<br/>- `billing-account` for an export at the billing account level (recommended)<br/>- `subscription` for an export at the subscription level<br/><br/>E.g.:<pre>{<br/>  scope = "billing-account"<br/>  id    = "1234567890"<br/>}</pre> | <pre>object({<br/>    scope = string<br/>    id    = string<br/>  })</pre> | n/a | yes |
| <a name="input_export_start_date"></a> [export\_start\_date](#input\_export\_start\_date) | Start date of the export.<br/>You can go as far as 9 years in the past.<br/><br/>Validation: Date should be in the past and it must be the first day of the month.<br/><br/>E.g.: `2024-01-01` | `string` | `"2020-01-01"` | no |
| <a name="input_export_type"></a> [export\_type](#input\_export\_type) | Version of the billing export.<br/><br/>Valid values: <br/>- `FOCUS` for Cost and usage details (FOCUS), <br/>- `AMORTIZED` for Cost and usage details (amortized), <br/>- `ACTUAL` for Cost and usage details (usage only)<br/><br/>Learn more about export types: https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-improved-exports#schedule-frequency<br/><br/>E.g.: `FOCUS`, `AMORTIZED` or `ACTUAL` | `string` | n/a | yes |
| <a name="input_export_version"></a> [export\_version](#input\_export\_version) | Version of the billing export. Should be use with `export_type`.<br/><br/>Valid values are:<br/>- `1.2-preview`, `1.0r2` & `1.0` for `FOCUS`<br/>- `2023-12-01-preview` for Cost and usage details (EA, MCA, MPA and CSP)<br/>- `2019-11-01` for Cost and usage details (MOSA)<br/><br/>E.g.: `1.2-preview`, `1.0r2`, `1.0`, `2023-12-01-preview`, `2019-11-01` | `string` | n/a | yes |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Location of the Storage Account.<br/><br/>Note: if `var.create_resource_group` is set to `true`, then this variable MUST<br/>be set.<br/><br/>E.g.: `Switzerland North` | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group where the Storage account is located in.<br/><br/>E.g.: `rg-finops-export-001` | `string` | n/a | yes |
| <a name="input_storage_account_location"></a> [storage\_account\_location](#input\_storage\_account\_location) | Location of the Storage Account.<br/><br/>If `null`, the Storage Account will be created in the location linked to the resource group.<br/><br/>E.g.: `Switzerland North` | `string` | `null` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Name of the Storage Account.<br/><br/>The Storage Account will be created with this name if `var.create_storage_account` is `true`.<br/><br/>E.g.: `billingexports` | `string` | n/a | yes |
| <a name="input_storage_container_name"></a> [storage\_container\_name](#input\_storage\_container\_name) | Name of the Storage Container.<br/><br/>The Storage Container will be created with this name if `var.create_storage_container` is `true`.<br/><br/>E.g.: `focus-v1.0` | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all created resources.<br/><br/>E.g.:<pre>{<br/>  createdBy = "Terraform"<br/>}</pre> | `map(string)` | <pre>{<br/>  "createdBy": "Terraform"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backfill_job_id"></a> [backfill\_job\_id](#output\_backfill\_job\_id) | List of Ids of backfill jobs.<br/><br/>E.g.:<pre>[<br/>  "/providers/Microsoft.Billing/billingAccounts/123456789/providers/Microsoft.CostManagement/exports/focus-export-for-billing-account-123456789/Run/e8102b07-9d1e-4185-95fe-fe60d8d6ad5a",<br/>  "/providers/Microsoft.Billing/billingAccounts/123456789/providers/Microsoft.CostManagement/exports/focus-export-for-billing-account-123456789/Run/1089e775-8098-4d50-ae69-c22fd26ae7ef"<br/>]</pre> |
| <a name="output_export_id"></a> [export\_id](#output\_export\_id) | Id of the export.<br/><br/>E.g.: `/providers/Microsoft.Billing/billingAccounts/123456789/providers/Microsoft.CostManagement/exports/focus-export-for-billing-account-123456789` |
| <a name="output_months_to_backfill"></a> [months\_to\_backfill](#output\_months\_to\_backfill) | List of months to backfill.<br/><br/>E.g.:<pre>[<br/>  {<br/>    start = "2023-01-01T00:00:00Z"<br/>    end = "2023-01-31T00:00:00Z"<br/>  },<br/>  {<br/>    start = "2023-02-01T00:00:00Z"<br/>    end = "2023-02-28T00:00:00Z"<br/>  }<br/>]</pre> |
<!-- END_TF_DOCS -->
