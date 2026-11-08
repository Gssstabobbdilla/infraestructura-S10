resource "aws_iam_role" "validador_imagenes" {
  name = "${var.project_name}-${var.environment}-validador-imagenes"

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
}

resource "aws_iam_role_policy" "validador_imagenes" {
  name = "${var.project_name}-${var.environment}-validador-imagenes"
  role = aws_iam_role.validador_imagenes.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid= "PermitirEscrituraDeLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Sid= "PermitirConsumoColaModeracion"
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.imagen_moderacion.arn
      }
    ]
  })
}