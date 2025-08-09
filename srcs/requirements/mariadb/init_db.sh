#!/bin/bash
set -e

echo "📢 INICIANDO init_db.sh como ENTRYPOINT"
env | grep MYSQL || true

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d /var/lib/mysql/mysql ]; then
  echo "🛠️ Inicializando sistema de bases de datos..."
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql

  echo "🚀 FASE 1: Arrancando MariaDB temporalmente sin permisos..."
  mysqld_safe --datadir=/var/lib/mysql --skip-networking --skip-grant-tables &
  pid="$!"

  # Esperar al socket
  for i in {30..0}; do
    if [ -S /run/mysqld/mysqld.sock ]; then
      echo "✅ Socket disponible."
      break
    fi
    sleep 1
  done
  sleep 2

  echo "📦 FASE 1: Crear solo la base de datos (sin grants aún)..."
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

  # Esperar a que responda
  for i in {30..0}; do
    if mysqladmin -S /run/mysqld/mysqld.sock ping --silent; then
      echo "✅ MariaDB con permisos activos."
      break
    fi
    sleep 1
  done
  sleep 2

  echo "🔐 FASE 2: Usuarios y privilegios (forzando password, sin unix_socket)..."
  unset MYSQL_HOST
  mysql -u root -S /run/mysqld/mysqld.sock <<-EOSQL
    -- Asegurar BD (por si FASE 1 se saltó)
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8 COLLATE utf8_general_ci;

    -- Usuario de aplicación: solo TCP (desde cualquier host)
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MYSQL_PASSWORD}');
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

    -- Root SIEMPRE con contraseña (tanto localhost como %)
    ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MYSQL_ROOT_PASSWORD}');
    CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MYSQL_ROOT_PASSWORD}');
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

    -- Limpiar usuarios anónimos si existen
    DROP USER IF EXISTS ''@'localhost';
    DROP USER IF EXISTS ''@'%';

    FLUSH PRIVILEGES;
EOSQL

  echo "🧹 Desinstalando plugin de autenticación por socket (si existe)..."
  # En algunas versiones el nombre es 'unix_socket', en otras el SONAME 'auth_socket'
  mysql -u root -S /run/mysqld/mysqld.sock <<-EOSQL || true
    UNINSTALL PLUGIN unix_socket;
    FLUSH PRIVILEGES;
EOSQL
  mysql -u root -S /run/mysqld/mysqld.sock <<-EOSQL || true
    UNINSTALL SONAME 'auth_socket';
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
