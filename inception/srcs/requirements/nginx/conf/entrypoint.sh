#!/bin/bash
set -e

# Generar certificado si no existe
if [ ! -f /etc/ssl/certs/nginx-selfsigned.crt ]; then
  openssl req -x509 -nodes -days 365 \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=Inception/CN=${DOMAIN_NAME}" \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt
fi

nginx -g "daemon off;"
