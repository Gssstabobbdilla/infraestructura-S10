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