#!/bin/bash

echo "#################### MAVEN BEGIN ####################"

if [ -z $AIU ]; then
  AIU=$(dirname $(cd `dirname $0`; pwd))
fi

if [ -f $AIU/install.d/functions.sh ]; then
  source $AIU/install.d/functions.sh
fi

echo "#################### Check If MAVEN Installed ####################"
echo "## Entering directory '$DEST'"
cd $DEST
is_installed maven

echo "#################### Install MAVEN ####################"
echo "## Entering directory '$SRC'"
cd $SRC
preinstall_bin maven $DEST
MAVEN_BINARY=$EXT_DIR
get_value "maven";MAVEN=$VALUE
mv $MAVEN_BINARY $MAVEN
MAVEN_DEST=$DEST/$MAVEN
set_value "maven_dest" $MAVEN_DEST
MAVEN_HOME=$(cat /etc/profile.d/custom.sh | grep "^export MAVEN_HOME=")
if [[ -z $MAVEN_HOME ]]; then
  echo -e '\n# maven' >> $ENVVARS
  echo "export MAVEN_HOME=$MAVEN_DEST" >> $ENVVARS
  echo 'export PATH=$PATH:/$MAVEN_HOME/bin' >> $ENVVARS
fi
echo "#################### MAVEN END ####################"
