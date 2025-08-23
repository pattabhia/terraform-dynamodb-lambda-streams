resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = var.billing_mode

  # PK
  hash_key = "employeeid"

  attribute {
    name = "employeeid"
    type = "S"
  }

  # Streams
  stream_enabled   = true
  stream_view_type = var.stream_view_type

  # Good defaults for prod-ish setups (optional)
  point_in_time_recovery { enabled = true }
  server_side_encryption { enabled = true }

  tags = var.tags
}
