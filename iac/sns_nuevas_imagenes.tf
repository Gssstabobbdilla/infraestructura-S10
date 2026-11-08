resource "aws_sns_topic" "nuevas_imagenes" {
  name = "${var.project_name}-${var.environment}-nuevas_imagenes"

}

# Configuración Topic para que el bucket de S3 publique eventos

resource "aws_sns_topic_policy" "nuevas_imagenes" {
  arn = aws_sns_topic.nuevas_imagenes.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowS3ToPublishNewImageEvents"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "SNS:Publish"
        Resource = aws_sns_topic.nuevas_imagenes.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.input.arn
          }
        }
      }
    ]
  })
}