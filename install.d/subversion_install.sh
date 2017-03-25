#!/bin/bash

echo "#################### Subversion BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`;pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

echo "#################### Check If Subversion Installed ####################"
SUBVERSION=`cat $AIU/install.conf | grep ^SUBVERSION= | cut -d "=" -f 2`
echo "## Entering directory '$DEST'"
cd $DEST
is_installed $SUBVERSION

echo "#################### Handle Subversion Requirements ####################"
APR_DEST=`cat $AIU/install.conf | grep ^apr_dest= | cut -d "=" -f 2`
is_dir_exist $APR_DEST
APR_UTIL_DEST=`cat $AIU/install.conf | grep ^apr-util_dest= | cut -d "=" -f 2`
is_dir_exist $APR_UTIL_DEST
HTTPD_DEST=`cat $AIU/install.conf | grep ^httpd_dest= | cut -d "=" -f 2`
is_dir_exist $HTTPD_DEST

echo "#################### Install Subversion ####################"
echo "## Entering directory '$SRC'"
cd $SRC
pre_install $SUBVERSION
SUBVERSION_SOURCE=$SRCDIR
SUBVERSION_SRC=$SRC/$SUBVERSION_SOURCE
SUBVERSION_DEST=$DEST/$SUBVERSION
pre_install sqlite-amalgamation
SQLITE_AMALGAMATION_SOURCE=$SRCDIR
mv $SQLITE_AMALGAMATION_SOURCE sqlite-amalgamation
SQLITE_AMALGAMATION_SOURCE=sqlite-amalgamation
mv $SQLITE_AMALGAMATION_SOURCE $SUBVERSION_SOURCE
echo "## Entering directory '$SUBVERSION_SRC'"
cd $SUBVERSION_SRC
./configure --prefix=$SUBVERSION_DEST \
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
save_pkg_dest $SUBVERSION
is_ok
echo "## Leaving directory '$SUBVERSION_SRC'"
cd $AIU
echo "#################### Subversion END ####################"
