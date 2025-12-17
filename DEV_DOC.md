# Developer Documentation

## Infrastructure
- **Network:** Red tipo `bridge` llamada `inception`. Solo Nginx expone el puerto 443.
- **Images:** Basadas en Debian (Buster/Bullseye) para estabilidad.

## Testing MariaDB (Evaluation Step)
Para cumplir con la hoja de evaluación, se puede entrar al contenedor de la base de datos para verificar que no hay acceso root remoto:
1. `docker exec -it mariadb mysql -u root -p`
2. Introducir la contraseña de `MYSQL_ROOT_PASSWORD`.
3. Ejecutar `SHOW DATABASES;` para ver la base de datos de WordPress.

## Data Persistence
Los volúmenes están bindeados a:
- DB: `/home/allera-m/data/mariadb`
- WP: `/home/allera-m/data/wordpress`

Si se borran los contenedores con `make stop`, los archivos en estas rutas **permanecen intactos**. Solo `make fclean` elimina estos directorios.