#!/usr/bin/env bash
set -eu

# echo banner
source banner.sh

# paths
dirname=$(pwd)
lib="/usr/local/lib"
bin="/usr/local/bin"

# make in case they aren't already there
mkdir -p $lib
mkdir -p $bin

# remove existing macstrap if it exists
if [ -e "$lib/${PWD##*/}" ]; then
  rm -rf "$lib/${PWD##*/}"
fi

# copy the path
cp -R $dirname "$lib/"
echo -e "\t- Copied \033[1m${dirname}\033[0m to \033[1m${lib}\033[0m"

# remove existing bin if it exists
if [ -L "$bin/macstrap" ]; then
  rm -f "$bin/macstrap"
fi

# symlink macstrap
ln -s "$lib/macstrap/macstrap.sh" "$bin/macstrap"
echo -e "\t- Symlinked \033[1m${bin}/macstrap\033[0m to \033[1m${lib}/macstrap/macstrap.sh\033[0m"

# if macstrap was installed with the base installation, then delete the extracted /tmp/macstrap folder again
if [ -e "/tmp/macstrap" ]; then
  rm -rf "/tmp/macstrap"
fi

echo -e "\t- Removed installation files"
echo -e "Finished installing macstrap"
