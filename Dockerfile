FROM centos:7
ENV GLPI_VERSION="9.1.1"
RUN yum -y --enablerepo=extras install epel-release \
&& yum makecache fast \
&& yum -y --setopt=tsflags=nodocs update \
&& yum -y --setopt=tsflags=nodocs install httpd \
php \
php-mysql \
php-ldap \
php-imap \
php-mbstring \
php-gd \
php-apcu-bc \
php-pecl-apcu \
php-pecl-zendopcache \
tar \
wget
RUN yum clean all
RUN wget https://github.com/glpi-project/glpi/releases/download/$GLPI_VERSION/glpi-$GLPI_VERSION.tgz
RUN tar -xvf glpi-$GLPI_VERSION.tgz -C /var/www/html/
RUN chown -R apache:apache /var/www/html/glpi
RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
RUN rm -rf glpi-$GLPI_VERSION.tgz
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod -v +x /docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 80 443
