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

resource "aws_lambda_event_source_mapping" "auditoria_eliminaciones" {
  event_source_arn = aws_sqs_queue.imagenes_eliminadas.arn
  function_name = aws_lambda_function.auditoria_eliminaciones.arn
  enabled = true
  batch_size = 1

  scaling_config {
    maximum_concurrency = 2
  }

  depends_on = [
    aws_iam_role_policy.auditoria_eliminaciones
  ]
}