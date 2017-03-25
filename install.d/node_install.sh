#!/bin/bash

echo "#################### NODE BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`;pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  . $AIU/install.d/functions.sh
fi

echo "#################### Check If Node Installed ####################"
NODE=`cat $AIU/install.conf | grep ^NODE= | cut -d "=" -f 2`
echo "## Entering directory '$DEST'"
cd $DEST
is_installed $NODE

echo "#################### Handle Requirements ####################"
apt_install clang

echo "#################### Install Node ####################"
echo "## Entering directory '$SRC'"
cd $SRC
pre_install $NODE
NODE_SOURCE=$SRCDIR
NODE_SRC=$SRC/$NODE_SOURCE
NODE_DEST=$DEST/$NODE
echo "## Entering directory '$NODE_SRC'"
cd $NODE_SRC
./configure --prefix=$NODE_DEST
is_ok
make -j4
is_ok
make doc
is_ok
./node -e "console.log('Hello from Node.js ' + process.version)"
is_ok
make install &>$AIU/install.d/log/node_make_install.log
is_ok
make clean
save_pkg_dest $NODE
is_ok
echo "## Leaving directory '$NODE_SRC'"
cd $AIU
echo "#################### NODE END ####################"
