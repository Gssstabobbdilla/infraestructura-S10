resource "aws_lambda_function" "trabajos" {
  function_name = "${var.project_name}-${var.environment}-trabajos"
  role= aws_iam_role.lambda_trabajos.arn
  runtime = "python3.12"
  handler = "trabajador.handler"

  filename = data.archive_file.trabajador.output_path
  source_code_hash = data.archive_file.trabajador.output_base64sha256

  timeout = 30
  memory_size = 128

  environment {
    variables = {
      BUCKET_SALIDA = aws_s3_bucket.output.bucket
    }
  }
}