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

RUN curl -L -o glpi-$GLPI_VERSION.tgz https://github.com/glpi-project/glpi/releases/download/$GLPI_VERSION/glpi-$GLPI_VERSION.tgz
RUN tar zxvf glpi-$GLPI_VERSION.tgz -C /var/www/html/
RUN chown -R apache:apache /var/www/html/glpi
RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
ADD etc/supervisord.d/httpd.ini /etc/supervisord.d/httpd.ini

RUN rm -rf glpi-$GLPI_VERSION.tgz && yum clean all && rm -rf /var/cache/yum && rm -rf /tmp/*

CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisord.conf"]

EXPOSE 80 443