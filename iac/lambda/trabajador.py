import json
import logging
import random

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):
    registros = event.get("Records", [])

    for registro in registros:
        cuerpo = registro.get("body", "{}")

        try:
            mensaje = json.loads(cuerpo)
        except json.JSONDecodeError:
            mensaje = {"contenido": cuerpo}

        ruido = [round(random.uniform(-1, 1), 4) for _ in range(10)]

        logger.info(json.dumps({
            "mensaje_id": registro.get("messageId"),
            "ruido_generado": ruido
        }))

    return {"procesados": len(registros)}