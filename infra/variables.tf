variable "table_name" {
  type        = string
  description = "Name of the DynamoDB table"
  default     = "employees"
}

variable "tags" {
  type = map(string)
  default = {
    environment = "test-dev"
    service     = "employee-directory"
  }
}
