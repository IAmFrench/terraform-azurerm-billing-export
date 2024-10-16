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
