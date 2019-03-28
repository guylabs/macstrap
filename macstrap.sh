#!/usr/bin/env bash
set -euo pipefail

# macstrap main
main() {

  # load the version
  macstrapInstallFolder=$(dirname $(realpath $0))
  source "$macstrapInstallFolder/version.sh"

  # global variables
  export macstrapVersion="$version"
  export macstrapConfigFolder="$HOME/.macstrap"
  export macstrapConfigFile="$macstrapConfigFolder/macstrap.cfg"

  if [ $# -eq 0 ]; then
    # if no argument is present show the usage
    usage
    exit
  else
    # run command
    case $1 in
      -v | --version )
        echo "macstrap $version"
        exit
        ;;
      -h | --help )
        usage
        exit
        ;;
      install )
        executeCommand "install"
        exit
        ;;
      update )
        executeCommand "update"
        exit
        ;;
      "update-macstrap" )
        updatemacstrap
        exit
        ;;
      backup )
        executeCommand "backup"
        exit
        ;;
      restore )
        executeCommand "restore"
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
  source "$macstrapInstallFolder/banner.sh"

  cat <<EOF

  Usage: macstrap [options] [command] [args ...]

  Options:

    -v, --version           Get the version
    -h, --help              This message

  Commands:

    install                 Install configured apps and binaries
    update                  Update configured apps and binaries
    update-macstrap         Update macstrap to the latest version
    backup                  Backup the app configurations with mackup
    restore                 Restore the app configurations with mackup

EOF
}

# executes a command with pre and post hooks
executeCommand() {
  executeCustomScripts "pre-$1-"
  executeScript "$macstrapConfigFolder/commands/$1.sh"
  executeCustomScripts "post-$1-"
  echo -e "Finished executing command \033[1m$1\033[0m"
  echo
}

# executes the custom scripts with the specified prefix
executeCustomScripts() {
  for file in "$macstrapConfigFolder/custom-scripts/$1"*.sh
  do
    if [ -f "$file" ]; then
      executeScript $file
    fi
  done
}

# executes a script or does nothing if it does not exist
executeScript() {
  if [ -e $1 ]; then
    echo
    echo -e "Executing \033[1m$1\033[0m ..."
    echo
    source $1
    echo
    echo -e "Finished executing \033[1m$1\033[0m"
    echo
  else
    echo -e "Script \033[1m$1\033[0m does not exists. Doing nothing."
  fi
}

# update macstrap via git
updatemacstrap() {
  echo
  echo -e "Before upgrading macstrap to the latest version please check that your configured configuration repository is already migrated.";
  echo -e "Please check the update documentation on https://github.com/guylabs/macstrap on how to do that."
  echo
  echo -e "Press enter to continue updating macstrap..."
  read -e
  currentFolder=$(pwd)
  mkdir -p /tmp/macstrap \
    && cd /tmp/macstrap \
    && curl -L https://github.com/guylabs/macstrap/archive/master.tar.gz | tar zx --strip 1 \
    && bash ./install.sh \
    && cd $currentFolder \
    && rm -rf /tmp/macstrap \
    && echo "Updated macstrap from version $version to $(macstrap --version)"
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
