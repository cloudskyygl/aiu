#!/bin/bash

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

. functions.sh

echo $DEST
echo $SRC

get_value DEST;echo $VALUE
get_value SRC;echo $VALUE
get_value apr;echo $VALUE

test=asd_111_222
echo ${test%_*}

# get_value DEST; echo $VALUE

# cd $SRC

# is_dpkg_installed git

# 传给$1的字符串包含空格结果会不一样
# grep "$1" test-content

# is_installed_dpkg git

# cd $SRC
# get_value httpd;HTTPD=$VALUE;unset VALUE
# # echo $NODE
# get_archive $HTTPD
# # echo $ARCHIVE
# decompress $ARCHIVE
# get_ext_dir $HTTPD
# echo $EXT_DIR

# decompress node-v6.10.1.tar.gz ~

# set_value node_src

# function test() {
#   a=1
#   local b=2
# }
# test
# echo $a
# echo $b

# get_value DEST; echo "VALUE=$VALUE"
# get_value SRC; echo "VALUE=$VALUE"
# get_value asdf; echo "VALUE=$VALUE"
# get_value; echo "VALUE=$VALUE"
# get_value test;echo "VALUE=$VALUE"
# set_value test_src
# set_value test_src
# set_value test_dest
# get_value DEST; DEST=$VALUE
# unset DEST
# # DEST=
# echo ${DEST:?"asdf"}
# echo $DEST

# is_installed_dpkg git
# is_installed_src_bin git
# is_installed git

# download httpd
# decompress httpd-2.4.25.tar.gz
# get_archive httpd; echo "$ARCHIVE"
# get_ext_dir httpd; echo "$EXT_DIR"

# pre_install httpd


# cd /home/steven/linux-awesome/packages
# function decompress() {
#   case $1 in
#     # *.tar.gz)
#     #   tar zxf $1;;
#     # *.tar.bz2)
#     #   tar jxf $1;;
#     # *.tar.xz)
#     #   tar Jxf $1;;
#     *.zip)
#       unzip $1;;
#     *)
#       tar -axf $1;;
#   esac
# }
#
# decompress vim-8.0.069.tar.bz2

# function name() {
#   for i in `ls | grep "$1-\?[0-9]\+"`
  #   do
#     echo $i
#   done
# }
# name apr
# dpkg_installed=`dpkg -l | awk '{print $2}' | grep "$1"`
# # echo $dpkg_installed
# if [[ -n $dpkg_installed ]]; then
#   echo $dpkg_installed
#   echo
# fi
# sed -i '
# /GIT_DAEMON_ENABLE/s/=.*/=true/
# /GIT_DAEMON_USER/s/=.*/=git/
# /GIT_DAEMON_BASE_PATH/s/=.*/=\/opt\/git/
# /GIT_DAEMON_DIRECTORY/s/=.*/=\/opt\/git/
# /GIT_DAEMON_OPTIONS/s/".*"/"--reuseaddr --export-all --enable=upload-pack --enable=upload-archive --enable=receive-pack --informative-errors"/' /etc/default/git-daemon
