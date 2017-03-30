#!/bin/bash

echo "#################### MySQL BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

echo "#################### Check If MySQL Installed ####################"
echo "## Entering directory '$DEST'"
cd $DEST
is_installed mysql

echo "#################### Handle Requirements ####################"
apt_install libaio1

echo "#################### Install MySQL ####################"
echo "## Entering directory '$SRC'"
cd $SRC
preinstall_bin mysql $DEST
MYSQL_BINARY=$EXT_DIR
get_value mysql;MYSQL=$VALUE
mv $MYSQL_BINARY $MYSQL
MYSQL_DEST=$DEST/$MYSQL
# create group and user for running mysql
if [[ -z $(cat /etc/group | cut -d ":" -f 1 | grep "^mysql$") ]]; then
  groupadd mysql
fi
if [[ -z $(cat /etc/passwd | cut -d ":" -f 1 | grep "^mysql$") ]]; then
  useradd -r -M -g mysql -s /bin/false mysql
fi
# configure file etc/my.cnf and directory mysql-files
echo "## INFO: Entering directory $MYSQL_DEST"
cd $MYSQL_DEST
mkdir etc
cp support-files/my-default.cnf etc/my.cnf
sed -i "/# basedir/c basedir=$MYSQL_DEST" etc/my.cnf
sed -i "/# datadir/c datadir=$MYSQL_DEST/data" etc/my.cnf
mkdir mysql-files
chmod 750 mysql-files etc
chown -R mysql .
chgrp -R mysql .
## initialize mysql
# bin/mysqld --defaults-file=$MYSQL_DEST/etc/my.cnf \
bin/mysqld \
--initialize-insecure \
--user=mysql
bin/mysql_ssl_rsa_setup
chown -R root .
chown -R mysql data mysql-files
## start mysql by running background
bin/mysqld_safe --defaults-file=$MYSQL_DEST/etc/my.cnf --user=mysql &
# set mysql environment variables
echo -e '\n# mysql' >> /etc/profile.d/custom.sh
echo "PATH=$PATH:$MYSQL_DEST/bin" >> /etc/profile.d/custom.sh
# configure as system service
ln -s $MYSQL_DEST/support-files/mysql.server /etc/init.d/mysql
update-rc.d mysql defaults

set_value "mysql_dest" $MYSQL_DEST
echo "#################### MySQL END ####################"
