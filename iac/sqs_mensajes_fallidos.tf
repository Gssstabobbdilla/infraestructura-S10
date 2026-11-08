resource "aws_sqs_queue" "mensajes_fallidos" {
  name = "${var.project_name}-${var.environment}-trabajos-fallidos"
  message_retention_seconds = 1209600
}

resource "aws_sqs_queue_redrive_allow_policy" "trabajos_dlp" {
  queue_url = aws_sqs_queue.mensajes_fallidos.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue"
    sourceQueueArns   = [aws_sqs_queue.trabajos.arn]
  })
}