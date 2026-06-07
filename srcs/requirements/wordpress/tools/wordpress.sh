#!/bin/bash
set -e

until mysqladmin ping -h "mariadb" --silent; do 
    sleep 2
done 

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wordpress_admin_password)
WP_PASSWORD=$(cat /run/secrets/wordpress_password)

if [ ! -f "/var/www/html/wp-config.php" ]; then
    wp core download --path=/var/www/html --allow-root

    wp config create --path=/var/www/html \
        --dbname="$MYSQL_DATABASE" \
        --dbhost=mariadb:3306 \
        --dbuser="$MYSQL_USER" \
        --dbpass="$DB_PASSWORD" \
        --allow-root

    wp core install --path=/var/www/html --allow-root \
        --url="http://$DOMAIN_NAME" \
        --title="$WORDPRESS_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email

    wp user create "$WP_USER" "$WP_EMAIL" \
        --user_pass="$WP_PASSWORD" \
        --role=author \
        --allow-root

fi

chown  -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

exec php-fpm8.2 -F