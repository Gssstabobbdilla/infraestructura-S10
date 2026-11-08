resource "aws_sns_topic" "nuevas_imagenes" {
  name = "${var.project_name}-${var.environment}-nuevas_imagenes"

}