#!/bin/bash
set -e

WP_PATH="/var/www/html"

# Esperar hasta que MariaDB acepte conexiones (no solo "ping")
echo "⏳ Esperando a MariaDB (${WORDPRESS_DB_HOST})..."
until mysqladmin ping -h"${WORDPRESS_DB_HOST}" --silent; do
  echo "⌛ MariaDB aún no responde..."
  sleep 2
done
echo "✅ MariaDB está disponible."

# Si hay archivos de WordPress pero falta wp-config.php, probablemente está corrupto
if [ -f "${WP_PATH}/index.php" ] && [ ! -f "${WP_PATH}/wp-config.php" ]; then
    echo "⚠️ Instalación corrupta detectada (archivos sin wp-config.php)."
    echo "🧹 Borrando solo archivos de WordPress, dejando volumen limpio..."
    find "$WP_PATH" -mindepth 1 -delete
fi

# Si WordPress no está instalado aún, hacer instalación limpia
if ! wp core is-installed --path="$WP_PATH" --allow-root; then
    echo "📥 Descargando WordPress..."
    wp core download --path="$WP_PATH" --allow-root

    echo "⚙️ Generando wp-config.php..."
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --path="$WP_PATH" \
        --allow-root

    echo "🧱 Instalando WordPress..."
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception WP Site" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path="$WP_PATH" \
        --allow-root

    echo "👤 Creando segundo usuario..."
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASS" \
        --role=subscriber \
        --path="$WP_PATH" \
        --allow-root

    echo "✅ WordPress instalado con dos usuarios."
else
    echo "🔁 WordPress ya está instalado, saltando instalación."
fi

chown -R www-data:www-data "$WP_PATH"
chmod -R 755 "$WP_PATH"

echo "🚀 Arrancando PHP-FPM..."
exec php-fpm7.4 -F
