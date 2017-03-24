# Define  functions

if [ -z $DEST ]; then
  DEST=$(cat $AIU/install.conf | grep -w DEST= | cut -d "=" -f 2)
  if [ ! -d $DEST ]; then
    echo "$DEST does not exists"
    exit
  fi
  export DEST
fi

if [ -z $SRC ]; then
  SRC=$(cat $AIU/install.conf | grep -w SRC= | cut -d "=" -f 2)
  if [ ! -d $SRC ]; then
    echo "$SRC does not exists"
    exit
  fi
  export SRC
fi

# 检查执行该函数的上一个命令的执行状态
function is_ok() {
  status=$?
  if [ ! $status -eq 0 ]; then
    echo "ERRORS OCCRE in script ' $0 '"
    exit $status
  fi
}

# 判断系统是否已经安装
# 注意，$1* 匹配模式默认目录名由 $1[VERSION] 组成，因此 $1* 只能识别不同版本。
# 例如，无法区分 apr[-VERSION] 和 apr-util[VERSION]
# 该函数所实现的删除可能造成误删，需要使用正则表达式来完善匹配
## return code: 0 表示将执行安装 1 表示将不执行安装
## 执行前需要切换到 $DEST
function is_installed() {

  for dir in $1*
  do
    if [ -d "$dir" ]; then
      inst_dirs="$inst_dirs $dir"
    fi
  done
  unset dir

  if [ -z "$inst_dirs" ]; then
    echo "START INSTALLING $1"
    return 0
  fi

  # 去掉 inst_dirs 开头的空格
  inst_dirs=${inst_dirs:1}

  echo -e "FOUND $1 installation in '`pwd`': $inst_dirs"

  # 将搜索到的第一个安装作为默认使用的安装
  inst_dirs_first=${inst_dirs%% *}
  if [ -d "`pwd`/$inst_dirs_first" ]; then
    echo "WARNING: '`pwd`/$1' will be used by AIU"
    sed -i "/$1=/c $1=`pwd`/$inst_dirs_first" $AIU/install.conf
    echo "STOP script $0"
    exit 0
  fi

  # while [ "$answer" != y -a "$answer" != n ]; do
  #   read -p "do you want to remove these installations and start a fresh installation ? (y or n):" answer
  # done
  #
  # if [ "$answer" == y ]; then
  #   echo "removing $inst_dirs"
  #   sleep 3
  #   for inst_dir in $inst_dirs
  #   do
  #     rm -rf $inst_dir
  #   done
  #   echo "done, newly installing is beginning..."
  #   sleep 3
  #   return 0
  # fi
  # if [ "$answer" == n ]; then
  #   if [ ! -d /usr/local/$1 ]
  #   then
  #     while [ ! -d "$inst" ]; do
  #       read -p "you must specify a installation which already exists: " inst
  #     done
  #       echo "configuring ..."
  #       sleep 3
  #       sed -i "/$1=/c $1=$inst" $AIU/install.conf
  #     return 1
  #   else
  #     echo "/usr/local/$1 already exists and will be used to continue"
  #     sleep 3
  #     sed -i "/$1=/c $1=/usr/local/$1" $AIU/install.conf
  #     return 1
  #   fi
  # fi
}

# 该函数执行前需切换到 $SRC
function pre_install() {

  # 删除已存在的解压后的源码目录
  for tmp in $1*
  do
    if [ -d "$tmp" ]; then
      echo "DELETING $1 temp source directory"
      rm -rf $tmp
    fi
  done

  # 遍历归档文件
  for getfile in $1*
  do
    if [ -f $getfile ]; then
      getfiles="$getfiles $getfile"
    fi
  done

  getfiles=${getfiles:1}

  # 下载源码归档文件
  if [ -z $getfiles ]; then

    echo "DOWNLOADING $1 source archive"
    url=`cat $AIU/install.conf | grep $1_url | cut -d "=" -f 2`
    wget $url
    is_ok
    # 获取下载文件名称
    getfiles=`basename $url`
  fi

  getfiles_first=${getfiles%% *}

  # 解压缩归档文件
  echo "EXTRACTING $1 source archive file: $getfiles_first"
  tar zxf $getfiles_first

  #获取解压缩后的目录名称
  for getdir in $1*
  do
    if [ -d $getdir ]; then
      SRCDIR=$getdir
      echo "EXTRACTING $1 source archive to directory '$getdir' DONE"
      r=`cat $AIU/install.conf | grep $1_src`
      if [ -z $r ]; then
        sed -i "/# PKG_SRC/a $1_src=$SRC/$SRCDIR" $AIU/install.conf
      fi
      sed -i "/$1_src=/c $1_src=$SRC/$SRCDIR" $AIU/install.conf
      return 0
    fi
  done

  echo "EXIT INSTALLING, $1 SOURCE ARCHIVE NOT FOUND, OR EXTRACTING ERROR"
  exit
}

function save_pkg_dest() {
  r=`cat $AIU/install.conf | grep -w $1_dest=`
  if [ -z $r ]; then
    sed -i "/# PKG_DEST/a $1_dest=$DEST/$1" $AIU/install.conf
  fi
    sed -i "/$1_dest=/c $1_dest=$DEST/$1" $AIU/install.conf
}
