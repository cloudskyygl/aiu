#!/bin/bash

echo "#################### APR BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

echo "## Entering directory '$DEST'"
cd $DEST
is_installed apr

cd $SRC
pre_install apr
is_ok
APR_SRC=$SRCDIR
APR_DEST=$DEST/apr

cd $APR_SRC
echo "#################### Installing $APR_SRC ####################"
./configure --prefix=$APR_DEST
is_ok
make
make install &>$AIU/install.d/log/apr_make_install.log
is_ok
save_pkg_dest apr
is_ok
echo "#################### APR END ####################"
