#!/bin/bash
set -e

echo "[INFO] Starting WordPress Setup Script..."

cd /var/www/html

until mysqladmin ping -h"mariadb" --silent; do
    echo "[INFO] Waiting for MariaDB database to be ready..."
    sleep 3
done

if [ ! -f "wp-config.php" ]; then
    echo "[INFO] WordPress config not found. Setting up..."

    if [ ! -f "index.php" ]; then
        echo "[INFO] Downloading core files..."
        wp core download --allow-root
    fi

    echo "[INFO] Creating wp-config.php..."
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$(cat /run/secrets/db_password) \
        --dbhost=mariadb:3306 \
        --allow-root

    echo "[INFO] Installing WordPress..."
    wp core install \
        --url=$DOMAIN_NAME \
        --title="$WORDPRESS_TITLE" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$(cat /run/secrets/wordpress_admin_password) \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root

    echo "[INFO] Creating secondary WordPress user..."
    wp user create \
        $WP_USER \
        $WP_EMAIL \
        --user_pass=$(cat /run/secrets/wordpress_password) \
        --role=author \
        --allow-root
        
    echo "[INFO] WordPress installation completed successfully!"
else
    echo "[INFO] WordPress is already configured and installed."
fi

echo "[INFO] Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 --nodaemonize