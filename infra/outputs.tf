output "table_name" { value = module.ddb.table_name }
output "stream_arn" { value = module.ddb.stream_arn }
output "lambda_name" { value = module.consumer.function_name }
