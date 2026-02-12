FROM wordpress:6.5.4-php8.2-apache

COPY ./wp-content/ /usr/src/wordpress/wp-content/

COPY ./docker/healthz.html /usr/src/wordpress/healthz.html

COPY ./docker/docker-entrypoint-healthz.sh /usr/local/bin/docker-entrypoint-healthz.sh
RUN chmod +x /usr/local/bin/docker-entrypoint-healthz.sh \
 && chown -R www-data:www-data /usr/src/wordpress/wp-content /usr/src/wordpress/healthz.html

ENTRYPOINT ["docker-entrypoint-healthz.sh"]
CMD ["apache2-foreground"]
