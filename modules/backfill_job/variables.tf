variable "export_id" {
  description = <<-EOT
  Id of the export.

  E.g.: `/providers/Microsoft.Billing/billingAccounts/123456789/providers/Microsoft.CostManagement/exports/focus-export-for-billing-account-123456789`
  EOT

  type     = string
  nullable = false
}

variable "backfill_start_date" {
  description = <<-EOT
  End date of the backfill job.

  E.g.: `2023-01-01T00:00:00Z`
  EOT

  type     = string
  nullable = false
}

variable "backfill_end_date" {
  description = <<-EOT
  End date of the backfill job.

  E.g.: `2023-01-31T00:00:00Z`
  EOT

  type     = string
  nullable = false
}
