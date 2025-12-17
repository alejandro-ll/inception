# User Guide

## Iniciar el proyecto
1. Asegúrate de que [srcs/.env](srcs/.env) contiene las credenciales y dominio deseado.
2. Ejecuta en la raíz del proyecto:
   - make build  (target [`build`](Makefile))
   - make up     (target [`up`](Makefile))

Los servicios levantados:
- mariadb (contenedor `mariadb`)
- wordpress (contenedor `wordpress`)
- nginx (contenedor `nginx`)

## Acceder al sitio
Abre en tu navegador:
- https://allera.42.fr

El certificado es autofirmado (creado por [srcs/requirements/nginx/init_nginx.sh](srcs/requirements/nginx/init_nginx.sh)), acepta la excepción de seguridad en el navegador.

## Gestión de credenciales
Las credenciales se encuentran en [srcs/.env](srcs/.env). Variables importantes:
- BASE DE DATOS: WORDPRESS_DB_NAME, WORDPRESS_DB_USER, WORDPRESS_DB_PASSWORD
- ADMIN WP: WP_ADMIN_USER, WP_ADMIN_PASS, WP_ADMIN_EMAIL

Para cambiar credenciales:
1. Edita [srcs/.env](srcs/.env).
2. Si cambias la base de datos o usuario, es recomendable recrear volúmenes de datos:
   - make down
   - eliminar /home/allera-m/data/mariadb/* y /home/allera-m/data/wordpress/* (con precaución)
   - make up
