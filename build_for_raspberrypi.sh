#!/bin/bash

# Configurações
IMAGE_NAME=cloudflare-updater-arm
DOCKERFILE_DIR=./updt-service
TAR_FILE=${IMAGE_NAME}.tar

# 1. Cria e usa builder (se ainda não existir)
docker buildx create --name rpi-builder --use 2>/dev/null || docker buildx use rpi-builder
docker buildx inspect --bootstrap

# 2. Build da imagem para Raspberry Pi (ARMv7)
echo "🛠️  Construindo imagem Docker para ARM..."
docker buildx build --platform linux/arm/v7 -t $IMAGE_NAME $DOCKERFILE_DIR --load

# 3. Exporta a imagem para um arquivo .tar
echo "📦 Salvando imagem para $TAR_FILE..."
docker save -o $TAR_FILE $IMAGE_NAME



# 5. (Opcional) Conecta no Raspberry e executa docker load
# scp $TAR_FILE ${RASPBERRY_USER}@${RASPBERRY_IP}:${RASPBERRY_DEST}/
#echo "🚀 Carregando imagem no Raspberry Pi..."
#ssh ${RASPBERRY_USER}@${RASPBERRY_IP} "docker load -i ${RASPBERRY_DEST}/${TAR_FILE} && rm ${RASPBERRY_DEST}/${TAR_FILE}"

echo "✅ Processo completo! Agora você pode rodar carregar a imagem no Raspberry Pi."