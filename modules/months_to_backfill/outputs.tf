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

  value = local.months_to_backfill
}
