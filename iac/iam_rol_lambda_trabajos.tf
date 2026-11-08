resource "aws_iam_role" "lambda_trabajos" {
  name = "${var.project_name}-${var.environment}-lambda-trabajos"

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

resource "aws_iam_role_policy" "lambda_trabajos" {
  name = "${var.project_name}-${var.environment}-lambda-trabajos"
  role = aws_iam_role.lambda_trabajos.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PermitirEscrituraDeLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Sid = "PermitirConsumoDeCola"
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource =[
          aws_sqs_queue.trabajos.arn,
          aws_sqs_queue.ruido_aleatorio.arn
        ] 
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_escritura_s3" {
  name = "${var.project_name}-${var.environment}-lambda-escritura-s3"
  role = aws_iam_role.lambda_trabajos.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "PermitirGuardarImagenesDeRuido"
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = "${aws_s3_bucket.output.arn}/ruido-aleatorio/*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_cola_ruido" {
  name = "${var.project_name}-${var.environment}-lambda-cola-ruido"
  role = aws_iam_role.lambda_trabajos.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PermitirConsumoColaRuido"
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.ruido_aleatorio.arn
      }
    ]
  })
}