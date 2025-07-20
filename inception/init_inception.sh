#!/bin/bash

# Nombre base del proyecto
PROJECT_NAME="inception"

echo "📁 Creando estructura base de '$PROJECT_NAME'..."

# Crear carpetas obligatorias
mkdir -p $PROJECT_NAME/{secrets,srcs/requirements/{nginx/conf,wordpress/tools,mariadb/tools}}

# Archivos clave
touch $PROJECT_NAME/Makefile
touch $PROJECT_NAME/srcs/.env
touch $PROJECT_NAME/srcs/docker-compose.yml

# Dockerfiles por servicio obligatorio
touch $PROJECT_NAME/srcs/requirements/nginx/Dockerfile
touch $PROJECT_NAME/srcs/requirements/wordpress/Dockerfile
touch $PROJECT_NAME/srcs/requirements/mariadb/Dockerfile

# Configuración y scripts obligatorios
touch $PROJECT_NAME/srcs/requirements/nginx/conf/nginx.conf
touch $PROJECT_NAME/srcs/requirements/mariadb/tools/init.sql

# Ignorar secrets en Git
echo "/secrets/*" > $PROJECT_NAME/.gitignore
echo "/srcs/.env" >> $PROJECT_NAME/.gitignore

echo "✅ Estructura creada correctamente."