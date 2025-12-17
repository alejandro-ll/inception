# User Documentation

## Commands
- **Start:** `make`
- **Stop:** `make stop`
- **Clean (Remove containers/networks):** `make clean`
- **Full Clean (Remove everything including data):** `make fclean`

## Credentials
El sistema utiliza las credenciales definidas en el archivo `.env`. Para la evaluación:
- **WP Admin:** `allera-m-admin`
- **WP User:** `allera-m-user`
- **DB Name:** `inception_db`

## Verification
Para comprobar que los servicios corren correctamente:
`docker-compose -f srcs/docker-compose.yml ps`