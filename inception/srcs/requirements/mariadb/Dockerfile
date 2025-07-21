FROM debian:bullseye

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3306

CMD ["mysqld_safe"]
