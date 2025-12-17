*This project has been created as part of the 42 curriculum by allera-m.*

# Inception - 42 Madrid

## Description
Este proyecto consiste en la creación de una infraestructura de red pequeña con Docker. Se han configurado contenedores para Nginx (TLS), WordPress+PHP-FPM y MariaDB, asegurando que los servicios solo se comuniquen a través de una red interna y que los datos sean persistentes.

## Instructions
1. Clona este repositorio.
2. Crea el archivo `srcs/.env` basándote en `srcs/.env.example`.
3. Ejecuta `make` en la raíz.
4. Accede a `https://allera-m.42.fr`.

## Resources & AI
- **Recursos:** Documentación oficial de Docker, manuales de Nginx y WP-CLI.
- **Uso de IA:** Se ha utilizado ChatGPT/Gemini para la depuración del Makefile y para entender la implementación de volúmenes con `driver_opts`.

## Technical Comparisons
### VM vs Docker
- **VM:** Virtualiza el hardware completo. Cada instancia tiene su propio Kernel, lo que consume más recursos pero ofrece aislamiento total.
- **Docker:** Virtualiza el Sistema Operativo (OS-level). Comparte el Kernel del host, lo que lo hace mucho más ligero y rápido de arrancar.

### Docker Secrets vs Environment Variables
- **Env Variables:** Son fáciles de configurar pero visibles en comandos como `docker inspect`.
- **Secrets:** (Utilizados en este proyecto para v5.0) Son más seguros ya que no se almacenan en la imagen y solo son accesibles por el servicio en tiempo de ejecución.

### Docker Volumes vs Bind Mounts
- **Volumes:** Gestionados totalmente por Docker en `/var/lib/docker/`. Son mejores para backups.
- **Bind Mounts:** Mapean un directorio específico del host (ej. `/home/allera-m/data`). Es lo que pide este proyecto para garantizar que el usuario tenga control físico de los datos.