import logging
import os
import random
import struct
import zlib

import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3 = boto3.client("s3")
BUCKET_SALIDA = os.environ["BUCKET_SALIDA"]


def crear_chunk_png(tipo, datos):
    contenido = tipo + datos
    crc = zlib.crc32(contenido) & 0xFFFFFFFF
    return (
        struct.pack(">I", len(datos))
        + contenido
        + struct.pack(">I", crc)
    )


def crear_imagen_ruido(ancho=256, alto=256):
    filas = []

    for _ in range(alto):
        # El byte inicial indica que la fila usa el filtro PNG "None".
        pixeles = random.randbytes(ancho)
        filas.append(b"\x00" + pixeles)

    encabezado = struct.pack(
        ">IIBBBBB",
        ancho,
        alto,
        8,  # profundidad de color
        0,  # escala de grises
        0,  # compresión estándar
        0,  # filtro estándar
        0,  # sin entrelazado
    )

    return (
        b"\x89PNG\r\n\x1a\n"
        + crear_chunk_png(b"IHDR", encabezado)
        + crear_chunk_png(b"IDAT", zlib.compress(b"".join(filas)))
        + crear_chunk_png(b"IEND", b"")
    )


def handler(event, context):
    registros = event.get("Records", [])

    for registro in registros:
        mensaje_id = registro["messageId"]
        clave = f"ruido-aleatorio/{mensaje_id}.png"
        imagen = crear_imagen_ruido()

        s3.put_object(
            Bucket=BUCKET_SALIDA,
            Key=clave,
            Body=imagen,
            ContentType="image/png",
        )

        logger.info(
            "Imagen PNG generada y guardada en s3://%s/%s",
            BUCKET_SALIDA,
            clave,
        )

    return {"procesados": len(registros)}