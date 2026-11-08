# Infraestructura - Tarea - Semana 10

El objetivo es comparar los casos de uso de Amazon SNS y Amazon SQS usando un flujo de práctica (distinto del proyecto del curso)

## Enunciado

Complementar con lo siguiente, enfocado en su proyecto:

1. ¿Qué problema resuelve cada servicio?
2. ¿Cuáles son sus tres beneficios principales? administración/costos/vendor lockin/curva de aprendizaje
3. ¿Qué diferencias existen en escalabilidad, disponibilidad?
4. ¿En qué escenario recomendaría el primer servicio y en cuál el segundo?
5. ¿Qué consecuencias técnicas o económicas tendría elegir el servicio incorrecto?
6. Evidencia de uso de cada servicio. Deben tener un despliegue donde se evidencie su servicio + forma de uso (pueden ser peticiones/registros/data). En caso de que el servicio requiera un complemento (ej. Load Balancer que necesita 2 o mas instancias para desplegar) deben tener provisionado y configurado el servicio complementario también. No es necesario que mantengan desplegado el servicio, una vez adjuntas las evidencias pueden eliminar los recursos.

## Objetivos

- Experimentar cómo SNS distribuye un evento a varios consumidores independientes
- Ver cómo SQS retiene trabajos, absorbe picos de carga y permite procesarlos gradualmente
- Hacer una comparación de los escenarios en los que conviene usar cada servicio (aún siendo casi complementarios)

## Componentes Terraform

Los archivos de infraestructura se encuentran en `iac/`.

| Archivo | Propósito |
|---|---|
| `variables.tf` | Variables generales del proyecto y el entorno |
| `s3_input_bucket.tf` | Bucket privado para imagenes de entrada |
| `s3_output_bucket.tf` | Bucket privado para los resulados |

## Componentes de AWS

### Amazon S3

Se utilizan dos buckets privados:

- **Bucket de entrada (`aws_s3_bucket.input`)**: Se encarga de recibir las imágenes originales. Sus eventos de creación y eliminación dan inicio a las notificaciones
- **Bucket de salida (`aws_s3_bucket.output`)**: Se encarga de guardar los resultados del procesamiento. 

Cada bucket tiene un recurso `aws_s3_bucket_public_access_block` asociado. Este bloque deshabilita el acceso público mediante ACL o políticas, para evitar que las imágenes queden expuestas.

### Amazon SNS

Se crearon dos sNS:

- **Imágenes nuevas (`aws_sns_topic.nuevas_imagenes`)**: Recibe los eventos de creación de objetos en el bucket de entrada.
- **Imágenes eliminadas (`aws_sns_topic.eliminadas_imagenes`)**: Recibe eventos de eliminación.

Los recursos `aws_sns_topic_policy` autorizan al servicio S3 a publicar en cada uno. La condición `aws:SourceArn` restringe el permiso al bucket de entrada, en vez de permitir publicaciones desde cualquier bucket.


## Requisitos

- Terraform instalado
- Una cuenta de AWS
- Credenciales de AWS configuradas localmente mediante un perfil o variables de entorno

## Despliegue

Desde la carpeta `iac/`:

```bash
terraform init
terraform plan
terraform apply