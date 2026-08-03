#!/bin/bash
set -e

MYSQL_PASS=$(cat $WORDPRESS_DB_PASSWORD_FILE)
MYSQL_ROOT_PASS=$(cat $WORDPRESS_DB_ROOT_PASSWORD_FILE)


mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    # Start service temporarily to execute setup commands
    service mariadb start

    # Wait for MariaDB to be ready
    until mariadb-admin ping --silent; do
        sleep 1
    done
    
    # Create Database and Users if not already present
    mariadb -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;"
    mariadb -u root -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASS}';"
    mariadb -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DB}\`.* TO '${MYSQL_USER}'@'%';"
    mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';"
    mariadb -u root -e "FLUSH PRIVILEGES;"
    
    # Stop background service safely
    mariadb-admin -u root -p"${MYSQL_ROOT_PASS}" shutdown
fi
# Run MariaDB in foreground mode to keep container alive
exec mariadbd --user=mysql