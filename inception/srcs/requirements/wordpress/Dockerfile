FROM debian:bullseye

ARG DEBIAN_FRONTEND=noninteractive

# Instalar PHP, PHP-FPM y extensiones necesarias para WordPress
RUN apt-get update && \
    apt-get install -y php php-fpm php-mysql wget unzip curl mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Crear carpeta para WordPress
RUN mkdir -p /var/www/html

# Descargar y descomprimir WordPress
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    cp -r wordpress/* /var/www/html/ && \
    chown -R www-data:www-data /var/www/html && \
    rm -rf latest.tar.gz wordpress

EXPOSE 9000

CMD ["php-fpm", "-F"]
