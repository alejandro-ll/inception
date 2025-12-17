.PHONY: all build up down stop re fclean logs ps init-folders

all: up

build: init-folders
	@echo "🔧 Build de imágenes..."
	docker compose -f srcs/docker-compose.yml build

up: init-folders
	@echo "🚀 Levantando servicios..."
	docker compose -f srcs/docker-compose.yml up -d

down:
	@echo "🛑 Apagando servicios y limpiando..."
	docker compose -f srcs/docker-compose.yml down --remove-orphans --volumes

stop:
	@echo "⏸️ Deteniendo contenedores sin eliminar..."
	docker compose -f srcs/docker-compose.yml stop

re: fclean build up

fclean:
	@echo "🧨 [1/6] Parando y eliminando TODOS los contenedores..."
	-@docker rm -f $$(docker ps -aq) 2>/dev/null || true

	@echo "🧼 [2/6] Eliminando todos los volúmenes..."
	-@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

	@echo "🗑️ [3/6] Eliminando todas las imágenes..."
	-@docker rmi -f $$(docker images -aq) 2>/dev/null || true

	@echo "🔌 [4/6] Eliminando redes personalizadas..."
	-@docker network rm $$(docker network ls -q | grep -v bridge | grep -v host | grep -v none) 2>/dev/null || true

	@echo "📂 [5/6] Limpiando carpetas locales (bind mounts)..."
	-@rm -rf ./srcs/mariadb/database/* ./srcs/wordpress/html/* 2>/dev/null || true

	@echo "🚿 [6/6] Prune final del sistema Docker..."
	-@docker system prune -af --volumes

	@echo "✅ Docker Inception limpiado por completo."

logs:
	docker compose -f srcs/docker-compose.yml logs -f

ps:
	docker compose -f srcs/docker-compose.yml ps

init-folders:
	@echo "📂 Creando carpetas de volúmenes en /home/allera-m/data..."
	@sudo mkdir -p /home/allera-m/data/mariadb
	@sudo mkdir -p /home/allera-m/data/wordpress
	@sudo mkdir -p /home/allera-m/data/wp_socket
	@sudo chown -R $(USER):$(USER) /home/allera-m/data
	@sudo chmod -R 755 /home/allera-m/data
	