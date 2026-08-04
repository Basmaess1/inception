FROM debian:bookworm

RUN apt update && apt install -y mariadb-client php8.2-fpm php8.2-mysql curl && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -Os https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /run/php

COPY conf/wordpress.cnf /etc/mysql/wordpress.conf.d/config.cnf

COPY tools/wordpress.sh /usr/local/bin/wordpress.sh

RUN chmod +x /usr/local/bin/wordpress.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wordpress.sh"]
