import json
import logging
from urllib.parse import unquote_plus

logger = logging.getLogger()
logger.setLevel(logging.INFO)

EXTENSIONES_PERMITIDAS = {"jpg", "jpeg", "png", "webp"}


def handler(event, context):
    procesados = 0

    for registro in event.get("Records", []):
        # SNS entrega el evento de S3 dentro del campo "Message".
        envoltura_sns = json.loads(registro["body"])
        mensaje = envoltura_sns.get("Message", registro["body"])
        evento_s3 = json.loads(mensaje) if isinstance(mensaje, str) else mensaje

        for objeto_evento in evento_s3.get("Records", []):
            datos_objeto = objeto_evento["s3"]["object"]
            bucket = objeto_evento["s3"]["bucket"]["name"]
            clave = unquote_plus(datos_objeto["key"])

            extension = clave.rsplit(".", 1)[-1].lower() if "." in clave else ""
            formato_valido = extension in EXTENSIONES_PERMITIDAS

            logger.info(json.dumps({
                "resultado": "formato_valido" if formato_valido else "formato_no_permitido",
                "bucket": bucket,
                "objeto": clave,
                "extension": extension,
                "evento": objeto_evento.get("eventName"),
            }))

            procesados += 1

    return {"objetos_procesados": procesados}