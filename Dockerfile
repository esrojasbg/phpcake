FROM composer:latest AS composer

FROM php:7.4-apache-buster

RUN apt-get update && \
    apt-get install -y zip unzip libicu-dev && \
    docker-php-ext-install intl pdo pdo_mysql && docker-php-ext-configure intl 

COPY --from=composer /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /var/www/html

RUN a2enmod rewrite
COPY ./app/composer.json .
RUN ls 

# Instalar las dependencias con Composer
RUN /usr/bin/composer install --no-interaction --no-plugins --no-scripts --verbose


ENV DB_HOST=nombre_del_contenedor_de_mysql
ENV DB_USER=usuario_de_mysql
ENV DB_PASS=contraseña_de_mysql
ENV DB_NAME=nombre_de_la_base_de_datos


COPY ./app /var/www/html

RUN chown -R www-data:www-data /var/www/html
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80
