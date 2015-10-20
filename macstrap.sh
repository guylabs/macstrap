#!/usr/bin/env bash
set -eu
source version.sh

# macstrap main
main() {

  # paths
  export dirname=$(dirname $(realpath $0))
  export lib="$dirname/lib"
  export os="$dirname/os"
  export config="$HOME/.macstrap/macstrap.cfg"

  if [ $# -eq 0 ]; then
    # if no argument is present show the usage
    usage
    exit
  else
    # run command
    case $1 in
      -v | --version )
        echo "macstrap ${version}"
        mackup --version
        exit
        ;;
      -h | --help )
        usage
        exit
        ;;
      reload )
        echo "Reloading the $HOME/.bash_profile ..."
        source "$HOME/.bash_profile"
        exit
        ;;
      boot )
        echo "Bootstrapping OS X ..."
        sh "$os/osx/index.sh"
        exit
        ;;
      update )
        update
        exit
        ;;
      "update macstrap" )
        update macstrap
        exit
        ;;
      backup )
        echo "mackup backup"
        exit
        ;;
      restore )
        echo "mackup restore"
        exit
        ;;
      *)
        usage
        exit
        ;;
    esac
  fi
}

# usage info
usage() {
  source banner.sh

  cat <<EOF

  Usage: macstrap [options] [command] [args ...]

  Options:

    -v, --version           Get the version
    -h, --help              This message

  Commands:

    reload                  Reload the .bash_profile
    boot                    Bootstrap OS X and install all configured apps, binaries etc.
    update                  Update all apps, binaries etc. and all OS X app store applications
    update macstrap         Update macstrap to the latest version
    backup                  Backup the app configurations with mackup
    restore                 Restore the app configurations with mackup

EOF
}

# update OS X or macstrap
update() {
  if [ $# -eq 0 ]; then
    # if no argument is present update the apps, binaries and OS X app store applications
    echo "Updating all apps, binaries etc. and the OS X app store applications ..."
    sh "$os/osx/update.sh"
  else
    if [ $1 = "macstrap" ]; then
      echo "Updating macstrap ..."
      updatemacstrap
    fi
  fi
}

# update macstrap via git
updatemacstrap() {
  mkdir -p /tmp/macstrap \
    && cd /tmp/macstrap \
    && curl -L https://github.com/guylabs/macstrap/archive/master.tar.gz | tar zx --strip 1 \
    && ./install.sh \
    && echo "Updated macstrap to $(macstrap --version)"
  exit
}

# "readlink -f" shim for Mac OS X
realpath() {
  target=$1
  cd `dirname $target`
  target=`basename $target`

  # iterate down a (possible) chain of symlinks
  while [ -L "$target" ]
  do
      target=`readlink $target`
      cd `dirname $target`
      target=`basename $target`
  done

  dir=`pwd -P`
  echo $dir/$target
}

# call main
main "$@"
