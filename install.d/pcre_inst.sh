#!/bin/bash

echo "#################### PCRE BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi
is_ok

cd "$DEST"
is_installed pcre
is_ok

cd "$SRC"
pre_install pcre
is_ok

PCRE_SRC="$SRCDIR"
PCRE_DEST="$DEST"/pcre
cd $PCRE_SRC

echo "#################### Install $PCRE_SRC ####################"
./configure --prefix="$PCRE_DEST"
is_ok
make
make install &>$AIU/install.d/log/pcre_make_install.log
is_ok
save_pkg_dest pcre
is_ok
echo "#################### PCRE END ####################"
