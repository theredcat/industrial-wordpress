wpcli="$1"
wpparameters="$2"
project_root="$3"

echo "Configuring Total cache for woocommerce"
reject_list=$($wpcli total-cache option get dbcache.reject.sql --type=array |head -n-1 |tail -n+2 | xargs echo| sed 's/, /,/g')
reject_list=$reject_list",_wc_session_"
$wpcli total-cache option set dbcache.reject.sql --type=array --delimiter=, "$reject_list"

echo "Downloading and creating fake products in WooCommerce"
woocommerce_version=$($wpcli plugin status woocommerce |grep -oE 'Version: [0-9.]+' |cut -d" " -f2)

wget https://plugins.svn.wordpress.org/woocommerce/tags/$woocommerce_version/dummy-data/dummy-data.xml

$wpcli import dummy-data.xml --authors=create
