<?php
require __DIR__ . '/../vendor/autoload.php';

// ** Yaml config ** //
$config = yaml_parse_file(__DIR__.'/../config/parameters.yml');
$config = $config['parameters'];

// ** MySQL settings ** //
define('DB_NAME', $config['database_wp_name']);
define('DB_USER', $config['database_wp_user']);
define('DB_PASSWORD', $config['database_wp_password']);
define('DB_HOST', $config['database_wp_host']);
define('DB_CHARSET', $config['database_wp_charset']);
define('DB_COLLATE', $config['database_wp_collate']);
$table_prefix  = $config['database_wp_table_prefix'];

/** AWS */
define( 'DBI_AWS_ACCESS_KEY_ID', $config['aws_key_id']);
define( 'DBI_AWS_SECRET_ACCESS_KEY', $config['aws_access_key']);


/**
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'si*tfXLw+#4Rv9Qc-eK?.4HekB_Gzy|J-nJ/yf$UUp=%6o_S$&]$XAO;fVo.*B:L');
define('SECURE_AUTH_KEY',  '<s~~u3_-qNoflWQ_;]>i|i.,%7;#pq3r^YN2NKBmecS!2:4i:Hvjsn)+_7!N%+:<');
define('LOGGED_IN_KEY',    'o5]^[4+j^2}VqcY!bzgq84pGR<Z%rv*r{)X4(`%X[tF3Xiy*k=RKU%|$MMsU6}UY');
define('NONCE_KEY',        '-/9%6b[Yh I]s+mGIy:vlFcO 5Zk[Ff{Qh~|%(+G4fyF1az:D);[H)t!`5-w^2cT');
define('AUTH_SALT',        '9Wdz23S(O(Ul}GjV$3`%OPOuK4}n5ae>U;q&;H ixLyEz~*(|q[m$hoTE-mekfZ_');
define('SECURE_AUTH_SALT', '^(n{-c|%qSBR8!Z6=+a2yZXl*,?Ftc2|m)w%q@;F+0$wX++L3eNfynQZDG2FI~+>');
define('LOGGED_IN_SALT',   '#*hp4$^-:Yo,5&7rJ` #+P5>;!<1|2)SV;]+|{)-~:E-|PPy{a8yS[EnC/rM%I]!');
define('NONCE_SALT',       '|>pm}82QKm0?iX#F~VjG1O|o^wU@;8pzq9R1smx@G*(Ux8u#(267,+[{qR@{/Ad2');

/**
 * For developers: WordPress debugging mode.
 */
define('WP_DEBUG', $config['debug']);


/**
 * Multisite
 */
if($config['wordpress_multisite']) {
	define( 'WP_ALLOW_MULTISITE', true);
	define( 'MULTISITE', true );
	define( 'SUBDOMAIN_INSTALL', false );
	define( 'DOMAIN_CURRENT_SITE', 'www.localhost.direct' );
	define( 'PATH_CURRENT_SITE', '/' );
	define( 'SITE_ID_CURRENT_SITE', 1 );
	define( 'BLOG_ID_CURRENT_SITE', 1 );
}

// ** Wordpress.com update check ** //
define( 'WP_AUTO_UPDATE_CORE', false );
define( 'AUTOMATIC_UPDATER_DISABLED', true );

// ** Cache settings ** //
define('WP_CACHE', $config['cache']);

// ** Elasticsearch settings ** //
define('EP_HOST', $config['elasticpress_protocol'].'://'.$config['elasticpress_host'].':'.$config['elasticpress_port']);
define('EP_INDEX_PREFIX', $config['elasticpress_index_prefix']);
define('EP_IS_NETWORK', $config['elasticpress_network']);


/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
