#!/bin/bash

echo "#################### Git BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`;pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

echo "## Entering directory '$DEST'"
cd $DEST
is_installed git
is_ok

echo "#################### Checking Requirements ####################"
apt_install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev asciidoc xmlto docbook2x
echo "## Entering directory '$SRC'"
cd $SRC
pre_install git
GIT_SRC=$SRCDIR
GIT_DEST=$DEST/git

echo "#################### Installing $GIT_SRC ####################"
echo "## Entering directory '$SRC/$GIT_SRC'"
cd $GIT_SRC
make all doc info prefix=$GIT_DEST
is_ok
make install install-doc install-html install-info install-man prefix=$GIT_DEST
is_ok
make clean
save_pkg_dest git
echo "## Leaving directory '$SRC/$GIT_SRC'"
cd $AIU
echo "#################### Git END ####################"
