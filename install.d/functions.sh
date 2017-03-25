# Define  functions

function is_dir_exist() {
  if [ ! -d $1 ]; then
    echo "## WARNING: directory '$1' not found"
    exit
  fi
}

if [ -z $DEST ]; then
  DEST=$(cat $AIU/install.conf | grep ^DEST= | cut -d "=" -f 2)
  is_dir_exist $DEST
  export DEST
fi

if [ -z $SRC ]; then
  SRC=$(cat $AIU/install.conf | grep ^SRC= | cut -d "=" -f 2)
  is_dir_exist $SRC
  export SRC
fi

function is_ok() {
  status=$?
  if [ $status -ne 0 ]; then
    echo "## ERROR: command not executed correctly in $0"
    exit $status
  fi
}

# 该函数对目录的匹配有缺陷，非干净安装可能需要改进
# 没有处理已安装多个版本和目录名称开头相同但不是同一软件包的情况
# 例如：
# 已不考虑，使用遍历最后一个(最新版本)： 不能区分 PKG-VERSION1.0 和 PKG-VERSION2.0
# 可能已解决： 同样不能区分 PKG-VERSION 和 PKG-OTHERNAME-VERSION，因此要先安装 PKG 再安装 PKG-OTHERNAME
function is_installed() {

  dpkg_installed=`dpkg -l | awk '{print $2}' | grep "$1"`
  # [] 使用 -n 判断非空无效, 而 [[]] 有效
  if [[ -n $dpkg_installed ]]; then
    echo "## WARNING: $1 probably installed by DPKG:"
    for i in `dpkg -l | awk '{print $2}' | grep $1`
    do
      echo "DPKG: '$i'"
    done
  fi

  # 在 $DEST 下遍历名称符合 $1[-VERSION] 的目录
  # `ls | grep "^$1$\|$1-\?[0-9]\+"` 对版本号首位带字母的不适用
  # for i in `ls | grep "^$1$\|$1-\?[0-9]\+"`
  for i in $1*
  do
    if [ -d $i ]; then
      # 保存符合条件的最后一个项目,也即最新版本
      src_bin_installed=$i
    fi
  done
  unset i

  # 继续执行安装脚本
  if [ -z $src_bin_installed ]; then
    echo "## INFO: directory `pwd`/$1* not found"
    echo "## INFO: start installing $1"
    return 0
  fi

  # 退出安装脚本
  echo "## WARNING: directory '`pwd`/$src_bin_installed' found"
  echo "## INFO: stop script $0"
  exit

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
  apt-get -y update
  apt-get -y dist-upgrade
  apt-get -y install $*
  if [ $? -ne 0 ]; then
    echo "## ERROR: installing $* by APT occur errors"
    exit
  fi
}

# 可能已解决： 与函数 is_installed 一样，该函数对目录的匹配有缺陷，非干净安装可能需要改进
function pre_install() {

  # for i in `ls | grep "^$1$\|$1-\?[0-9]\+"`
  for i in $1*
  do
    if [ -d $i ]; then
      echo "## INFO: delete $1 source or binary decompressed directory: '$i'"
      rm -rf $i
    fi
  done
  unset i

  # for file in `ls | grep "^$1$\|$1-\?[0-9]\+"`
  for file in $1*
  do
    if [ -f $file ]; then
      getfile=$file
    fi
  done
  unset file

  if [ -z $getfile ]; then
    url=`cat $AIU/install.conf | grep ^$1_url= | cut -d "=" -f 2`
    if [ -z $url ]; then
      echo "## ERROR: missing downloading URL"
      exit
    fi
    dfile=`basename $url`
    echo "## INFO: download $dfile"
    wget $url
    if [ $? -ne 0 ]; then
      echo "## ERROR: downloading $dfile occur error"
      if [ -f $dfile ]; then
        rm -rf $dfile
      fi
      exit
    fi
    getfile=$dfile
    unset dfile
  fi

  echo "## INFO: extract $getfile"
  decompress $getfile
  is_ok

  # for dir in `ls | grep "^$1$\|$1-\?[0-9]\+"`
  for dir in $1*
  do
    if [ -d $dir ]; then
      SRCDIR=$dir
      echo "## $getfile extracted to directory '$SRCDIR'"
      unset getfile
      r=`cat $AIU/install.conf | grep ^$1_src=`
      if [ -z $r ]; then
        sed -i "/^# PKG_SRC$/a $1_src=$SRC/$SRCDIR" $AIU/install.conf
      fi
      sed -i "/^$1_src=/c $1_src=$SRC/$SRCDIR" $AIU/install.conf
      return 0
    fi
  done
  unset dir

  echo "## ERROR: $1 source archive not found, or extracting error"
  exit
}

function save_pkg_dest() {
  r=`cat $AIU/install.conf | grep ^$1_dest=`
  if [ -z $r ]; then
    sed -i "/^# PKG_DEST$/a $1_dest=$DEST/$1" $AIU/install.conf
  fi
    sed -i "/^$1_dest=/c $1_dest=$DEST/$1" $AIU/install.conf
}
