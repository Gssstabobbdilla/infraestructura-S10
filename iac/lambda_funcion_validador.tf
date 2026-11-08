resource "aws_lambda_function" "validador_imagenes" {
  function_name = "${var.project_name}-${var.environment}-validador-imagenes"
  role = aws_iam_role.validador_imagenes.arn
  runtime = "python3.12"
  handler = "validador_imagenes.handler"

  filename = data.archive_file.validador_imagenes.output_path
  source_code_hash = data.archive_file.validador_imagenes.output_base64sha256

  timeout= 30
  memory_size = 128

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-validador-imagenes"
    Role = "validacion-de-imagenes"
  })
}