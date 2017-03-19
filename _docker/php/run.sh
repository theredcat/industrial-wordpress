#!/bin/sh
/wait-for-it.sh db:3306 -t 120 -- echo "DB Ready"
/wait-for-it.sh redis:6379 -t 60 -- echo "Redis Ready"
cd /app

/usr/sbin/composer install --no-interaction

chown -R www-data.www-data /app/wp/wp-content

cd /app/wp

email=$(php -r 'echo yaml_parse_file("/app/config/parameters.yml")["parameters"]["wordpress_email"];')
password=$(php -r 'echo yaml_parse_file("/app/config/parameters.yml")["parameters"]["wordpress_password"];')
admin=$(php -r 'echo yaml_parse_file("/app/config/parameters.yml")["parameters"]["wordpress_username"];')
title=$(php -r 'echo yaml_parse_file("/app/config/parameters.yml")["parameters"]["wordpress_title"];')
url=$(php -r 'echo yaml_parse_file("/app/config/parameters.yml")["parameters"]["wordpress_url"];')

../vendor/wp-cli/wp-cli/bin/wp --allow-root core install --skip-email --admin_email="$email" --admin_password="$password" --admin_user="$admin" --title="$title" --url="$url"
../vendor/wp-cli/wp-cli/bin/wp --allow-root plugin list --format=csv |tail -n+2|grep -E '[^,],inactive,'|cut -d, -f1|xargs ../vendor/wp-cli/wp-cli/bin/wp --allow-root plugin activate

/usr/bin/supervisord
php-fpm
