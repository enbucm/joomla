# Joomla! based on Debian Stretch
FROM debian:stretch
MAINTAINER H5.Technology <admin@h5tec.com>

# Set correct environment variables.
ENV HOME /root
ENV EMAIL admin@yourdomain.com
ENV DOMAIN yourdomain.com

# update the package sources
RUN apt-get update -qq

# install packages
RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y \
  wget curl nano \
  apache2 libapache2-mod-php7.3 \
  php7.3 php7.3-cli php7.3-curl php7.3-gd php7.3-mysql \
  php7.3-zip php7.3-xml php7.3-ldap php7.3-mbstring \
  php7.3-mysql php7.3-common php7.3-json php7.3-opcache \
  php7.3-readline php7.3-mcrypt php7.3-intl &&\
  systemctl enable apache2

# install joomla
RUN wget https://downloads.joomla.org/cms/joomla3/3-9-10/Joomla_3-9-10-Stable-Full_Package.zip?format=zip &&\
  mkdir /var/www/html/joomla &&\
  unzip Joomla*.zip -d /var/www/html &&\
  chown -R www-data:www-data /var/www/html

# configure appache2
RUN printf "<VirtualHost *:80>\n" > /etc/apache2/sites-available/joomla.conf &&\
  printf "ServerAdmin $EMAIL\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "DocumentRoot /var/www/html\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "ServerName $DOMAIN\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "<Directory /var/www/html>\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "Options FollowSymLinks\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "AllowOverride All\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "Order allow,deny\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "allow from all\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "</Directory>\n\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "ErrorLog /var/log/apache2/joomla-error_log\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "CustomLog /var/log/apache2/joomla-access_log common\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "</VirtualHost>\n" >> /etc/apache2/sites-available/joomla.conf &&\
  ln -s /etc/apache2/sites-available/joomla.conf /etc/apache2/sites-enabled/joomla.conf

# package install is finished, clean up

RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* &&\
  rm -rf /tmp/* /var/tmp/*

CMD apache2ctl -D FOREGROUND
