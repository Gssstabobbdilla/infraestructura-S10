resource "aws_sqs_queue" "moderacion_imagen" {
  name = "${var.project_name}-${var.environment}-moderacion_imagen"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 10
}