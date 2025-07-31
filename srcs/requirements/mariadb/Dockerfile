FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server mariadb-client \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/mysql/*

COPY my.cnf /etc/mysql/my.cnf
COPY init_db.sh /init_db.sh
RUN chmod +x /init_db.sh

ENTRYPOINT ["/init_db.sh"]
