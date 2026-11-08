resource "aws_sqs_queue" "imagenes_eliminadas" {
  name = "${var.project_name}-${var.environment}-imagenes-eliminadas"
  visibility_timeout_seconds = 180
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 10

}