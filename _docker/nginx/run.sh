#!/bin/sh
/wait-for-it.sh localhost:80 -t 60 -- /wait-for-it.sh php:9000 -t 60 -- python /install_wp.py &

nginx -g 'daemon off;'
