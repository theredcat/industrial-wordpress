wpcli="$1"
wpparameters="$2"
project_root="$3"

plugin_root="$($wpcli eval 'echo WP_PLUGIN_DIR;')/woocommerce"

echo "Configuring Total cache for woocommerce"
reject_list=$($wpcli total-cache option get dbcache.reject.sql --type=array |head -n-1 |tail -n+2 | xargs echo| sed 's/, /,/g')
reject_list=$reject_list",_wc_session_"
$wpcli total-cache option set dbcache.reject.sql --type=array --delimiter=, "$reject_list"

echo "Creating fake products in WooCommerce"
$wpcli import "$plugin_root/sample-data/sample_products.xml" --authors=create
