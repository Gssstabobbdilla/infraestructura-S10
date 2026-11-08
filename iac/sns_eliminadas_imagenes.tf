resource "aws_sns_topic" "eliminadas_imagenes" {
  name = "${var.project_name}-${var.environment}-eliminadas_imagenes"

}

# Configuración Topic pa

resource "aws_sns_topic_policy" "eliminadas_imagenes" {
  arn = aws_sns_topic.eliminadas_imagenes.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowS3ToPublishDeletedImageEvents"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "SNS:Publish"
        Resource = aws_sns_topic.eliminadas_imagenes.arn
        Condition = {
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.input.arn
          }
        }
      }
    ]
  })
}