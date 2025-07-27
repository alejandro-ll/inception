#!/bin/bash
set -e

if [ ! -f /var/www/html/wp-config.php ]; then
  echo "Instalando WordPress..."
  curl -O https://wordpress.org/latest.tar.gz
  tar -xzf latest.tar.gz
  mv wordpress/* /var/www/html/
  rm -rf wordpress latest.tar.gz

  cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

  sed -i "s/database_name_here/${MYSQL_DATABASE}/" /var/www/html/wp-config.php
  sed -i "s/username_here/${MYSQL_USER}/" /var/www/html/wp-config.php
  sed -i "s/password_here/${MYSQL_PASSWORD}/" /var/www/html/wp-config.php

  chown -R www-data:www-data /var/www/html
fi

mkdir -p /run/php

echo "Iniciando php-fpm7.4..."
php-fpm7.4 --fpm-config /etc/php/7.4/fpm/php-fpm.conf --nodaemonize --force-stderr


