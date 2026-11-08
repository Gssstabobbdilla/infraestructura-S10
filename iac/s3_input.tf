resource "aws_s3_bucket" "input" {
  bucket_prefix = "${var.project_name}-${var.environment}-input-"
}