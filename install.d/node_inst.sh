#!/bin/bash

echo "#################### NODE BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`;pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

echo "## Entering directory '$DEST'"
cd $DEST
is_installed node
is_ok

echo "#################### Checking Requirements ####################"
apt_install clang
echo "## Entering directory '$SRC'"
cd $SRC
pre_install node
NODE_SRC=$SRCDIR
NODE_DEST=$DEST/node

echo "#################### Installing $NODE_SRC ####################"
echo "## Entering directory '$SRC/$NODE_SRC'"
cd $NODE_SRC
./configure --prefix=$NODE_DEST
is_ok
make -j4
is_ok
make doc
is_ok
./node -e "console.log('Hello from Node.js ' + process.version)"
is_ok
make install
is_ok
make clean
save_pkg_dest node
echo "## Leaving directory '$SRC/$NODE_SRC'"
cd $AIU
echo "#################### NODE BEGIN ####################"
