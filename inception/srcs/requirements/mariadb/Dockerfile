FROM debian:bullseye

RUN apt update && \
    apt install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306
ENTRYPOINT ["entrypoint.sh"]
