import json
import logging
from urllib.parse import unquote_plus

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):
    eliminaciones_registradas = 0

    for registro_sqs in event.get("Records", []):
        envoltura_sns = json.loads(registro_sqs["body"])
        mensaje = envoltura_sns.get("Message", registro_sqs["body"])
        evento_s3 = json.loads(mensaje) if isinstance(mensaje, str) else mensaje

        for registro_s3 in evento_s3.get("Records", []):
            datos_objeto = registro_s3["s3"]["object"]
            bucket = registro_s3["s3"]["bucket"]["name"]
            clave = unquote_plus(datos_objeto["key"])

            logger.info(json.dumps({
                "accion": "objeto_eliminado",
                "bucket": bucket,
                "objeto": clave,
                "evento": registro_s3.get("eventName"),
                "fecha": registro_s3.get("eventTime"),
            }))

            eliminaciones_registradas += 1

    return {"eliminaciones_registradas": eliminaciones_registradas}