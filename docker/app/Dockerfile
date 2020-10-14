FROM php:7.4-fpm-alpine

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
COPY --from=composer:1 /usr/bin/composer /usr/bin/composer

RUN apk --no-cache add bash git mysql-client openssh-client subversion unzip

# https://make.wordpress.org/hosting/handbook/handbook/server-environment/#php-extensions
RUN install-php-extensions mysqli opcache imagick zip
RUN mv $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini

ENV PATH="/srv/app/vendor/bin:/srv/app/bin:${PATH}"

WORKDIR /srv/app
