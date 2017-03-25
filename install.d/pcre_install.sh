#!/bin/bash

echo "#################### PCRE BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

echo "#################### Check If PCRE Installed ####################"
PCRE=`cat $AIU/install.conf | grep ^PCRE= | cut -d "=" -f 2`
echo "## Entering directory '$DEST'"
cd $DEST
is_installed $PCRE

echo "#################### Install PCRE ####################"
echo "## Entering directory '$SRC'"
cd $SRC
pre_install $PCRE
PCRE_SOURCE=$SRCDIR
PCRE_SRC=$SRC/$PCRE_SOURCE
PCRE_DEST=$DEST/$PCRE
echo "## Entering directory '$PCRE_SRC'"
cd $PCRE_SRC
./configure --prefix=$PCRE_DEST
is_ok
make
is_ok
make install &>$AIU/install.d/log/pcre_make_install.log
is_ok
make clean
save_pkg_dest $PCRE
is_ok
echo "## Leaving directory '$PCRE_SRC'"
cd $AIU
echo "#################### PCRE END ####################"
