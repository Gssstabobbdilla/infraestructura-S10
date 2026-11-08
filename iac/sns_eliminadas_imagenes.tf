resource "aws_sns_topic" "deleted_images" {
  name = "${var.project_name}-${var.environment}-eliminadas_imagenes"

}