#!/bin/bash


DB_PASS=$(cat $WORDPRESS_DB_PASSWORD_FILE)
# waiting for mariadb to start and throw output in /dev/null
while ! mariadb -h ${WORDPRESS_DB_HOST} -u ${MARIA_USER} -p ${DB_PASS} ${MARIA_DB} &> /dev/null;do
    sleep 1
done
# output and error : &>
# wp-core howa wahd sw package li kayconnectina mea database w howa li feh wahhd files li kaykhaliw wordpress ykhdam
if ! wp-core is-installed --allow-root &>  /dev/null ; then
    # download wordpress
    # tool wp core
    wp core download --path=/var/www/html --allow-root
    # config
    wp config create --dbname=${MARIA_DB} --dbuser=${MARIA_USER} --dbpass=${DB_PASS} --dbhost=${WORDPRESS_DB_HOST} --path=/var/www/html -- allow-root

    echo "Installing WordPress and creating Admin..."
    # dashboard of the wordpress
    wp core install \
        --url=$WP_URL \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$ADMIN_PASS \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root

    echo "Creating standard user..."
    wp user create \
        $WP_USER \
        $WP_USER_EMAIL \
        --role=author \
        --user_pass=$USER_PASS \
        --allow-root

    chown -R www-data:www-data /var/www/html

    echo "WordPress setup complete!"
else
    echo "WordPress is already installed."
fi
echo "Starting PHP-FPM..."
# -F fg
exec /usr/sbin/php-fpm8.2 -F