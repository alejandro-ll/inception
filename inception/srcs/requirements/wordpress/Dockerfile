FROM debian:bullseye

RUN apt update && \
    apt install -y php php-fpm php-mysql curl mariadb-client wget unzip && \
    rm -rf /var/lib/apt/lists/*

COPY tools/entrypoint.sh /usr/local/bin/
COPY tools/www.conf /etc/php/7.4/fpm/pool.d/www.conf
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000
ENTRYPOINT ["entrypoint.sh"]

