#!/bin/bash

echo "#################### Subversion BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`;pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

cd $DEST
is_installed subversion
is_ok

echo "#################### Checking Requirements ####################"
APR_DEST=`cat $AIU/install.conf | grep -w apr_dest | cut -d "=" -f 2`
is_dir_exist $APR_DEST
APR_UTIL_DEST=`cat $AIU/install.conf | grep -w apr-util_dest | cut -d "=" -f 2`
is_dir_exist $APR_UTIL_DEST
HTTPD_DEST=`cat $AIU/install.conf | grep -w httpd_dest | cut -d "=" -f 2`
is_dir_exist $HTTPD_DEST

cd $SRC
pre_install subversion
SUBVERSION_SRC=$SRCDIR
SUBVERSION_DEST=$DEST

pre_install sqlite-amalgamation
SQLITE_AMALGAMATION_SRC=$SRCDIR
mv $SQLITE_AMALGAMATION_SRC sqlite-amalgamation
SQLITE_AMALGAMATION_SRC=sqlite-amalgamation
mv $SQLITE_AMALGAMATION_SRC $SUBVERSION_SRC

echo "#################### Installing $SUBVERSION_SRC ####################"
cd $SUBVERSION_SRC
./configure --prefix=$DEST \
--with-apr=$APR_DEST \
--with-apr-util=$APR_UTIL_DEST \
--with-apxs=$HTTPD_DEST/bin/apxs \
--enable-maintainer-mode
is_ok
make
is_ok
make install &>$AIU/install.d/log/subversion_make_install.log
is_ok
make clean
save_pkg_dest subversion
echo "#################### Subversion END ####################"
