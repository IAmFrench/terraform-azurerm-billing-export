# Create a FOCUS export for a subscription in Azure

This example will create:
- a billing export
- a storage account
- a container

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.113.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.113.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azurerm_billing_export"></a> [azurerm\_billing\_export](#module\_azurerm\_billing\_export) | ../.. | n/a |
| <a name="module_naming"></a> [naming](#module\_naming) | Azure/naming/azurerm | 0.4.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.113.0/docs/data-sources/subscription) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backfill_job_id"></a> [backfill\_job\_id](#output\_backfill\_job\_id) | List of Ids of backfill jobs.<br><br>E.g.:<pre>[<br>  "/providers/Microsoft.Billing/billingAccounts/123456789/providers/Microsoft.CostManagement/exports/focus-export-for-billing-account-123456789/Run/e8102b07-9d1e-4185-95fe-fe60d8d6ad5a",<br>  "/providers/Microsoft.Billing/billingAccounts/123456789/providers/Microsoft.CostManagement/exports/focus-export-for-billing-account-123456789/Run/1089e775-8098-4d50-ae69-c22fd26ae7ef"<br>]</pre> |
| <a name="output_export_id"></a> [export\_id](#output\_export\_id) | Id of the export.<br><br>E.g.: `/providers/Microsoft.Billing/billingAccounts/123456789/providers/Microsoft.CostManagement/exports/focus-export-for-billing-account-123456789` |
| <a name="output_months_to_backfill"></a> [months\_to\_backfill](#output\_months\_to\_backfill) | List of months to backfill.<br><br>E.g.:<pre>[<br>  {<br>    start = "2023-01-01"<br>    end = "2023-01-31"<br>  },<br>  {<br>    start = "2023-02-01"<br>    end = "2023-02-28"<br>  }<br>]</pre> |
<!-- END_TF_DOCS -->
