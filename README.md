*This project has been created as part of the 42 curriculum by allera-m.*

# Description
Proyecto "Inception" (v5.0, inspirado en Capítulos VI y VII). Contenedor multi-servicio que levanta MariaDB, WordPress y NGINX con SSL autofirmado. Estructura principal en [srcs/](srcs/).

# Instructions
1. Configura las variables en [srcs/.env](srcs/.env).
2. Crea las carpetas de persistencia si tu Makefile no las crea automáticamente (el Makefile ya las crea en /home/allera-m/data/):
   - /home/allera-m/data/mariadb
   - /home/allera-m/data/wordpress
   - /home/allera-m/data/wp_socket
3. Construye y arranca usando Make:
   - make build — ejecuta el target [`build`](Makefile)
   - make up — ejecuta el target [`up`](Makefile)
   - make down — ejecuta el target [`down`](Makefile)

Servicios y archivos relevantes:
- Orquestación: [srcs/docker-compose.yml](srcs/docker-compose.yml)
- Variables de entorno: [srcs/.env](srcs/.env)
- MariaDB: [srcs/requirements/mariadb/Dockerfile](srcs/requirements/mariadb/Dockerfile), [srcs/requirements/mariadb/init_db.sh](srcs/requirements/mariadb/init_db.sh)
- WordPress: [srcs/requirements/wordpress/Dockerfile](srcs/requirements/wordpress/Dockerfile), [srcs/requirements/wordpress/init_wp.sh](srcs/requirements/wordpress/init_wp.sh)
- NGINX: [srcs/requirements/nginx/Dockerfile](srcs/requirements/nginx/Dockerfile), [srcs/requirements/nginx/init_nginx.sh](srcs/requirements/nginx/init_nginx.sh)

# Resources

## Uso de IA
Se utilizó asistencia de IA para:
- Depurar y simplificar el contenido del [`Makefile`](Makefile).
- Recomendar la configuración de volúmenes bind en [srcs/docker-compose.yml](srcs/docker-compose.yml) para persistencia en el host (/home/allera-m/data/).
La IA se empleó como herramienta de revisión y sugerencia; las decisiones finales fueron validadas manualmente.

## Tablas comparativas

### VM vs Docker
| Concepto | VM | Docker |
|---|---:|:---|
| Aislamiento | Sistema operativo completo | Contenedores sobre el kernel del host |
| Tamaño | Pesado | Ligero |
| Arranque | Lento | Rápido |
| Uso típico | Entornos aislados de infra | Microservicios y despliegues rápidos |

### Secrets vs Env Variables
| Aspecto | Secrets | Env Variables |
|---|---:|---:|
| Seguridad | Mejor (almacenamiento cifrado) | Expuestas en ficheros y procesos |
| Uso en Docker | Docker Secrets / Vault | .env / env_file (ej. [srcs/.env](srcs/.env)) |
| Recomendado para | Credenciales sensibles | Configuración no crítica |

### Docker Network vs Host
| Aspecto | Docker Network (bridge) | Host |
|---|---:|---:|
| Aislamiento | Sí (subred privada) | No (usa red host) |
| Conflictos de puerto | Menor | Riesgo mayor |
| Uso en este proyecto | [`inception` bridge](srcs/docker-compose.yml) | No usado |

### Volumes vs Bind Mounts
| Aspecto | Volumes Docker | Bind Mounts |
|---|---:|---:|
| Gestión | Docker gestiona | Host controla ruta (ej. /home/allera-m/data) |
| Rendimiento | Optimizado para Docker | Depende del FS del host |
| Uso en este proyecto | Bind mounts definidos en [srcs/docker-compose.yml](srcs/docker-compose.yml) apuntando a /home/allera-m/data |
