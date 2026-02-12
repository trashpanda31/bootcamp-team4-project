<?php
/**
 * Plugin Name: Demo Plugin (SRF)
 * Description: A tiny plugin to demonstrate that wp-content is included in the image.
 * Version: 0.1.0
 */
defined('ABSPATH') || exit;

add_action('admin_notices', function () {
    echo '<div class="notice notice-info"><p><strong>Demo Plugin:</strong> plugins/demo-plugin loaded ✅</p></div>';
});
