#!/bin/bash
set -e

# Crear certificados SSL si no existen
SSL_DIR="/etc/nginx/ssl"
mkdir -p $SSL_DIR

if [ ! -f "$SSL_DIR/server.crt" ] || [ ! -f "$SSL_DIR/server.key" ]; then
  echo "Generando certificados SSL autofirmados..."
  openssl req -x509 -nodes -days 365 \
    -subj "/CN=allera-m.42.fr" \
    -newkey rsa:2048 \
    -keyout "$SSL_DIR/server.key" \
    -out "$SSL_DIR/server.crt"
fi

echo "Iniciando NGINX con SSL..."
exec nginx -g "daemon off;"
