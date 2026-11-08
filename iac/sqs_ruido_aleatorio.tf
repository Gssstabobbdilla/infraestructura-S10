resource "aws_sqs_queue" "ruido_aleatorio" {
  name                       = "${var.project_name}-${var.environment}-ruido-aleatorio"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 10
}

resource "aws_sns_topic_subscription" "ruido_aleatorio" {
  topic_arn = aws_sns_topic.nuevas_imagenes.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.ruido_aleatorio.arn
}

resource "aws_sqs_queue_policy" "ruido_aleatorio" {
  queue_url = aws_sqs_queue.ruido_aleatorio.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PermitirPublicacionDesdeSNS"
        Effect    = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.ruido_aleatorio.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.nuevas_imagenes.arn
          }
        }
      }
    ]
  })
}