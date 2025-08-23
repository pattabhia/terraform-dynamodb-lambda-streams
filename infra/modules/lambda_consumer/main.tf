# Zip the Python file automatically on each apply
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.lambda_source_path
  output_path = "${path.module}/lambda.zip"
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.function_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

# Logs + DynamoDB stream read permissions (managed policy)
resource "aws_iam_role_policy_attachment" "lambda_ddb_stream_exec" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
}

# Lambda function
resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  runtime       = var.runtime
  handler       = var.handler

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = var.env
  }

  tags = var.tags
}

# Event source mapping from DynamoDB Streams -> Lambda
resource "aws_lambda_event_source_mapping" "ddb_to_lambda" {
  event_source_arn  = var.stream_arn
  function_name     = aws_lambda_function.this.arn
  starting_position = "LATEST"

  batch_size                         = 100
  maximum_batching_window_in_seconds = 1
  maximum_retry_attempts             = 2
  bisect_batch_on_function_error     = true
  function_response_types            = ["ReportBatchItemFailures"]
}
