# 🌐 Cloudflare Updater

Este serviço containerizado atualiza automaticamente o IP público da sua máquina no DNS da Cloudflare — ideal para conexões com IP dinâmico.

---

## 📁 Estrutura do projeto

```
.
├── docker-compose.yml
└── updt-service/
    ├── Dockerfile
    ├── update_cloudflare.sh
    |── .env.example    # Modelo de configuração
    └── .env            # Arquivo com suas credenciais reais (NÃO versionar)
```

---

## ⚙️ Pré-requisitos

- Docker instalado
- Docker Compose instalado
- Token da API do Cloudflare
- Zone ID, Record ID e subdomínio DNS configurado

---

## 🔐 Variáveis de ambiente

Crie um arquivo `.env` no diretório/pasta "updt-service/" com as seguintes variáveis (baseado no `.env.example`):

```env
CLOUDFLARE_API_TOKEN=seu_token_aqui
CLOUDFLARE_ZONE_ID=zone_id
CLOUDFLARE_RECORD_ID=record_id
CLOUDFLARE_RECORD_NAME=subdominio.seudominio.com
```

---

## 🛠️ Build do container

Para construir a imagem do serviço `updt-service`:

```bash
docker-compose build
```

---

## 🚀 Executar o serviço

Após o build, execute o container:

```bash
docker-compose up -d
```

O script será executado a cada 5 minutos (configurado no `Dockerfile` via `sleep 300`).

---

## 🔍 Verificar logs

Para acompanhar os logs e verificar se a atualização está funcionando (caso o IP esteja correto, não será logado nada):

```bash
docker-compose logs -f updt-service
```

---

## 🛑 Parar e remover os containers

```bash
docker-compose down
```

---

## 📦 Rebuild (caso altere o Dockerfile ou o script)

```bash
docker-compose build updt-service
docker-compose up -d
```

---

## Se quiser gerar uma imagem para uma outra plataforma, como Raspberry Pi, rode:
```bash
./build_for_raspberrypi.sh
````
# Depois copie a imagem gerada e o arquivo .env para o Raspberry Pi e carregue-a lá:
```bash
docker load -i ${TAR_FILE}
docker run -d \
  --name updt-service \
  --env-file /home/${USER}/.env \
  --restart always \
  updt-service-arm
```


## 📁 Licença

Este projeto é fornecido como está, sem garantias. Verifique as permissões da sua conta Cloudflare para tokens de API.
