#!/bin/bash
set -e

# 1. Preparar el directorio del socket
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

DB_DIR="/var/lib/mysql/${MYSQL_DATABASE}"

# 2. Inicialización solo una vez
if [ ! -d /var/lib/mysql/mysql ]; then
  echo "Preparando directorio de datos..."
  mariadb-install-db --datadir=/var/lib/mysql

  echo "Iniciando servidor temporal para crear DB/usuario..."
  mysqld_safe --skip-networking --skip-grant-tables &
  pid="$!"
  echo "Esperando servidor..."
  sleep 5

  echo "Esperando socket..."
  for i in {1..30}; do
    [ -S /run/mysqld/mysqld.sock ] && break
    echo " ."; sleep 1
  done

  echo "Creando base de datos y usuario..."
  mysql --protocol=socket -S /run/mysqld/mysqld.sock <<-EOSQL
    FLUSH PRIVILEGES;
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

  echo "Apagando servidor temporal..."
  kill "$pid"; wait "$pid"
fi

echo "✅ Lanzando servidor final en primer plano..."
exec mysqld_safe
