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

# Notificaciones para el bucket de S3 (input)

resource "aws_s3_bucket_notification" "input" {
  bucket = aws_s3_bucket.input.id

  topic {
    topic_arn = aws_sns_topic.nuevas_imagenes.arn
    events = ["s3:ObjectCreated:*"]
  }

  topic {
    topic_arn = aws_sns_topic.eliminadas_imagenes.arn
    events = ["s3:ObjectRemoved:*"]
  }

  depends_on = [
    aws_sns_topic_policy.nuevas_imagenes,
    aws_sns_topic_policy.eliminadas_imagenes
  ]
}