#!/bin/bash

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

source $AIU/install.d/functions.sh

cd $DEST
is_installed vim
is_ok
cd $SRC
