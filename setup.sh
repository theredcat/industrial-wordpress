#!/bin/bash
set -euxo pipefail

make install

project_root=$(pwd -P)
wpcli="$project_root/vendor/bin/wp"

wp_dir="$(php -r 'echo json_decode(file_get_contents("/app/composer.json"), true)["extra"]["wordpress-install-dir"];')"
wp_parameters="$project_root/$(php -r 'echo json_decode(file_get_contents("/app/composer.json"), true)["extra"]["incenteev-parameters"]["file"];')"

email="$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["docker_wordpress_email"];')"
password="$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["docker_wordpress_password"];')"
admin="$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["docker_wordpress_username"];')"
title="$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["docker_wordpress_title"];')"
url="$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["docker_wordpress_url"];')"
permalink_structure="$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["wordpress_permalink_structure"];')"
multisite="$(php -r 'echo yaml_parse_file("'$wp_parameters'")["parameters"]["wordpress_multisite"];')"

cd "$wp_dir"

if ! $wpcli core is-installed &> /dev/null; then
    if [ "$multisite" = "1" ]; then
        echo "Installing wordpress in multisite mode"
        $wpcli core multisite-install --skip-email --admin_email="$email" --admin_password="$password" --admin_user="$admin" --title="$title" --url="$url"
    else
        echo "Installing wordpress in single site mode"
        $wpcli core install --skip-email --admin_email="$email" --admin_password="$password" --admin_user="$admin" --title="$title" --url="$url"
    fi
fi

echo "Setting permalink structure"
$wpcli rewrite structure "$permalink_structure"

echo "Activating all plugins"
plugin_to_activate="$($wpcli plugin list --format=csv |tail -n+2|grep -E '[^,],inactive,'|cut -d, -f1)"
for plugin in ${plugin_to_activate}; do
    $wpcli plugin activate "${plugin}"
done

if [ "$multisite" = "1" ]; then
    wpcli="$wpcli --url=$url"
fi

for plugin in ${plugin_to_activate}; do
    plugin_setup_file="${project_root}/src/plugins/${plugin}/setup.sh"
    if [ -f "${plugin_setup_file}" ]; then
        bash "${plugin_setup_file}" "${wpcli}" "${wp_parameters}" "${project_root}"
    fi
done
