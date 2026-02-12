<?php
/**
 * Plugin Name: SRF Must-Use: hardening defaults
 * Description: Small safe defaults for containerized WordPress (disable file editor, limit revisions).
 * Author: Your team
 * Version: 0.1.0
 */
defined('ABSPATH') || exit;

// Disable theme/plugin editor in wp-admin (recommended for prod).
if (!defined('DISALLOW_FILE_EDIT')) {
    define('DISALLOW_FILE_EDIT', true);
}

// Reasonable revision limit.
if (!defined('WP_POST_REVISIONS')) {
    define('WP_POST_REVISIONS', 20);
}

// Reduce autosave churn.
add_filter('autosave_interval', function () { return 120; });
