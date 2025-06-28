#!/bin/bash

# Requer as variáveis de ambiente:
# - CLOUDFLARE_API_TOKEN
# - CLOUDFLARE_ZONE_ID
# - CLOUDFLARE_RECORD_ID
# - CLOUDFLARE_RECORD_NAME

# echo "Script iniciado: $(date '+%Y-%m-%d %H:%M:%S')"
# env | grep CLOUDFLARE

# É preciso do ZONE ID e do RECORD ID do seu domínio, que podem ser obtidos via API ou no painel da Cloudflare.
# O jq é usado para processar JSON. Se não tiver instalado: sudo apt install jq (Ubuntu/Debian).
# Certifique-se de que seu API Token tem permissão para editar DNS.


# Verificar se as variáveis de ambiente necessárias estão definidas
if [ -z "$CLOUDFLARE_API_TOKEN" ] || [ -z "$CLOUDFLARE_ZONE_ID" ] || [ -z "$CLOUDFLARE_RECORD_ID" ] || [ -z "$CLOUDFLARE_RECORD_NAME" ] || [ -z "$MINECRAFT_RECORD_ID" ]; then
  echo "Erro: Variáveis de ambiente CLOUDFLARE_API_TOKEN, CLOUDFLARE_ZONE_ID, CLOUDFLARE_RECORD_ID e CLOUDFLARE_RECORD_NAME e MINECRAFT_RECORD_ID devem estar definidas."
  exit 1
fi
# Definir variáveis de ambiente
RECORD_ID=$(echo "$CLOUDFLARE_RECORD_ID" | tr -d '"')
ZONE_ID=$(echo "$CLOUDFLARE_ZONE_ID" | tr -d '"')
API_TOKEN=$(echo "$CLOUDFLARE_API_TOKEN" | tr -d '"')
DNS_NAME=$(echo "$CLOUDFLARE_RECORD_NAME" | tr -d '"')
MINECRAFT_ID=$(echo "$MINECRAFT_RECORD_ID" | tr -d '"')

# Verificar se o jq está instalado
if ! command -v jq &> /dev/null; then
  echo "Erro: jq não está instalado. Por favor, instale o jq para processar JSON."
  exit 1
fi
# Verificar se o curl está instalado
if ! command -v curl &> /dev/null; then
  echo "Erro: curl não está instalado. Por favor, instale o curl para fazer requisições HTTP."
  exit 1
fi

# Obter IP público atual (via ipify)
IP=$(curl -s https://api.ipify.org)
# IP=$(curl -s http://ipv4.icanhazip.com)
# echo "IP atual: $IP"

# Obter IP atual armazenado no Cloudflare (para evitar updates desnecessários)
CURRENT_IP=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
  -H "Authorization: Bearer $API_TOKEN" \
  -H "Content-Type: application/json" | jq -r .result.content)
# echo "IP armazenado no Cloudflare: $CURRENT_IP"

# Comparar e atualizar se for diferente
if [ "$IP" != "$CURRENT_IP" ]; then
  echo "Atualizando IP: $CURRENT_IP -> $IP"
  echo "Data e hora atual: $(date '+%Y-%m-%d %H:%M:%S')"
  RESPONSE=$(curl -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
    -H "Authorization: Bearer $API_TOKEN" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$DNS_NAME\",\"content\":\"$IP\",\"ttl\":120,\"proxied\":true}")
  echo "Cloudflare response: $RESPONSE"

  echo "Atualizando IP do Minecraft: $CURRENT_IP -> $IP"
  echo "Data e hora atual: $(date '+%Y-%m-%d %H:%M:%S')"
  RESPONSE=$(curl -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$MINECRAFT_ID" \
    -H "Authorization: Bearer $API_TOKEN" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"minecraft\",\"content\":\"$IP\",\"ttl\":120,\"proxied\":false}")
  echo "Cloudflare response: $RESPONSE"
#else
#  echo "O IP não mudou. Nenhuma atualização necessária."
fi
