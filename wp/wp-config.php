<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

require_once(__DIR__.'/../vendor/autoload.php');

use Symfony\Component\Yaml\Yaml;

$config = [];
try {
    $config = Yaml::parse(file_get_contents(__DIR__.'/../app/config/parameters.yml'));
} catch (ParseException $e) {
    throw new \Exception('Parse parameters.yml error', 1);
}

$config = $config['parameters'];

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', $config['database_wp_name']);

/** MySQL database username */
define('DB_USER', $config['database_wp_user']);

/** MySQL database password */
define('DB_PASSWORD', $config['database_wp_password']);

/** MySQL hostname */
define('DB_HOST', $config['database_wp_host']);

/** WEBP Config */
define('WEBP_DB_HOST', $config['database_webp_host']);
define('WEBP_DB_NAME', $config['database_webp_name']);
define('WEBP_DB_USER', $config['database_webp_user']);
define('WEBP_DB_PASSWORD', $config['database_webp_password']);

/** AWS */
define( 'DBI_AWS_ACCESS_KEY_ID', $config['aws_key_id']);
define( 'DBI_AWS_SECRET_ACCESS_KEY', $config['aws_access_key']);


/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
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

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', $config['debug']);
define ('WPLANG', 'en_US');

$configSolr = array(
    'endpoint' => array(
        $config['solr_host'] => array(
            'host' => $config['solr_host'],
            'port' => $config['solr_port'],
            'path' => $config['solr_path'].'/',
            'core' => $config['solr_core']
        )
    )
);


/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
