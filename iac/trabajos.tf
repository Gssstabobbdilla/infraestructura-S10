resource "aws_sqs_queue" "trabajos" {
  name = "${var.project_name}-${var.environment}-trabajos"
  visibility_timeout_seconds = 60
  message_retention_seconds= 86400
  receive_wait_time_seconds = 10

}
