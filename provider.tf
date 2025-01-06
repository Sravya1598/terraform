provider "aws" {
  region = "us-east-1"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.unique_bucket.bucket
}

output "lambda_function_name" {
  value = aws_lambda_function.hello_world_function.function_name
}
