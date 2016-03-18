FROM alpine:3.3
MAINTAINER Abiola Ibrahim <abiola89@gmail.com>

LABEL caddy_version="0.8.2" architecture="amd64"

RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --update php7@testing php7-xml@testing php7-xsl@testing php7-pdo_mysql@testing \
    php7-mcrypt@testing php7-curl@testing php7-json@testing php7-fpm@testing php7-opcache@testing php7-phar@testing php7-openssl@testing \
    php7-mysqlnd@testing php7-ctype@testing openssh-client git tar  && \
    rm -fr /var/cache/apk/*

RUN ln -s /usr/bin/php7 /usr/bin/php

# allow environment variable access.
RUN echo "clear_env = no" >> /etc/php7/php-fpm.conf

RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://caddyserver.com/download/build?os=linux&arch=amd64&features=cors%2Cgit%2Cmailout%2Cprometheus" \
    | tar --no-same-owner -C /usr/bin/ -xz caddy \
 && chmod 0755 /usr/bin/caddy \
 && /usr/bin/caddy -version

EXPOSE 80 443 2015
VOLUME /srv
WORKDIR /srv

ADD Caddyfile /etc/Caddyfile
ADD index.php /srv/index.php

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile"]
