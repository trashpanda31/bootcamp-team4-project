#!/bin/sh
set -e

docker-entrypoint.sh "$@" &

mkdir -p /var/www/html
if [ ! -f /var/www/html/healthz.html ]; then
  echo "ok" > /var/www/html/healthz.html
fi

wait -n
