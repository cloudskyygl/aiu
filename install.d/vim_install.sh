#!/bin/bash

echo "#################### VIM BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

echo "#################### Check If VIM Installed ####################"
VIM=`cat $AIU/install.conf | grep ^VIM | cut -d "=" -f 2`
echo "## Entering directory '$DEST'"
cd $DEST
is_installed $VIM

echo "#################### Handle VIM Requirements ####################"
apt_install libncurses5-dev

echo "#################### Install Subversion ####################"
echo "## Entering directory '$SRC'"
cd $SRC
pre_install $VIM
VIM_SOURCE=$SRCDIR
VIM_SRC=$SRC/$VIM_SOURCE
VIM_DEST=$DEST/$VIM
cd $VIM_SRC
./configure --prefix=$VIM_DEST \
--with-features=huge \
--enable-cscope \
--enable-fontset \
--enable-multibyte \
--enable-pythoninterp \
--enable-perlinterp
is_ok
make
is_ok
make install &>$AIU/install.d/log/vim_make_install.log
is_ok
make clean
save_pkg_dest vim
is_ok
echo "## Leaving directory '$VIM_SRC'"
cd $AIU
echo "#################### VIM END ####################"
