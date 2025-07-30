FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server mariadb-client \
    && rm -rf /var/lib/apt/lists/*

COPY init_db.sh /init_db.sh
RUN chmod +x /init_db.sh

ENTRYPOINT ["/init_db.sh"]
