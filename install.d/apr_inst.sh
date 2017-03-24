#!/bin/bash

echo "#################### APR BEGIN ####################"

# set base directory AIU
if [ -z "$AIU" ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

# include file functions
if [ -f "$AIU"/install.d/functions.sh ]; then
  source "$AIU"/install.d/functions.sh
fi

# is_installed
cd "$DEST"
is_installed apr

# pre_install
cd "$SRC"
pre_install apr
is_ok
APR_SRC="$SRCDIR"
APR_DEST="$DEST"/apr

# install
cd "$APR_SRC"
echo "#################### Installing $APR_SRC ####################"
./configure --prefix="$APR_DEST"
is_ok
make
make install &>$AIU/install.d/log/apr_make_install.log
is_ok
save_pkg_dest apr
is_ok
echo "#################### APR END ####################"
