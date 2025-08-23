variable "function_name" { type = string }
variable "runtime" { type = string }            # e.g., python3.12
variable "handler" { type = string }            # e.g., lambda_function.lambda_handler
variable "lambda_source_path" { type = string } # path to .py
variable "stream_arn" { type = string }         # from ddb module
variable "env" {
  type    = map(string)
  default = {}
}
variable "tags" {
  type    = map(string)
  default = {}
}
