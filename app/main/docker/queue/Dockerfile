FROM php:8.0-fpm

# Install dependencies
RUN apt-get update && apt-get install -y libpq-dev curl libcurl4-openssl-dev pkg-config git \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo \
    pdo_pgsql \
    sockets \
    pgsql \
    curl

RUN curl -sS https://getcomposer.org/installer | php -- \
     --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/main
COPY . .
RUN composer install
#ENTRYPOINT ["php artisan queue:work"]
CMD ["php", "artisan", "queue:work"]
