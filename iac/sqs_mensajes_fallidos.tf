resource "aws_sqs_queue" "mensajes_fallidos" {
  name = "${var.project_name}-${var.environment}-trabajos-fallidos"
  message_retention_seconds = 1209600

}