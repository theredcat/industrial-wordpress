FROM php:8.1.5-fpm-bullseye

RUN apt-get update && apt-get install -y \
    libboost-all-dev \
    gperf \
    strace \
    tcpdump \
    libevent-dev \
    uuid-dev \
    wget \
    sudo \
    vim \
    git \
    default-mysql-client \
    libxml2-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    libfreetype6-dev \
    libmagickwand-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    zlib1g-dev \
    libmemcached-dev \
    libyaml-dev \
    libzip-dev \
    && apt-get clean \
    && rm -rf /var/lib/app/lists/*

RUN wget -O /wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
RUN chmod +x /wait-for-it.sh

RUN docker-php-ext-configure intl
RUN docker-php-ext-install gd
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install opcache
RUN pecl install imagick && docker-php-ext-enable imagick
RUN pecl install memcached && docker-php-ext-enable memcached
RUN pecl install redis && docker-php-ext-enable redis
RUN pecl install apcu && docker-php-ext-enable apcu
RUN pecl install yaml-2.2.2 && docker-php-ext-enable yaml

RUN echo "memory_limit = 32M" >> "/usr/local/etc/php/conf.d/memory_limit.ini"
RUN echo "max_execution_time = 200" >> "/usr/local/etc/php/conf.d/max_execution_time.ini"
RUN echo "date.timezone='Europe/Paris'" >> "/usr/local/etc/php/conf.d/timezone.ini"

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/sbin/composer && mkdir /.composer && chmod 777 /.composer

VOLUME /app

RUN chmod u+s /bin/chmod
RUN chmod u+s /usr/bin/vim
RUN chmod u+s /usr/bin/tcpdump

COPY ./run.sh /
RUN chmod +x /run.sh
CMD ["/run.sh"]

