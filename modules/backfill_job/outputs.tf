output "backfill_job_id" {
  description = <<-EOT
  Id of the backfill job.

  E.g.: `/providers/Microsoft.Billing/billingAccounts/123456789/providers/Microsoft.CostManagement/exports/focus-export-for-billing-account-123456789/Run/e8102b07-9d1e-4185-95fe-fe60d8d6ad5a`
  EOT

  value = azapi_resource_action.backfill_job.id
}
