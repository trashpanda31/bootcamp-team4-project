<?php
defined('ABSPATH') || exit;
?><!doctype html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Demo Theme</title>
  <?php wp_head(); ?>
  <style>
    body{font-family:system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; padding:40px;}
    .box{max-width:800px;margin:auto;border:1px solid #ddd;border-radius:12px;padding:24px}
    code{background:#f6f8fa;padding:2px 6px;border-radius:6px}
  </style>
</head>
<body>
  <div class="box">
    <h1>Demo Theme работает ✅</h1>
    <p>Этот файл находится в <code>wp-content/themes/demo-theme/index.php</code> и попал в контейнер через сборку образа.</p>
    <p>Измени текст, пересобери образ — и тут обновится.</p>
  </div>
  <?php wp_footer(); ?>
</body>
</html>
