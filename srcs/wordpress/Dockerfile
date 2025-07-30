FROM debian:bullseye

RUN apt-get update && apt-get install -y \
  php7.4-fpm php7.4-mysql php7.4-cli php7.4-mbstring \
  php7.4-curl php7.4-xml php7.4-gd php7.4-zip php7.4-soap \
  php7.4-intl php7.4-bcmath mariadb-client curl unzip \
  && apt-get clean

# Instalar WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copiar script de inicialización y configuración PHP-FPM
COPY init_wp.sh /init_wp.sh
COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf

RUN chmod +x /init_wp.sh

ENTRYPOINT ["/init_wp.sh"]
