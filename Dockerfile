FROM php:7.1-fpm-alpine

ARG docker_host=/sbin/ip route|awk '/default/ { print $3 }'

ENV PHPIZE_DEPS \
  autoconf \
  cmake \
  file \
  freetype-dev \
  g++ \
  git \
  gcc \
  icu-dev \
  libc-dev \
  libjpeg-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  libxslt-dev \
  libmemcached-dev \
  make \
  pcre-dev \
  pkgconf \
  re2c

RUN set -x && \
  apk update && apk add --no-cache --update --virtual buildDeps autoconf \
    freetype \
    icu \
    libjpeg-turbo \
    libmcrypt \
    libpng \
    libxslt \
    openssh \
    openssl \
    sshpass \
    tini \
    && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/ && \
  NPROC=$(getconf _NPROCESSORS_ONLN || 1) && \
  docker-php-ext-install -j${NPROC} \
    gd \
    intl \
    mcrypt \
    mysqli \
    pdo_mysql \        
    xsl \
    zip \  
  && rm /var/cache/apk/*
  && mkdir ~/.ssh
  && ssh-keyscan -H $docker_host >> ~/.ssh/known_hosts
