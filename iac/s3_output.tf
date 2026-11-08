resource "aws_s3_bucket" "output" {
  bucket_prefix = "${var.project_name}-${var.environment}-output-"
}
