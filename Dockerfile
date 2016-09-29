#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM resin/rpi-raspbian
#MAINTAINER 3liz / docker-qgis_server-lizmap
RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl
# add qgis to sources.list
#RUN echo "deb http://http.debian.net/debian jessie main" >> /etc/apt/sources.list
# add sid
RUN echo "deb http://http.debian.net/debian sid  main " >> /etc/apt/sources.list
RUN gpg --keyserver pgpkeys.mit.edu --recv-key 7638D0442B90D010
RUN gpg -a --export 7638D0442B90D010 | sudo apt-key add -
RUN gpg --keyserver pgpkeys.mit.edu --recv-key 8B48AD6246925553
RUN gpg -a --export 8B48AD6246925553 | sudo apt-key add -
RUN apt-get -y update
#RUN echo -e '#!/bin/bash\n/bin/true' > /var/lib/dpkg/info/libc6:armhf.postrm
#ADD libc6_2.24-3_armhf.deb /
#RUN dpkg -i --force-all /libc6_2.24-3_armhf.deb
RUN apt-get upgrade libc6

#--------------------------------------------------------------------------------------------
# Install stuff
RUN apt-get -t sid -f install -y qgis-server unzip nginx supervisor php5-fpm php5-curl php5-cli php5-sqlite \
    php5-pgsql php5-gd php5-ldap 

ADD supervisor/supervisord.conf /etc/supervisor/supervisord.conf
ADD supervisor/php.conf supervisor/nginx.conf supervisor/qgis.conf /etc/supervisor/conf.d/ 

ADD nginx/*  /etc/nginx/sites-enabled/

# Tweak php-fpm configuration
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf

# Expose ports
EXPOSE 80 8200

# Get lizmap
ADD https://github.com/3liz/lizmap-web-client/archive/3.0.3.zip /srv/
ADD lizmapConfig.ini.php.dist /lizmapConfig.ini.php.dist
ADD lizmap_setup.sh /
RUN chmod +x /lizmap_setup.sh
RUN /lizmap_setup.sh 
# Mount persistent data volume
VOLUME /home /srv/lizmap-web-client/lizmap/var

# Run supervisor
CMD supervisord




