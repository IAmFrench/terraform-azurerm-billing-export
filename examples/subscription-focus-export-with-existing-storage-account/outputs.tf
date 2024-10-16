output "export_id" {
  description = <<-EOT
  Id of the export.

  E.g.: `/providers/Microsoft.Billing/billingAccounts/123456789/providers/Microsoft.CostManagement/exports/focus-export-for-billing-account-123456789`
  EOT

  value = module.azurerm_billing_export.export_id
}

output "months_to_backfill" {
  description = <<-EOT
  List of months to backfill.

  E.g.:
  ```
  [
    {
      start = "2023-01-01"
      end = "2023-01-31"
    },
    {
      start = "2023-02-01"
      end = "2023-02-28"
    }
  ]
  ```
  EOT

  value = module.azurerm_billing_export.months_to_backfill
}

output "backfill_job_id" {
  description = <<-EOT
  List of Ids of backfill jobs.

  E.g.: 
  ```
  [
    "/providers/Microsoft.Billing/billingAccounts/123456789/providers/Microsoft.CostManagement/exports/focus-export-for-billing-account-123456789/Run/e8102b07-9d1e-4185-95fe-fe60d8d6ad5a",
    "/providers/Microsoft.Billing/billingAccounts/123456789/providers/Microsoft.CostManagement/exports/focus-export-for-billing-account-123456789/Run/1089e775-8098-4d50-ae69-c22fd26ae7ef"
  ]
  ```
  EOT

  value = module.azurerm_billing_export.backfill_job_id
}
