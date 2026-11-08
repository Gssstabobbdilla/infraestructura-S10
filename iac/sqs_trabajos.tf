resource "aws_sqs_queue" "trabajos" {
  name = "${var.project_name}-${var.environment}-trabajos"
  visibility_timeout_seconds = 180
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

resource "aws_lambda_event_source_mapping" "trabajos" {
  event_source_arn = aws_sqs_queue.trabajos.arn
  function_name = aws_lambda_function.trabajos.arn
  enabled = true
  batch_size = 1

  scaling_config {
    maximum_concurrency = 2
  }
}