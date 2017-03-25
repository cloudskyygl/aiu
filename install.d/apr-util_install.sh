#!/bin/bash

echo "#################### APR-Util BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

echo "#################### Check If APR-Util Installed ####################"
APR_UTIL=`cat $AIU/install.conf | grep ^APR-UTIL= | cut -d "=" -f 2`
echo "## Entering directory '$DEST'"
cd $DEST
is_installed $APR_UTIL

echo "#################### Handle Requirements ####################"
$AIU/install.d/apr_install.sh
APR_DEST=`cat $AIU/install.conf | grep ^apr_dest= | cut -d "=" -f 2`
is_dir_exist $APR_DEST

echo "#################### Install APR-Util ####################"
echo "## Entering directory '$SRC'"
cd $SRC
pre_install $APR_UTIL
APR_UTIL_SOURCE=$SRCDIR
APR_UTIL_SRC=$SRC/$APR_UTIL_SOURCE
APR_UTIL_DEST=$DEST/$APR_UTIL
echo "## Entering directory '$APR_UTIL_SRC'"
cd $APR_UTIL_SRC
./configure --prefix=$APR_UTIL_DEST \
--with-apr=$APR_DEST
is_ok
make
is_ok
make install &>$AIU/install.d/log/apr-util_make_install.log
is_ok
make clean
save_pkg_dest $APR_UTIL
is_ok
echo "## Leaving directory '$APR_UTIL_SRC'"
cd $AIU
echo "#################### APR-Util END ####################"
