resource "aws_s3_bucket" "unique_bucket" {
  bucket_prefix = "my-unique-bucket-"
  acl           = "private"
}

resource "aws_s3_bucket_notification" "s3_lambda_trigger" {
  bucket = aws_s3_bucket.unique_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.hello_world_function.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
