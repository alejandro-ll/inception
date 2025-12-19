#!/bin/sh
set -e

echo "📢 INICIANDO MariaDB..."

# 1. Preparar directorios internos
mkdir -p /var/lib/mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# 2. Inicializar base de datos si es la primera vez
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "🛠️ Base de datos no encontrada. Inicializando..."
    
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Creamos el archivo SQL temporal
    # Usamos EOF sin comillas para que bash expanda las variables $MYSQL_...
    cat << EOF > /tmp/init.sql
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF

    # Ejecutar de forma temporal para aplicar configuración
    # --bootstrap es la forma más limpia en Debian para scripts de inicio
    mysqld --user=mysql --datadir=/var/lib/mysql --bootstrap < /tmp/init.sql
    
    rm -f /tmp/init.sql
    echo "✅ MariaDB configurada y protegida."
else
    echo "✅ Carpeta de datos detectada, saltando inicialización."
fi

# 3. Arranque final (PID 1)
echo "🚀 MariaDB Online y escuchando..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0