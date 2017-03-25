#!/bin/bash

echo "#################### APR BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

echo "#################### Check If APR Installed ####################"
APR=`cat $AIU/install.conf | grep ^APR= | cut -d "=" -f 2`
echo "## Entering directory '$DEST'"
cd $DEST
is_installed $APR

echo "#################### Installing APR ####################"
echo "## Entering directory '$SRC'"
cd $SRC
pre_install $APR
APR_SOURCE=$SRCDIR
APR_SRC=$SRC/$APR_SOURCE
APR_DEST=$DEST/$APR
echo "## Entering directory '$APR_SRC'"
cd $APR_SRC
./configure --prefix=$APR_DEST
is_ok
make
is_ok
make install &>$AIU/install.d/log/apr_make_install.log
is_ok
make clean
save_pkg_dest $APR
is_ok
echo "## Leaving directory '$APR_SRC'"
cd $AIU
echo "#################### APR END ####################"
