#!/bin/bash
set -e

make install

wp_dir=$(php -r 'echo json_decode(file_get_contents("/app/composer.json"), true)["extra"]["wordpress-install-dir"];')
wp_parameters=$(php -r 'echo json_decode(file_get_contents("/app/composer.json"), true)["extra"]["incenteev-parameters"]["file"];')

email=$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["wordpress_email"];')
password=$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["wordpress_password"];')
admin=$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["wordpress_username"];')
title=$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["wordpress_title"];')
url=$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["wordpress_url"];')

cd $wp_dir

if ! ../vendor/bin/wp core is-installed; then
	echo "Installing wordpress"
	../vendor/bin/wp core install --skip-email --admin_email="$email" --admin_password="$password" --admin_user="$admin" --title="$title" --url="$url"
fi

echo "Activating all plugins"
../vendor/bin/wp plugin list --format=csv |tail -n+2|grep -E '[^,],inactive,'|cut -d, -f1|xargs ../vendor/bin/wp plugin activate

if ! ../vendor/bin/wp core is-installed; then
    echo "Configuring W3 Total cache"
    ../vendor/bin/wp total-cache option set minify.enabled 1
    ../vendor/bin/wp total-cache option set minify.engine redis
    ../vendor/bin/wp total-cache option set minify.redis.servers redis:6379
    ../vendor/bin/wp total-cache option set minify.redis.persistent 1

    ../vendor/bin/wp total-cache option set objectcache.enabled 1
    ../vendor/bin/wp total-cache option set objectcache.engine redis
    ../vendor/bin/wp total-cache option set objectcache.redis.servers redis:6379
    ../vendor/bin/wp total-cache option set objectcache.redis.persistent 1

    ../vendor/bin/wp total-cache option set dbcache.enabled 1
    ../vendor/bin/wp total-cache option set dbcache.engine redis
    ../vendor/bin/wp total-cache option set dbcache.redis.servers redis:6379
    ../vendor/bin/wp total-cache option set dbcache.redis.persistent 1

    echo "Downloading and creating fake products in WooCommerce"
    woocommerce_version=$(../vendor/bin/wp plugin status woocommerce |grep -oE 'Version: [0-9.]+' |cut -d" " -f2)

    wget https://plugins.svn.wordpress.org/woocommerce/tags/$woocommerce_version/dummy-data/dummy-data.xml

    ../vendor/bin/wp import dummy-data.xml --authors=create

    rm dummy-data.xml

    echo "Indexing data for the first time in ElasticPress"
    ../vendor/bin/wp elasticpress index --setup
fi
