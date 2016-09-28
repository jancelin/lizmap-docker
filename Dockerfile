#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM resin/rpi-raspbian
#MAINTAINER 3liz / docker-qgis_server-lizmap
RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl
# add qgis to sources.list
#RUN echo "deb http://qgis.org/debian jessie main" >> /etc/apt/sources.list
#RUN gpg --keyserver keyserver.ubuntu.com --recv 3FF5FFCAD71472C4
#RUN gpg --export --armor 3FF5FFCAD71472C4 | apt-key add -
# add sid
RUN echo "deb http://http.debian.net/debian sid main " >> /etc/apt/sources.list
RUN gpg --keyserver pgpkeys.mit.edu --recv-key 7638D0442B90D010
RUN gpg -a --export 7638D0442B90D010 | sudo apt-key add -
RUN apt-get -y update
RUN apt-get -t sid install libsdl2-dev:armhf
#--------------------------------------------------------------------------------------------
# Install stuff
RUN apt-get -t sid install -y qgis-server unzip nginx supervisor php5-fpm php5-curl php5-cli php5-sqlite \
    php5-pgsql php5-gd php5-ldap --force-yes

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




