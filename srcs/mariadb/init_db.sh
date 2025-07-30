#!/bin/bash
set -e

echo "📢 INICIANDO init_db.sh como ENTRYPOINT"
env | grep MYSQL

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d /var/lib/mysql/mysql ]; then
  echo "🛠️ Inicializando sistema de bases de datos..."
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql

  echo "🚀 FASE 1: Arrancando MariaDB temporalmente sin permisos..."
  mysqld_safe --datadir=/var/lib/mysql --skip-networking --skip-grant-tables &
  pid="$!"

  for i in {30..30}; do
    if [ -S /run/mysqld/mysqld.sock ]; then
      echo "✅ Socket disponible."
      break
    fi
    sleep 1
  done
  sleep 2

  echo "📦 FASE 1: Crear solo la base de datos..."
  unset MYSQL_HOST
  mysql -u root -S /run/mysqld/mysqld.sock <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8 COLLATE utf8_general_ci;
EOSQL

  echo "🛑 FASE 1: Apagando MariaDB temporal..."
  mysqladmin -S /run/mysqld/mysqld.sock shutdown || kill "$pid"
  sleep 2

  echo "🚀 FASE 2: Arrancando MariaDB con privilegios activos..."
  mysqld_safe --datadir=/var/lib/mysql &
  pid="$!"

  for i in {30..0}; do
    if mysqladmin ping --silent; then
      echo "✅ MariaDB con permisos activos."
      break
    fi
    sleep 1
  done
  sleep 2

  echo "🔐 FASE 2: Crear usuarios y privilegios..."
  unset MYSQL_HOST
  mysql -u root -S /run/mysqld/mysqld.sock <<-EOSQL
    -- Usuario WordPress con acceso desde fuera
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

    -- Usuario WordPress para acceso local por socket (debug o admin)
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'localhost';

    -- Usuario root por red y por localhost
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

    FLUSH PRIVILEGES;
EOSQL

  echo "🛑 FASE 2: Apagando MariaDB temporal..."
  mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" -S /run/mysqld/mysqld.sock shutdown || kill "$pid"
  sleep 2
else
  echo "✅ MariaDB ya está inicializada, saltando setup."
fi

echo "📡 Lanzando MariaDB en primer plano..."
exec mysqld_safe --datadir=/var/lib/mysql
