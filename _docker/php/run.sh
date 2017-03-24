#!/bin/sh
/wait-for-it.sh redis:6379 -t 60 -- echo "Redis Ready"
/wait-for-it.sh es:9200 -t 60 -- echo "Elasticsearch Ready"
/wait-for-it.sh db:3306 -t 120 -- echo "DB Ready"

cd /app

./configure

php-fpm
