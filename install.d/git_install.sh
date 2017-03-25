#!/bin/bash

echo "#################### Git BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`;pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

echo "#################### Check If Git Installed ####################"
GIT=`cat $AIU/install.conf | grep ^GIT= | cut -d "=" -f 2`
echo "## Entering directory '$DEST'"
cd $DEST
is_installed $GIT

echo "#################### Handle Requirements ####################"
apt_install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev asciidoc xmlto docbook2x

echo "#################### Install Git ####################"
echo "## Entering directory '$SRC'"
cd $SRC
pre_install $GIT
GIT_SOURCE=$SRCDIR
GIT_SRC=$SRC/$GIT_SOURCE
GIT_DEST=$DEST/$GIT
echo "## Entering directory '$GIT_SRC'"
cd $GIT_SRC
make all doc info prefix=$GIT_DEST
is_ok
make install install-doc install-html install-info install-man prefix=$GIT_DEST
is_ok
make clean
save_pkg_dest $GIT
is_ok
echo "## Leaving directory '$GIT_SRC'"
cd $AIU
echo "#################### Git END ####################"
