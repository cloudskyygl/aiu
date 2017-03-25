#!/bin/bash

echo "#################### VIM BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

source $AIU/install.d/functions.sh

cd $DEST
is_installed vim
is_ok

apt-get -y update
apt-get -y install libncurses5-dev
is_ok

cd $SRC
pre_install vim
is_ok
VIM_SRC=$SRCDIR
VIM_DEST=$DEST/vim

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
echo "#################### VIM END ####################"
