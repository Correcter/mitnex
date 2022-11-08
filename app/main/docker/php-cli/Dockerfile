FROM php:7.2-cli

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --fix-missing \
    apt-utils \
    libxml2-dev \
    gnupg

RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
RUN curl -sS --insecure https://www.dotdeb.org/dotdeb.gpg | apt-key add -

RUN apt-get update && apt-get install -y --fix-missing \
    wget \
    zlib1g-dev \
    libzip-dev \
    git

RUN docker-php-ext-install -j$(nproc) zip
RUN pecl install redis && docker-php-ext-enable redis
RUN docker-php-ext-install -j$(nproc) pdo_mysql
RUN docker-php-ext-install -j$(nproc) pcntl
RUN docker-php-ext-install -j$(nproc) bcmath
RUN docker-php-ext-install -j$(nproc) soap
RUN docker-php-ext-install -j$(nproc) opcache
RUN docker-php-ext-install -j$(nproc) intl
RUN pecl install apcu && docker-php-ext-enable apcu

RUN curl -s https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer
RUN /usr/bin/composer self-update 1.7.2
RUN mkdir -p /var/www/.composer/cache/ \
    && chown www-data:1000 /var/www/.composer/cache/

ADD php.ini /usr/local/etc/php

WORKDIR /usr/share/nginx/mostbet

CMD ["tail", "-f", "/var/log/faillog"]
