# Define  functions

function is_dir_exist() {
  if [ ! -d $1 ]; then
    echo "## $1 does not exists"
    exit
  fi
}

if [ -z $DEST ]; then
  DEST=$(cat $AIU/install.conf | grep -w DEST= | cut -d "=" -f 2)
  is_dir_exist $DEST
  export DEST
fi

if [ -z $SRC ]; then
  SRC=$(cat $AIU/install.conf | grep -w SRC= | cut -d "=" -f 2)
  is_dir_exist $SRC
  export SRC
fi

function is_ok() {
  status=$?
  if [ ! $status -eq 0 ]; then
    echo "## ERRORS OCCRE in script ' $0 '"
    exit $status
  fi
}

function is_installed() {

  for i in $1*
  do
    if [ -d $i ]; then
      inst_dir=$i
    fi
  done
  unset i

  if [ -z $inst_dir ]; then
    echo "## START INSTALLING $1"
    return 0
  fi

  echo "## FOUND $1 in `pwd`/$inst_dir"
  echo "## STOP script $0"
  exit 0

}

function decompress() {
  case $1 in
    *.tar.gz)
      tar zxf $1;;
    *.tar.bz2)
      tar jxf $1;;
    *.tar.xz)
      tar Jxf $1;;
    *.zip)
      unzip $1;;
  esac
}

function apt_install() {
  apt-get -y update > /dev/null
  apt-get -y dist-upgrade > /dev/null
  apt-get -y install $*
  if [[ $? != 0 ]]; then
    echo "## apt-get ERROR"
    exit
  fi
}

function pre_install() {

  for i in $1*
  do
    if [ -d $i ]; then
      echo "## DELETING $1 temp source directory"
      rm -rf $i
    fi
  done

  for file in $1*
  do
    if [ -f $file ]; then
      getfile=$file
    fi
  done

  if [ -z $getfile ]; then
    echo "## DOWNLOADING $1 source archive"
    url=`cat $AIU/install.conf | grep $1_url | cut -d "=" -f 2`
    wget $url
    if [ ! $? -eq 0 ]; then
      echo "## DOWNLOADING ERROR"
      downloaded_file=`basename $url`
      if [ -f $downloaded_file ]; then
        rm -rf $downloaded_file
      fi
      exit
    fi
    getfile=`basename $url`
  fi

  echo "## EXTRACTING $1 source archive: $getfile"
  decompress $getfile
  unset getfile

  for dir in $1*
  do
    if [ -d $dir ]; then
      SRCDIR=$dir
      echo "## EXTRACTING $1 source archive to directory '$SRCDIR' DONE"
      r=`cat $AIU/install.conf | grep $1_src`
      if [ -z $r ]; then
        sed -i "/# PKG_SRC/a $1_src=$SRC/$SRCDIR" $AIU/install.conf
      fi
      sed -i "/$1_src=/c $1_src=$SRC/$SRCDIR" $AIU/install.conf
      return 0
    fi
  done

  echo "## EXIT INSTALLING, $1 SOURCE ARCHIVE NOT FOUND, OR EXTRACTING ERROR"
  exit
}

function save_pkg_dest() {
  r=`cat $AIU/install.conf | grep -w $1_dest`
  if [ -z $r ]; then
    sed -i "/# PKG_DEST/a $1_dest=$DEST/$1" $AIU/install.conf
  fi
    sed -i "/$1_dest=/c $1_dest=$DEST/$1" $AIU/install.conf
}
