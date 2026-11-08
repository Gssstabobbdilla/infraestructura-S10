data "archive_file" "validador_imagenes" {
  type             = "zip"
  source_file      = "${path.module}/lambda/validador_imagenes.py"
  output_path      = "${path.module}/lambda/validador_imagenes.zip"
  output_file_mode = "0666"
}