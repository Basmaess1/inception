FROM debian:bookworm

RUN apt update && apt install -y mariadb-server && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*


COPY conf/mariadb.cnf /etc/mysql/mariadb.conf.d/config.cnf

COPY tools/mariadb.sh /usr/local/bin/mariadb.sh

RUN chmod +x /usr/local/bin/mariadb.sh

EXPOSE 3306


ENTRYPOINT ["/usr/local/bin/mariadb.sh"]

