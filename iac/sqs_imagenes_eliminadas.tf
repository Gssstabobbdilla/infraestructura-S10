resource "aws_sqs_queue" "imagenes_eliminadas" {
  name = "${var.project_name}-${var.environment}-imagenes-eliminadas"
  visibility_timeout_seconds = 180
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 10
}

resource "aws_sqs_queue_policy" "imagenes_eliminadas" {
  queue_url = aws_sqs_queue.imagenes_eliminadas.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PermitirPublicacionDesdeTemaEliminaciones"
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action = "sqs:SendMessage"
        Resource = aws_sqs_queue.imagenes_eliminadas.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.eliminadas_imagenes.arn
          }
        }
      }
    ]
  })
}