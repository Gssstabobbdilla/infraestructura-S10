resource "aws_lambda_function" "auditoria_eliminaciones" {
  function_name = "${var.project_name}-${var.environment}-auditoria-eliminaciones"
  role = aws_iam_role.auditoria_eliminaciones.arn
  runtime  = "python3.12"
  handler = "auditor_eliminaciones.handler"

  filename= data.archive_file.auditor_eliminaciones.output_path
  source_code_hash = data.archive_file.auditor_eliminaciones.output_base64sha256

  timeout= 30
  memory_size = 128
}