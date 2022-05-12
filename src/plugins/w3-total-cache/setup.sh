wpcli="$1"
wpparameters="$2"
project_root="$3"

-    echo "Configuring W3 Total cache"
$wpcli total-cache option set minify.enabled 1
$wpcli total-cache option set minify.engine redis
$wpcli total-cache option set minify.redis.servers "${redis_host}:${redis_port}"
$wpcli total-cache option set minify.redis.persistent 1

$wpcli total-cache option set objectcache.enabled 1
$wpcli total-cache option set objectcache.engine redis
$wpcli total-cache option set objectcache.redis.servers "${redis_host}:${redis_port}"
$wpcli total-cache option set objectcache.redis.persistent 1

$wpcli total-cache option set dbcache.enabled 1
$wpcli total-cache option set dbcache.engine redis
$wpcli total-cache option set dbcache.redis.servers "${redis_host}:${redis_port}"
$wpcli total-cache option set dbcache.redis.persistent 1

