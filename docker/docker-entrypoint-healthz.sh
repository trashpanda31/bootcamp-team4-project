#!/bin/sh
set -eu

mkdir -p /var/www/html

if [ ! -f /var/www/html/healthz.html ]; then
  printf '%s\n' 'ok' > /var/www/html/healthz.html
fi

exec docker-entrypoint.sh "$@"
