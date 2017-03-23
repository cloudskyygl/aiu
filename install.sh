#!/bin/bash

# PATH
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PATH

# set base directory AIU
 export AIU=$(cd `dirname $0`; pwd)

$AIU/install.d/install_apr.sh

# if [ -d "$AIU"/install.d ]; then
#   for i in "$AIU"/install.d/*.sh; do
#     if [ -r $i ]; then
#       $i
#       is_ok $i
#     fi
#   done
#   unset i
# fi
