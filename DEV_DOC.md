# Developer Documentation

## Configuración desde cero
1. Clona el repositorio y sitúate en la raíz del proyecto.
2. Revisa y adapta [srcs/.env](srcs/.env) con tus valores (BD, usuario, dominio).
3. Asegura permisos en la carpeta host de persistencia: /home/allera-m/data/
   - El Makefile crea y fija permisos con el target [`init-folders`](Makefile).
4. Construye y levanta:
   - make build
   - make up

## Uso del Makefile
Targets principales:
- [`init-folders`](Makefile): crea /home/allera-m/data/* y ajusta permisos.
- [`build`](Makefile): construye imágenes con docker compose -f srcs/docker-compose.yml build
- [`up`](Makefile): levanta los servicios en background
- [`down`](Makefile): detiene y elimina servicios y volúmenes
- [`fclean`](Makefile): limpieza agresiva del entorno Docker

Consulta el [Makefile](Makefile) para los detalles exactos de cada target.

## Persistencia de datos
Los datos persistentes se montan en el host en:
- /home/allera-m/data/mariadb -> contiene /var/lib/mysql en el contenedor (volumen bind)
- /home/allera-m/data/wordpress -> contiene /var/www/html en el contenedor (volumen bind)
- /home/allera-m/data/wp_socket -> socket PHP-FPM (/run/php) compartido entre WP y NGINX

Estas rutas están definidas en [srcs/docker-compose.yml](srcs/docker-compose.yml).

## Scripts y puntos de entrada
- MariaDB: [srcs/requirements/mariadb/init_db.sh](srcs/requirements/mariadb/init_db.sh) (ENTRYPOINT)
- WordPress: [srcs/requirements/wordpress/init_wp.sh](srcs/requirements/wordpress/init_wp.sh) (ENTRYPOINT) — usa WP-CLI para instalación automática.
- NGINX: [srcs/requirements/nginx/init_nginx.sh](srcs/requirements/nginx/init_nginx.sh)

## Notas de desarrollo
- SSL es autofirmado; en producción usar certificados válidos.
- Las credenciales sensibles deberían migrarse a un gestor de secretos en lugar de [srcs/.env](srcs/.env).
- Para depuración rápida, revisa logs con: docker compose -f srcs/docker-compose.yml logs -f (o usa targets [`logs`](Makefile)