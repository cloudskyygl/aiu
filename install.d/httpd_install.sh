#!/bin/bash

echo "#################### HTTPD BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

echo "#################### Check If HTTPD Installed ####################"
HTTPD=`cat $AIU/install.conf | grep ^HTTPD= | cut -d "=" -f 2`
echo "## Entering directory '$DEST'"
cd $DEST
is_installed $HTTPD

echo "#################### Handle Requirements ####################"
apt_install autoconf
$AIU/install.d/apr_install.sh
$AIU/install.d/apr-util_install.sh
$AIU/install.d/pcre_install.sh
APR_SRC=`cat $AIU/install.conf | grep ^apr_src= | cut -d "=" -f 2`
is_dir_exist $APR_SRC
APR_UTIL_SRC=`cat $AIU/install.conf | grep ^apr-util_src= | cut -d "=" -f 2`
is_dir_exist $APR_UTIL_SRC
APR_DEST=`cat $AIU/install.conf | grep -w ^apr_dest= | cut -d "=" -f 2`
is_dir_exist $APR_DEST
APR_UTIL_DEST=`cat $AIU/install.conf | grep ^apr-util_dest= | cut -d "=" -f 2`
is_dir_exist $APR_UTIL_DEST
PCRE_DEST=`cat $AIU/install.conf | grep ^pcre_dest= | cut -d "=" -f 2`
is_dir_exist $PCRE_DEST

echo "#################### Install HTTPD ####################"
echo "## Entering directory '$SRC'"
cd $SRC
pre_install $HTTPD
HTTPD_SOURCE=$SRCDIR
HTTPD_SRC=$SRC/$HTTPD_SOURCE
HTTPD_DEST=$DEST/$HTTPD
echo "## Entering directory '$HTTPD_SRC'"
cd $HTTPD_SRC
./buildconf \
--with-apr=$APR_SRC \
--with-apr-util=$APR_UTIL_SRC
is_ok
./configure --prefix=$HTTPD_DEST \
--with-apr=$APR_DEST \
--with-apr-util=$APR_UTIL_DEST \
--with-pcre=$PCRE_DEST \
--enable-so \
--enable-ssl \
--with-ssl=/usr/bin \
--enable-dav \
--enable-maintainer-mode
is_ok
make
is_ok
make install &>$AIU/install.d/log/httpd_make_install.log
is_ok
make clean
save_pkg_dest $HTTPD
is_ok
echo "## Leaving directory '$HTTPD_SRC'"
cd $AIU
echo "#################### HTTPD END ####################"
