#!/bin/bash
set -e

make install

wp_dir=$(php -r 'echo json_decode(file_get_contents("/app/composer.json"), true)["extra"]["wordpress-install-dir"];')
wp_parameters=$(php -r 'echo json_decode(file_get_contents("/app/composer.json"), true)["extra"]["incenteev-parameters"]["file"];')

email=$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["docker_wordpress_email"];')
password=$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["docker_wordpress_password"];')
admin=$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["docker_wordpress_username"];')
title=$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["docker_wordpress_title"];')
url=$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["docker_wordpress_url"];')

redis_host=$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["redis_host"];')
redis_port=$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["redis_port"];')

cd $wp_dir

if ! ../vendor/bin/wp core is-installed; then
	echo "Installing wordpress"
	../vendor/bin/wp core install --skip-email --admin_email="$email" --admin_password="$password" --admin_user="$admin" --title="$title" --url="$url"

    do_setup_plugins=true
else
    do_setup_plugins=false
fi

echo "Activating all plugins"
for plugin in $(../vendor/bin/wp plugin list --format=csv |tail -n+2|grep -E '[^,],inactive,'|cut -d, -f1); do
	../vendor/bin/wp plugin activate "${plugin}"
done

if $do_setup_plugins; then
    echo "Configuring W3 Total cache"
    ../vendor/bin/wp total-cache option set minify.enabled 1
    ../vendor/bin/wp total-cache option set minify.engine redis
    ../vendor/bin/wp total-cache option set minify.redis.servers "${redis_host}:${redis_port}"
    ../vendor/bin/wp total-cache option set minify.redis.persistent 1

    ../vendor/bin/wp total-cache option set objectcache.enabled 1
    ../vendor/bin/wp total-cache option set objectcache.engine redis
    ../vendor/bin/wp total-cache option set objectcache.redis.servers "${redis_host}:${redis_port}"
    ../vendor/bin/wp total-cache option set objectcache.redis.persistent 1

    ../vendor/bin/wp total-cache option set dbcache.enabled 1
    ../vendor/bin/wp total-cache option set dbcache.engine redis
    ../vendor/bin/wp total-cache option set dbcache.redis.servers "${redis_host}:${redis_port}"
    ../vendor/bin/wp total-cache option set dbcache.redis.persistent 1

    echo "Importing ACF data"
    cd .. && make acf_import && cd $wp_dir

    echo "Configuring Total cache for woocommerce"
    reject_list=$(../vendor/bin/wp total-cache option get dbcache.reject.sql --type=array |head -n-1 |tail -n+2 | xargs echo| sed 's/, /,/g')
    reject_list=$reject_list",_wc_session_"
    ../vendor/bin/wp total-cache option set dbcache.reject.sql --type=array --delimiter=, "$reject_list"

    echo "Downloading and creating fake products in WooCommerce"
    woocommerce_version=$(../vendor/bin/wp plugin status woocommerce |grep -oE 'Version: [0-9.]+' |cut -d" " -f2)

    wget https://plugins.svn.wordpress.org/woocommerce/tags/$woocommerce_version/dummy-data/dummy-data.xml

    ../vendor/bin/wp import dummy-data.xml --authors=create

    rm dummy-data.xml

    echo "Indexing data for the first time in ElasticPress"
    ../vendor/bin/wp elasticpress index --setup
fi
