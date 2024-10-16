/* ---------------------------- Export start date --------------------------- */
resource "time_static" "export_start_date" {
  rfc3339 = "${var.export_start_date}T00:00:00Z"
}

/* ----------------------------- Export end date ---------------------------- */
resource "time_static" "export_end_date" {
  rfc3339 = "${var.export_end_date}T00:00:00Z"
}

locals {
  # Years of difference between export creation date and export start date
  # Max 9 years
  export_year_difference = substr(var.export_creation_date, 0, 4) - substr(var.export_start_date, 0, 4)

  # Months for (the current year) of difference between export creation date and export start date
  export_month_difference = substr(var.export_creation_date, 5, 2) - substr(var.export_start_date, 5, 2)

  # Months of difference between export creation date and export start date
  export_total_month_difference = local.export_year_difference * 12 + local.export_month_difference
}

/* ----------- Generate the start date for each month to backfill ----------- */
resource "time_offset" "backfill_start_date" {
  # Create a new ressource for each month to fill
  # Except the last month (month of the export creation date)
  count = local.export_total_month_difference + 2

  base_rfc3339  = "${var.export_start_date}T00:00:00Z"
  offset_months = count.index
}

/* ------------ Generate the end date for each month to backfill ------------ */
resource "time_offset" "backfill_end_date" {
  # Create a new ressource for each month to fill
  # Except the last month (month of the export creation date)
  count = local.export_total_month_difference + 1

  base_rfc3339 = time_offset.backfill_start_date[count.index + 1].rfc3339
  offset_days  = -1
}


locals {
  # List of months bewteen export start date and export creation date
  months_to_backfill = concat([for month in range(0, local.export_total_month_difference) :
    {
      start_date = time_offset.backfill_start_date[month].rfc3339
      end_date   = time_offset.backfill_end_date[month].rfc3339
    }
    ],
    # Create a backfill for the current month
    [{
      start_date = "${substr(var.export_creation_date, 0, 7)}-01T00:00:00Z"
      end_date   = "${var.export_creation_date}T00:00:00Z"
    }]
  )
}
