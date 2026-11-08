resource "aws_sqs_queue" "imagen_moderacion" {
  name = "${var.project_name}-${var.environment}-imagen_moderacion"
  visibility_timeout_seconds = 180
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 10
}

resource "aws_sns_topic_subscription" "imagen_moderacion" {
  topic_arn = aws_sns_topic.nuevas_imagenes.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.imagen_moderacion.arn
  depends_on = [
    aws_sqs_queue_policy.imagen_moderacion
  ]
}

resource "aws_sqs_queue_policy" "imagen_moderacion" {
  queue_url = aws_sqs_queue.imagen_moderacion.id

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
        Resource = aws_sqs_queue.imagen_moderacion.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.nuevas_imagenes.arn
          }
        }
      }
    ]
  })
}

resource "aws_lambda_event_source_mapping" "moderacion_imagenes" {
  event_source_arn = aws_sqs_queue.imagen_moderacion.arn
  function_name  = aws_lambda_function.validador_imagenes.arn
  enabled  = true
  batch_size = 1

  scaling_config {
    maximum_concurrency = 2
  }

  depends_on = [
    aws_iam_role_policy.validador_imagenes
  ]
}