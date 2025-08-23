variable "table_name" { type = string }
variable "billing_mode" {
  type    = string
  default = "PAY_PER_REQUEST" # or PROVISIONED
}
variable "stream_view_type" {
  type    = string
  default = "NEW_AND_OLD_IMAGES"
}
variable "tags" {
  type    = map(string)
  default = {}
}
