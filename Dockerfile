FROM centos:7

ENV \
  GLPIVERSION="9.1.7.1" \
  GLPIPLUGINDASHBOARD="0.9.0" \
  GLPIPLUGINOCS="1.3.5" \
  yumoptions="-y --setopt=tsflags=nodocs --nogpgcheck"

RUN yum $yumoptions --enablerepo=extras install epel-release && \
  yum makecache fast && \
  yum $yumoptions update

RUN \
  yumpackages=" \
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
    crontabs \
    " && \
  yum $yumoptions install $yumpackages

RUN \
  curl -L -o glpi-$GLPIVERSION.tgz https://github.com/glpi-project/glpi/releases/download/$GLPIVERSION/glpi-$GLPIVERSION.tgz && \
  tar zxvf glpi-$GLPIVERSION.tgz -C /var/www/html/ && \
  chown -R apache:apache /var/www/html/glpi

RUN \
  curl -L -o GLPI-dashboard_plugin-$GLPIPLUGINDASHBOARD-9.1.x.tar.gz https://forge.glpi-project.org/attachments/download/2221/ && \
  ls -lha && tar zxvf GLPI-dashboard_plugin-$GLPIPLUGINDASHBOARD-9.1.x.tar.gz -C /var/www/html/glpi/plugins && \
  curl -L -o glpi-ocsinventoryng-$GLPIPLUGINOCS.tar.gz https://github.com/pluginsGLPI/ocsinventoryng/releases/download/$GLPIPLUGINOCS/glpi-ocsinventoryng-$GLPIPLUGINOCS.tar.gz && \
  tar zxvf glpi-ocsinventoryng-$GLPIPLUGINOCS.tar.gz -C /var/www/html/glpi/plugins && \
  chown -R apache:apache /var/www/html/glpi

RUN \
  sed -i.orig 's#DocumentRoot "\/var\/www\/html\"#DocumentRoot "\/var\/www\/html\/glpi\"#g' /etc/httpd/conf/httpd.conf && \
  sed -i.orig 's#;date.timezone =#date.timezone = America/Sao_Paulo#g' /etc/php.ini && \
  sed -i.orig 's#;apc.shm_size=32M#apc.shm_size=128M#g' /etc/php.d/apcu.ini && \
  echo "apc.shm_segments = 1" >> /etc/php.d/apcu.ini && \
  echo "apc.max_file_size = 10M" >> /etc/php.d/apcu.ini && \
  sed -i.orig 's#opcache.memory_consumption=128#opcache.memory_consumption=256#g' /etc/php.d/opcache.ini && \
  sed -i 's#;opcache.revalidate_freq=2#opcache.revalidate_freq=60#g' /etc/php.d/opcache.ini && \
  sed -i 's#;opcache.enable_cli=0#opcache.enable_cli=1#g' /etc/php.d/opcache.ini

RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

ADD etc/supervisord.d/httpd.ini /etc/supervisord.d/httpd.ini

RUN rm -rf *.tgz && rm -rf *.tar.gz && yum clean all && rm -rf /var/cache/yum && rm -rf /tmp/*

CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisord.conf"]

EXPOSE 80 443

HEALTHCHECK --interval=2m --timeout=10s CMD curl -f http://localhost/ || exit 1