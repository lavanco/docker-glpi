ARG DISTRO=centos
ARG DISTROVERSION=7

FROM $DISTRO:$DISTROVERSION

ARG GLPIVERSION="9.1.7.1"
ARG GLPIPLUGINDASHBOARD="0.9.0"
ARG GLPIPLUGINOCS="1.3.5"

LABEL maintainer="Leandro Avanco <leandro.avanco@gmail.com>"
LABEL glpi.version=$GLPIVERSION
LABEL glpi.plugin.dashboard=$GLPIPLUGINDASHBOARD
LABEL glpi.plugin.ocs=$GLPIPLUGINOCS

ARG yumoptions="-y --setopt=tsflags=nodocs --nogpgcheck"

RUN yum $yumoptions --enablerepo=extras install epel-release && \
  yum makecache fast && \
  yum $yumoptions update && \
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
  yum $yumoptions install $yumpackages && \
  yum clean all && rm -rf /var/cache/yum

RUN \
  curl -L -o /root/glpi-$GLPIVERSION.tgz https://github.com/glpi-project/glpi/releases/download/$GLPIVERSION/glpi-$GLPIVERSION.tgz && \
  tar zxvf /root/glpi-$GLPIVERSION.tgz -C /var/www/html/ && \
  curl -L -o /root/GLPI-dashboard_plugin-$GLPIPLUGINDASHBOARD-9.1.x.tar.gz https://forge.glpi-project.org/attachments/download/2221/ && \
  tar zxvf /root/GLPI-dashboard_plugin-$GLPIPLUGINDASHBOARD-9.1.x.tar.gz -C /var/www/html/glpi/plugins && \
  curl -L -o /root/glpi-ocsinventoryng-$GLPIPLUGINOCS.tar.gz https://github.com/pluginsGLPI/ocsinventoryng/releases/download/$GLPIPLUGINOCS/glpi-ocsinventoryng-$GLPIPLUGINOCS.tar.gz && \
  tar zxvf /root/glpi-ocsinventoryng-$GLPIPLUGINOCS.tar.gz -C /var/www/html/glpi/plugins && \
  chown -R apache:apache /var/www/html/glpi && \
  rm -rf /root/*.tgz && rm -rf /root/*.tar.gz && rm -rf /tmp/*

RUN \
  sed -i.orig 's#DocumentRoot "\/var\/www\/html\"#DocumentRoot "\/var\/www\/html\/glpi\"#g' /etc/httpd/conf/httpd.conf && \
  sed -i.orig 's#         " - Copyright (C) 2003-2015 INDEPNET Development Team".#         " - Copyright (C) 2003-2015 INDEPNET Development Team".\n         "</a>".\n         "<a href=\\"https://github.com/lavanco\/\\" title=\\"lavanco\\" class=\\"copyright\\" target=\\"_blank\\">".\n         " - 2019 Dockerized by lavanco".#g' /var/www/html/glpi/inc/html.class.php && \
  sed -i.orig 's#;date.timezone =#date.timezone = America/Sao_Paulo#g' /etc/php.ini && \
  sed -i.orig 's#;apc.shm_size=32M#apc.shm_size=128M#g' /etc/php.d/apcu.ini && \
  echo "apc.shm_segments = 1" >> /etc/php.d/apcu.ini && \
  echo "apc.max_file_size = 10M" >> /etc/php.d/apcu.ini && \
  sed -i.orig 's#opcache.memory_consumption=128#opcache.memory_consumption=256#g' /etc/php.d/opcache.ini && \
  sed -i 's#;opcache.revalidate_freq=2#opcache.revalidate_freq=60#g' /etc/php.d/opcache.ini && \
  sed -i 's#;opcache.enable_cli=0#opcache.enable_cli=1#g' /etc/php.d/opcache.ini && \
  echo -e '[program:httpd]\n;command=/usr/sbin/httpd -c "ErrorLog /dev/stdout" -DFOREGROUND\nredirect_stderr=true\ncommand=/usr/sbin/httpd -DFOREGROUND\nprocess_name = httpd' > /etc/supervisord.d/nginx.ini && \
  rm /etc/localtime && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisord.conf"]

EXPOSE 80 443

HEALTHCHECK --interval=2m --timeout=10s CMD curl -f http://localhost/ || exit 1
