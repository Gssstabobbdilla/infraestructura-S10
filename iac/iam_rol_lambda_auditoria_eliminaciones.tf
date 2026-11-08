resource "aws_iam_role" "auditoria_eliminaciones" {
  name = "${var.project_name}-${var.environment}-auditoria-eliminaciones"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-auditoria-eliminaciones"
    Role = "ejecucion-lambda-auditoria"
  })
}

resource "aws_iam_role_policy" "auditoria_eliminaciones" {
  name = "${var.project_name}-${var.environment}-auditoria-eliminaciones"
  role = aws_iam_role.auditoria_eliminaciones.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PermitirEscrituraDeLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Sid    = "PermitirConsumoColaEliminaciones"
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.imagenes_eliminadas.arn
      }
    ]
  })
}