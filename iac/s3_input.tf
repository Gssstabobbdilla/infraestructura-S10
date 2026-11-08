resource "aws_s3_bucket" "input" {
  bucket_prefix = "${var.project_name}-${var.environment}-input-"
}

resource "aws_s3_bucket_public_access_block" "input" {
  bucket = aws_s3_bucket.input.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}