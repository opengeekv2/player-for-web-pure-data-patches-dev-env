<?php

/*
 * Debug
 */
define('WP_DEBUG', true);
define('WP_DEBUG_DISPLAY', false);
define('WP_DEBUG_LOG', true);

/*
 * Database
 */
define('DB_NAME', 'wordpress');
define('DB_USER', 'wordpress');
define('DB_PASSWORD', 'wordpress');
define('DB_HOST', 'mysql');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

/*
 * Secrets
 */
define('AUTH_KEY',         'E8V{ 5mjO1Qpz-#D6>Fr!Fa4!ZmMr+Vyk1-_,]b?[wg>>H!3+v dd4kb2N2iPHlD');
define('SECURE_AUTH_KEY',  'o)iDs*!&*n)m`S#Z12c?rO+hgzS*NvA`D=!cM0`vXM_WH##WW]+cHI#[%I$6&8-S');
define('LOGGED_IN_KEY',    'OJ;c-b#K$,|Q_S^DD9CnUvT~X@u+Vh+(sT};p@]!(Cr+VOpl#MCCJh{#zu>Tfjn1');
define('NONCE_KEY',        'L1b6+N&Kq?*/|$qmg>qf#FQ/onNp9t&@p<-L|r@y&N](U:kHa.(3b1ANr!ZGe6bV');
define('AUTH_SALT',        'fBW#:lsbENt+2[aL+>+PzueW 9G#bSd?E){!(c]9-mPq[k+P?@{o*#EV2CGoy0VV');
define('SECURE_AUTH_SALT', 'hMS4HR>2Enx!.yy`Ldoq-i^pyfV]#]xO&-|EnCkQl-Yk=g5xRDx-ue]rfjAW)hwu');
define('LOGGED_IN_SALT',   '<3n|,(df-Q3u0=r3d9|]!+HO|!6KXleUxlcxwg8RVh}H+-ce*OF){XiH8f?tv{`<');
define('NONCE_SALT',       ':-W]JM|1q$rTi~/hHDi@0.vQ_We}+2(2Dr&.IOPaI|Qy_|[$y-_*QyM#I?C-z|55');

/*
 * Wordpress
 */
define('WP_HOME', 'https://' . $_SERVER['HTTP_HOST']);
define('WP_SITEURL', WP_HOME . '/wp');
define('WP_CONTENT_URL', WP_HOME . '/wp-content');
define('WP_CONTENT_DIR', __DIR__ . '/wp-content');

if (!defined('ABSPATH')) {
	define('ABSPATH', __DIR__ . '/wp');
}

require_once ABSPATH . 'wp-settings.php';
