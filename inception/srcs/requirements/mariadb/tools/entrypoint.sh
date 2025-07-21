#!/bin/bash
set -e

service mysql start

# Inicializar DB si no existe
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
  echo "Inicializando base de datos..."
  mysql -e "CREATE DATABASE ${MYSQL_DATABASE};"
  mysql -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
  mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
  mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
  mysql -e "FLUSH PRIVILEGES;"
fi

exec mysqld_safe
