FROM centos:7

ENV \
  GLPI_VERSION="9.1.1" \
  yum_options="-y --setopt=tsflags=nodocs --nogpgcheck"

RUN yum $yum_options --enablerepo=extras install epel-release && \
  yum makecache fast && \
  yum $yum_options update

RUN \
  yum_packages=" \
    httpd \
    php \
    php-mysql \
    php-ldap \
    php-imap \
    php-mbstring \
    php-gd \
    php-apcu-bc \
    php-pecl-apcu \
    php-pecl-zendopcache \
    php-xmlrpc \
    supervisor \
    tar \
    " && \
  yum $yum_options install $yum_packages

RUN \
  curl -L -o glpi-$GLPI_VERSION.tgz https://github.com/glpi-project/glpi/releases/download/$GLPI_VERSION/glpi-$GLPI_VERSION.tgz && \
  tar zxvf glpi-$GLPI_VERSION.tgz -C /var/www/html/ && \
  chown -R apache:apache /var/www/html/glpi

RUN \
  sed -i.orig 's#DocumentRoot "\/var\/www\/html\"#DocumentRoot "\/var\/www\/html\/glpi\"#g' /etc/httpd/conf/httpd.conf && \
  sed -i.orig 's#;date.timezone =#date.timezone = America/Sao_Paulo#g' /etc/php.ini && \
  sed -i.orig 's#;apc.shm_size=32M#apc.shm_size=128M#g' /etc/php.d/apcu.ini && \
  echo "apc.shm_segments = 1" >> /etc/php.d/apcu.ini && \
  echo "apc.max_file_size = 10M" >> /etc/php.d/apcu.ini && \
  sed -i.orig 's#opcache.memory_consumption=128#opcache.memory_consumption=256#g' /etc/php.d/opcache.ini && \
  sed -i 's#;opcache.revalidate_freq=2#opcache.revalidate_freq=60#g' /etc/php.d/opcache.ini && \
  sed -i 's#;opcache.enable_cli=0#opcache.enable_cli=1#g' /etc/php.d/opcache.ini && \

RUN chown -R apache:apache /var/www/html/glpi
RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
ADD etc/supervisord.d/httpd.ini /etc/supervisord.d/httpd.ini

RUN rm -rf glpi-$GLPI_VERSION.tgz && yum clean all && rm -rf /var/cache/yum && rm -rf /tmp/*

CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisord.conf"]

EXPOSE 80 443