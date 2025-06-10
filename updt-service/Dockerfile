FROM alpine
RUN apk add --no-cache curl bash jq
COPY update_cloudflare.sh /update_cloudflare.sh
RUN chmod +x /update_cloudflare.sh
CMD ["/bin/bash", "-c", "while true; do /update_cloudflare.sh; sleep 300; done"]
