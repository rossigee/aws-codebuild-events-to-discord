output "lambda_arn" {
  description = "ARN of Lambda function"
  value       = module.lambda.lambda_function_arn
}
