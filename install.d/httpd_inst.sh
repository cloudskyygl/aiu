#!/bin/bash

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

cd $DEST
is_installed httpd
is_ok
cd $SRC

# requirements
echo "#################### Checking Requirements ####################"
$AIU/install.d/apr_inst.sh
$AIU/install.d/apr-util_inst.sh
$AIU/install.d/pcre_inst.sh
apt-get -y update
apt-get -y dist-upgrade
apt-get -y install autoconf
is_ok
APR_SRC=`cat $AIU/install.conf | grep -w apr_src | cut -d "=" -f 2`
APR_UTIL_SRC=`cat $AIU/install.conf | grep -w apr-util_src | cut -d "=" -f 2`
is_ok

pre_install httpd
is_ok
HTTPD_SRC=$SRCDIR
HTTPD_DEST=$DEST/httpd
echo $APR_UTIL_SRC

echo "#################### Installing $HTTPD_SRC ####################"
cd $HTTPD_SRC
./buildconf \
--with-apr=$APR_SRC \
--with-apr-util=$APR_UTIL_SRC
is_ok
./configure --prefix=$HTTPD_DEST \
--with-apr=$DEST/apr \
--with-apr-util=$DEST/apr-util \
--with-pcre=$DEST/pcre \
--enable-so \
--enable-ssl \
--with-ssl=/usr/bin \
--enable-dav \
--enable-maintainer-mode
is_ok
make
make install
is_ok
make clean
save_pkg_dest httpd
is_ok
echo "#################### Completing $HTTPD_SRC ####################"
