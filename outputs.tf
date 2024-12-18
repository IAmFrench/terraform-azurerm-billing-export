output "export_id" {
  description = <<-EOT
  Id of the export.

  E.g.: `/providers/Microsoft.Billing/billingAccounts/123456789/providers/Microsoft.CostManagement/exports/focus-export-for-billing-account-123456789`
  EOT

  value = var.export_type == "FOCUS" ? azapi_resource.focus_export[0].id : null # Not yet implemented for other export types
}

output "months_to_backfill" {
  description = <<-EOT
  List of months to backfill.

  E.g.:
  ```
  [
    {
      start = "2023-01-01T00:00:00Z"
      end = "2023-01-31T00:00:00Z"
    },
    {
      start = "2023-02-01T00:00:00Z"
      end = "2023-02-28T00:00:00Z"
    }
  ]
  ```
  EOT

  value = var.export_type == "FOCUS" ? module.months_to_backfill[0].months_to_backfill : null # Not yet implemented for other export types
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

  value = azapi_resource_action.backfill_job[*].id
}
