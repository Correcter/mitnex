FROM php:8.0-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libicu-dev \
    libxml2-dev \
    libxslt-dev \
    g++ \
    build-essential \
    libpng-dev \
    bzip2 \
    libbz2-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    libpq-dev \
    git \
    curl

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions \
    amqp \
    pdo_mysql \
    pdo_pgsql \
    http \
    redis \
    gd \
    intl \
    opcache \
    pgsql \
    soap \
    xsl \
    sockets

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- \
     --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
#RUN chown -Rf www-data:www-data /var/www
RUN chmod +x /usr/local/bin/composer

# Change current user to www
#USER www-data

# Set working directory
WORKDIR /var/www/main
COPY . .

# Expose port 9000 and start php-fpm server
EXPOSE 9000 443 80

RUN composer install

CMD ["php-fpm"]
