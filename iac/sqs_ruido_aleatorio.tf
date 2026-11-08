resource "aws_sqs_queue" "ruido_aleatorio" {
  name                       = "${var.project_name}-${var.environment}-ruido-aleatorio"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 10

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-ruido-aleatorio"
    Role = "generacion-ruido-aleatorio"
  })
}