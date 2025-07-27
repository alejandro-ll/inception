#!/bin/bash
set -e

# Lanzar mysqld en segundo plano (necesario para usar mysql -e luego)
mysqld_safe --skip-networking &
sleep 5

# Inicializar DB si no existe
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
  echo "Inicializando base de datos..."
  mysql -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL
fi

# Llevar mysqld al foreground
wait %1

