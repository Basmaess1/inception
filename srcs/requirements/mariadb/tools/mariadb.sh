#!/bin/bash
set -e

MARIA_PASS=$(cat $WORDPRESS_DB_PASSWORD_FILE)
MARIA_ROOT_PASS=$(cat $WORDPRESS_DB_ROOT_PASSWORD_FILE)

# runtime of the container



if [ ! -d "/var/lib/mysql/mysql" ]; then
    # Start service temporarily to execute setup commands
    service mariadb start

    # Wait for MariaDB to be ready
    until mariadb-admin ping --silent; do
        sleep 1
    done
    
    # Create Database and Users if not already present
    mariadb -u root -e "CREATE DATABASE IF NOT EXISTS \`${MARIA_DB}\`;"
    mariadb -u root -e "CREATE USER IF NOT EXISTS '${MARIA_USER}'@'%' IDENTIFIED BY '${MARIA_PASS}';"
    mariadb -u root -e "GRANT ALL PRIVILEGES ON \`${MARIA_DB}\`.* TO '${MARIA_USER}'@'%';"
    mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIA_ROOT_PASS}';"
    mariadb -u root -e "FLUSH PRIVILEGES;"
    
    # Stop background service safely
    mariadb-admin -u root -p"${MARIA_ROOT_PASS}" shutdown
fi
# Run MariaDB in foreground mode to keep container alive
exec mariadbd --user=mysql