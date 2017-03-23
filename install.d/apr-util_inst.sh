#!/bin/bash

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi
is_ok

cd "$DEST"
is_installed apr-util
is_ok

cd "$SRC"
pre_install apr-util
is_ok

APR_UTIL_SRC="$SRCDIR"
APR_UTIL_DEST="$DEST"/apr-util
cd "$APR_UTIL_SRC"

echo "#################### Install $APR_UTIL_SRC ####################"
./configure --prefix="$APR_UTIL_DEST" \
--with-apr="$DEST"/apr
is_ok
make
make install
is_ok
save_pkg_dest apr-util
is_ok
echo "#################### Completing $APR_UTIL_SRC ####################"
