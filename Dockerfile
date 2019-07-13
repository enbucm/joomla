# Joomla! based on Debian Stretch
FROM debian:stretch
MAINTAINER H5.Technology <admin@h5tec.com>

# Set correct environment variables.
ENV HOME /root

# update the package s# install packages
RUN apt update && apt upgrade -y &&\
  apt install -y apt-transport-https lsb-release ca-certificates wget curl nano unzip apache2 &&\
  wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg &&\
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

RUN apt update && apt install -y libapache2-mod-php7.2 \
  php7.2 php7.2-cli php7.2-curl php7.2-gd php7.2-mysql \
  php7.2-zip php7.2-xml php7.2-ldap php7.2-mbstring \
  php7.2-mysql php7.2-common php7.2-json php7.2-opcache \
  php7.2-readline php7.2-intl php7.2-fpm

# install joomla
RUN cd /root/ &&\
  wget -O joomla.zip https://downloads.joomla.org/cms/joomla3/3-9-10/Joomla_3-9-10-Stable-Full_Package.zip?format=zip &&\
  mkdir -p /var/www/html/joomla &&\
  unzip joomla.zip -d /var/www/html/joomla &&\
  chown -R www-data:www-data /var/www/html/joomla &&\
  rm joomla.zip

# configure appache2
RUN printf "<VirtualHost *:80>\n\n" > /etc/apache2/sites-available/joomla.conf &&\
  printf "  ServerAdmin admin@domain.org\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "  DocumentRoot /var/www/html/joomla\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "  ServerName localhost\n\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "  <Directory /var/www/html/joomla>\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "    Options FollowSymLinks\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "    AllowOverride All\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "    Order allow,deny\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "    allow from all\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "  </Directory>\n\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "  ErrorLog /var/log/apache2/joomla-error_log\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "  CustomLog /var/log/apache2/joomla-access_log common\n\n" >> /etc/apache2/sites-available/joomla.conf &&\
  printf "</VirtualHost>\n" >> /etc/apache2/sites-available/joomla.conf &&\
  ln -s /etc/apache2/sites-available/joomla.conf /etc/apache2/sites-enabled/joomla.conf &&\
  a2enmod php7.2

# package install is finished, clean up
RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* &&\
  rm -rf /tmp/* /var/tmp/*

CMD apache2ctl -D FOREGROUND
