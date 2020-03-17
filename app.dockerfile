FROM php:7.3.12-fpm

COPY ./ /var/www

WORKDIR /var/www

RUN apt-get update -y && apt-get install -y zip unzip
RUN apt-get install -y libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libfreetype6-dev
RUN apt-get install -y \
        zlib1g-dev

RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN docker-php-ext-install pdo mbstring
RUN pecl install redis && docker-php-ext-enable redis

RUN apt-get install -y libzip-dev
RUN docker-php-ext-install zip

RUN docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir \
    --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir
RUN docker-php-ext-install gd

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && php composer.phar install --no-dev --no-scripts \
    && mv composer.phar /usr/local/bin/composer

RUN chmod -R 777 /var/www/storage \
        /var/www/bootstrap/cache


CMD ["php-fpm"]
