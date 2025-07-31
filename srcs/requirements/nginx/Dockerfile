FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 \
  -subj "/C=ES/ST=Madrid/L=Madrid/O=42/OU=Inception/CN=localhost" \
  -newkey rsa:2048 -keyout /etc/nginx/ssl/self.key -out /etc/nginx/ssl/self.crt

COPY default.conf /etc/nginx/sites-available/default
COPY init_nginx.sh /init_nginx.sh
RUN chmod +x /init_nginx.sh

ENTRYPOINT ["/init_nginx.sh"]
