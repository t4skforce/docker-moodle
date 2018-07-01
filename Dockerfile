FROM debian:latest
########################################
#              Settings                #
########################################
ENV HTTP_PORT 80
ENV SSL_PORT  443

########################################
#               Setup                  #
########################################
ENV USERNAME moodle
ENV USERGROUP moodle
ENV APPUID 1000
ENV APPGID 1000
ENV USER_HOME /home/moodle
ENV BUILD_REQUIREMENTS wget expect gnupg
ENV REQUIREMENTS sudo curl openssl ca-certificates supervisor cron apache2 mariadb-server php libapache2-mod-php php-mysql php-xml php-xmlrpc php-zip php-gd php-intl php-mbstring php-soap php-solr php-redis openjdk-8-jdk software-properties-common
########################################

USER root
ENV DEBIAN_FRONTEND noninteractive
# setup
RUN apt-get update -qqy \
	&& apt-get -qqy --no-install-recommends install ${BUILD_REQUIREMENTS} ${REQUIREMENTS} \
	&& mkdir -p ${USER_HOME} \
	&& groupadd --system --gid ${APPGID} ${USERGROUP} \
	&& useradd --system --uid ${APPUID} -g ${USERGROUP} ${USERNAME} --home ${USER_HOME} \
	&& echo "${USERNAME}:$(openssl rand 512 | openssl sha256 | awk '{print $2}')" | chpasswd \
	&& chown -R ${USERNAME}:${USERGROUP} ${USER_HOME}

# setup env
RUN chown -R ${USERNAME}:${USERGROUP} ${USER_HOME} \
  && mkdir -p /mnt/data

# apache2
COPY cfg/apache2/moodle.conf /etc/apache2/sites-available/moodle.conf
COPY cfg/apache2/security.conf /etc/apache2/conf-available/security.conf
RUN rm /etc/apache2/sites-enabled/* \
  && ln -s /etc/apache2/sites-available/moodle.conf /etc/apache2/sites-enabled/moodle.conf \
  && ln -s /etc/apache2/conf-available/security.conf /etc/apache2/conf-enabled/security.conf || /bin/true \
  && a2enmod headers \
  && a2enmod rewrite \
  && a2enmod ssl \
  && mv /etc/apache2 /etc/apache2.tpl \
  && mkdir -p /etc/ssl/{certs,private}

# php
RUN mv /etc/php /etc/php.tpl

# install moodle
WORKDIR /tmp/
RUN curl -Ls https://download.moodle.org/stable35/moodle-latest-35.tgz --output moodle.tgz \
  && tar xzf moodle.tgz \
  && mv ./moodle /var/www/html/ \
  && chown -R www-data:www-data /var/www/html/moodle \
  && rm -rf /tmp/* \
  && echo "*/1 * * * * /usr/bin/php  /var/www/html/moodle/admin/cli/cron.php" | crontab -u www-data -
COPY cfg/config.php /var/www/html/moodle/config.tpl.php

# prepare mariadb
WORKDIR /tmp/
COPY cfg/mysql/init.sh /etc/mysql/init.sh
COPY cfg/mysql/init.sql /etc/mysql/init.sql
RUN mv /var/lib/mysql /var/lib/mysql.tpl \
  && mv /etc/mysql/mariadb.conf.d /etc/mysql/mariadb.conf.d.tpl

# install solr
WORKDIR /tmp/
RUN curl -Ls https://mirror.klaus-uwe.me/apache/lucene/solr/7.4.0/solr-7.4.0.tgz --output solr-7.4.0.tgz \
  && tar xzf solr-*.tgz \
  && solr-*/bin/install_solr_service.sh solr-*.tgz -n \
  && mv /var/solr/data /var/solr/data.tpl \
  && rm -rf /tmp/*
COPY cfg/solr/init.sh /opt/solr/init.sh

# install redis
WORKDIR /tmp/
RUN curl -Ls https://www.dotdeb.org/dotdeb.gpg --output dotdeb.gpg \
  && apt-key add dotdeb.gpg \
  && apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install redis-server \
  && mv /var/lib/redis /var/lib/redis.tpl \
  && mv /etc/redis /etc/redis.tpl \
  && rm -rf /tmp/*

# seup supervisord
COPY cfg/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# cleanup
RUN apt-get --auto-remove -y purge ${BUILD_REQUIREMENTS} \
  	&& rm -rf /var/lib/apt/lists/* \
	  && rm -rf /tmp/*

EXPOSE ${HTTP_PORT} ${SSL_PORT} 8983

VOLUME /mnt/data

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh /

USER root
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
