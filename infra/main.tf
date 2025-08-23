module "ddb" {
  source     = "./modules/dynamodb_table"
  table_name = var.table_name
  tags       = var.tags

  # optional inputs with sane defaults inside the module
  billing_mode     = "PAY_PER_REQUEST"
  stream_view_type = "NEW_AND_OLD_IMAGES"
}

module "consumer" {
  source        = "./modules/lambda_consumer"
  function_name = "employees_stream_consumer"
  runtime       = "python3.12"
  handler       = "lambda_function.lambda_handler"

  # pass the stream ARN from the DynamoDB module
  stream_arn = module.ddb.stream_arn

  # path to your lambda code (module will zip it with archive_file)
  lambda_source_path = "${path.module}/modules/lambda_consumer/lambda/lambda_function.py"

  env = {
    LOG_LEVEL = "INFO"
  }

  tags = var.tags
}
