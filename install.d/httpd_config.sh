#!/bin/bash

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

HTTPD_DEST=`cat $AIU/install.conf | grep -w httpd_dest | cut -d "=" -f 2`

if [ ! -d $HTTPD_DEST ]; then
  echo "Apache is not installed by AIU"
fi

if [ -z $(cat /etc/group | grep apache) ]; then
  groupadd apache
fi

if [ -z $(cat /etc/passwd | grep apache) ]; then
  useradd -r -M -g apache -s /bin/false apache
fi
sed -i '/User daemon/s/daemon/apache/g' $HTTPD_DEST/conf/httpd.conf
sed -i '/Group daemon/s/daemon/apache/g' $HTTPD_DEST/conf/httpd.conf
sed -i '/#ServerName www.example.com:80/c ServerName maze.org:80' $HTTPD_DEST/conf/httpd.conf

if [ ! -d /var/www ]; then
  mkdir /var/www
  chmod 750 /var/www
  chown -R apache:apache /var/www
fi
sed -i '/DocumentRoot ".*\/htdocs"/c DocumentRoot "/var/www"' $HTTPD_DEST/conf/httpd.conf
sed -i '/<Directory ".*\/htdocs">/c <Directory "/var/www">' $HTTPD_DEST/conf/httpd.conf
