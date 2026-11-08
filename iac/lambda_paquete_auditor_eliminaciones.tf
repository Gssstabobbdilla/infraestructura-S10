data "archive_file" "auditor_eliminaciones" {
  type = "zip"
  source_file = "${path.module}/lambda/auditor_eliminaciones.py"
  output_path  = "${path.module}/lambda/auditor_eliminaciones.zip"
  output_file_mode = "0666"
}