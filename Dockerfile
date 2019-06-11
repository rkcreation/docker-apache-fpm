FROM httpd:2.4

# Packages
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
    bash \
    curl \
    git \
    unzip \
    wget \
    nano \
    ntp \
  && rm -r /var/lib/apt/lists/*

# User conf
ENV RUN_UID 8181
ENV RUN_GID 8181
ENV HOSTMASTER hostmaster@localhost
ENV LOG_LEVEL info

# Time config

ENV TIMEZONE="Europe/Paris"
ENV PHP_FPM_PATH="/var/www"

RUN ntpd -gq \
  && service ntp start &&\
  echo "$TIMEZONE" > /etc/timezone &&\
  ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime &&\
  dpkg-reconfigure -f noninteractive tzdata

COPY conf/vhost.conf /usr/local/apache2/conf/vhost.conf
COPY conf/httpd.conf /usr/local/apache2/conf/httpd.conf

RUN mkdir /var/lib/php-fcgi \
    && mkdir /var/www
