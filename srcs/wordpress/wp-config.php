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
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //

/** Name of the uploads directory */
define( 'UPLOADS', 'wp-content/uploads');

/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'wordpress' );

/** MySQL database password */
define( 'DB_PASSWORD', 'password' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '#<0u|uq8MQ)Wi<0,jB7(aI3HfCSn;9QzJt4,).5`OS?{Ol|IPU=q>tA!jOd]o(:t' );
define( 'SECURE_AUTH_KEY',  'kA[%&T3[>T29N`TvX-;5;fv|mGSjM^9[K5wVT}lcOi873p]n!vptt6q|KQb3wQ11' );
define( 'LOGGED_IN_KEY',    'y<YBn%&cd)CLXoLAg/w|K^ @Y*:=tRa`2beh2T HGwVH$H](SSs$Yi)7vVi5<?^Q' );
define( 'NONCE_KEY',        'v%(pY2$%y)u%.MzZT##N9k`&|:iH 6Zqj//fX~CayJZ1[.I!]X<i8y`+1h$,~E?s' );
define( 'AUTH_SALT',        'D<M2C>OAAMXVc|U,9<[9GH03*uQg<!MFE,+QUZKvF:b:B?v]Ih<9|^wj;v[6,d:?' );
define( 'SECURE_AUTH_SALT', '%I^N[=wTIUlEv+9|?LA;*17x&WCfGfn4+Qz<R)hMn9IXN 5 Mg:uSVQ{O`1#D04y' );
define( 'LOGGED_IN_SALT',   'Kp$e4Hlp59wow0z~<v!g=?mprh-imqX6$2CB`En)yvy0XD9?=>Hr|[7!wESO/*]!' );
define( 'NONCE_SALT',       'K$<cjleJ$Jscu;ARNawMWxN}`gL ``8rf|C@~YvRxI2R;=#B+*Pk,pwxQ?c@+T?p' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
