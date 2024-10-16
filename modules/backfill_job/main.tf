/* -------------------------------------------------------------------------- */
/*                    Run a backfill job for a given month                    */
/* -------------------------------------------------------------------------- */

/* ---------------------- Hack to limit API rate limits --------------------- */
resource "time_sleep" "wait_15_seconds" {
  create_duration  = "15s"
  destroy_duration = "15s"

  triggers = {
    export_id  = var.export_id
    start_date = var.backfill_start_date
    end_date   = var.backfill_end_date
  }
}

/* ------------------------------ Backfill job ------------------------------ */
resource "azapi_resource_action" "backfill_job" {
  type                   = "Microsoft.CostManagement/exports@2023-07-01-preview"
  resource_id            = var.export_id
  action                 = "run"
  response_export_values = ["*"]
  body = {
    timePeriod = {
      from = var.backfill_start_date
      to   = var.backfill_end_date
    }
  }
  locks = ["${var.export_id}/run"]

  # Hack to limit API Rate limit
  depends_on = [time_sleep.wait_15_seconds]
}
