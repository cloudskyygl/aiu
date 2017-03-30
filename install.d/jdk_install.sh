#!/bin/bash

echo "#################### JDK BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

echo "#################### Check If JDK Installed ####################"
echo "## Entering directory '$DEST'"
cd $DEST
is_installed jdk

echo "#################### Install JDK ####################"
echo "## Entering directory '$SRC'"
cd $SRC
preinstall_bin jdk $DEST
JDK_BINARY=$EXT_DIR
get_value "jdk";JDK=$VALUE
mv $JDK_BINARY $JDK
JDK_DEST=$DEST/$JDK
set_value "jdk_dest" $JDK_DEST
JAVA_HOME=$(cat /etc/profile.d/custom.sh | grep "^export JAVA_HOME=")
if [[ -z $JAVA_HOME ]]; then
  echo -e '\n# java' >> $ENVVARS
  echo "export JAVA_HOME=$JDK_DEST" >> $ENVVARS
  echo 'export PATH=$PATH:/$JAVA_HOME/bin' >> $ENVVARS
fi
echo "#################### JDK END ####################"
