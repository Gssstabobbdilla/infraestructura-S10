data "archive_file" "trabajador" {
  type             = "zip"
  source_file      = "${path.module}/lambda/trabajador.py"
  output_path      = "${path.module}/lambda/trabajador.zip"
  output_file_mode = "0666"
}