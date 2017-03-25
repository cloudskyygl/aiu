#!/bin/bash

echo "#################### HTTPD BEGIN ####################"
if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

cd $DEST
is_installed httpd
is_ok

# requirements
echo "#################### Checking Requirements ####################"
$AIU/install.d/apr_inst.sh
$AIU/install.d/apr-util_inst.sh
$AIU/install.d/pcre_inst.sh
apt_install autoconf
APR_SRC=`cat $AIU/install.conf | grep -w apr_src | cut -d "=" -f 2`
is_dir_exist $APR_SRC
APR_UTIL_SRC=`cat $AIU/install.conf | grep -w apr-util_src | cut -d "=" -f 2`
is_dir_exist $APR_UTIL_SRC

cd $SRC
pre_install httpd
is_ok
HTTPD_SRC=$SRCDIR
HTTPD_DEST=$DEST/httpd
cd $HTTPD_SRC

echo "#################### Installing $HTTPD_SRC ####################"
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
is_ok
make install &>$AIU/install.d/log/httpd_make_install.log
is_ok
make clean
save_pkg_dest httpd
echo "#################### HTTPD END ####################"
