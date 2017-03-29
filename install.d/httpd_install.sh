#!/bin/bash

echo "#################### HTTPD BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

echo "#################### Check If HTTPD Installed ####################"
echo "## Entering directory '$DEST'"
cd $DEST
is_installed httpd

echo "#################### Handle Requirements ####################"
apt_install autoconf
$AIU/install.d/apr_install.sh
$AIU/install.d/apr-util_install.sh
$AIU/install.d/pcre_install.sh
get_value apr_src;APR_SRC=$VALUE
is_dir_exist $APR_SRC
get_value apr-util_src;APR_UTIL_SRC=$VALUE
is_dir_exist $APR_UTIL_SRC
get_value apr_dest;APR_DEST=$VALUE
is_dir_exist $APR_DEST
get_value apr-util_dest;APR_UTIL_DEST=$VALUE
is_dir_exist $APR_UTIL_DEST
get_value pcre_dest;PCRE_DEST=$VALUE
is_dir_exist $PCRE_DEST

echo "#################### Install HTTPD ####################"
echo "## Entering directory '$SRC'"
cd $SRC
pre_install httpd
HTTPD_SOURCE=$EXT_DIR
HTTPD_SRC=$SRC/$HTTPD_SOURCE
get_value httpd;HTTPD=$VALUE
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
echo $(date) > $AIU/install.d/log/httpd_make_install.log
make install &>>$AIU/install.d/log/httpd_make_install.log
is_ok
make clean
set_value httpd_dest $HTTPD_DEST
is_ok
echo "## INFO: 'httpd' is installed to '$HTTPD_DEST'"
cd $AIU
echo "#################### HTTPD END ####################"
