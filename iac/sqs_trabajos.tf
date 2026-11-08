resource "aws_sqs_queue" "trabajos" {
  name = "${var.project_name}-${var.environment}-trabajos"
  visibility_timeout_seconds = 60
  message_retention_seconds= 86400
  receive_wait_time_seconds = 10

}

redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.mensajes_fallidos.arn
    maxReceiveCount = 3
})

redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue"
    sourceQueueArns = [aws_sqs_queue.trabajos.arn]
})