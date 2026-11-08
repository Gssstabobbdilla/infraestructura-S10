resource "aws_s3_bucket" "output" {
  bucket_prefix = "${var.project_name}-${var.environment}-output-"
}

resource "aws_s3_bucket_public_access_block" "output" {
  bucket = aws_s3_bucket.output.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}