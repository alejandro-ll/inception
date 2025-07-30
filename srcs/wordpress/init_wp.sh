#!/bin/bash
set -e

# Instala WordPress si no existe
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Descargando WordPress..."
    wp core download --path=/var/www/html --allow-root
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
fi

echo "Arrancando PHP-FPM..."
exec php-fpm7.4 -F
