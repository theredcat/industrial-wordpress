#!/bin/sh
/wait-for-it.sh db:3306 -t 60 -- echo "DB Ready"
cd /app
/usr/sbin/composer install --no-interaction
/usr/bin/supervisord
php-fpm
