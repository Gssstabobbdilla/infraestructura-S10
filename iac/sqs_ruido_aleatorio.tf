resource "aws_sqs_queue" "ruido_aleatorio" {
  name                       = "${var.project_name}-${var.environment}-ruido-aleatorio"
  visibility_timeout_seconds = 180
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

resource "aws_lambda_event_source_mapping" "cola_ruido" {
  event_source_arn = aws_sqs_queue.ruido_aleatorio.arn
  function_name    = aws_lambda_function.trabajos.arn
  enabled          = true
  batch_size       = 1

  scaling_config {
    maximum_concurrency = 2
  }

  depends_on = [
    aws_iam_role_policy.lambda_cola_ruido
  ]
}