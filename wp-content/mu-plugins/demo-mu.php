<?php
/**
 * Plugin Name: Demo MU Plugin (SRF)
 * Description: Autoloaded MU plugin to demonstrate changes without activation.
 * Version: 0.1.0
 */
defined('ABSPATH') || exit;

add_action('admin_notices', function () {
    echo '<div class="notice notice-success"><p><strong>Demo MU:</strong> mu-plugins/demo-mu.php loaded ✅</p></div>';
});
