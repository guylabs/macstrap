#!/usr/bin/env bash
set -eu
source version.sh

# echo banner
source banner.sh

echo -e "Installing macstrap ..."

# paths
dirname=$(pwd)
lib="/usr/local/lib"
bin="/usr/local/bin"
conf="$HOME/.macstrap"

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

# create config directory in user home
mkdir -p $conf

# copy skeleton configuration files to config directory
if [ ! -e "$conf/macstrap.cfg" ]; then
  cp "$lib/macstrap/conf/macstrap.cfg" "$conf/macstrap.cfg"
fi

echo -e "\t- Created config directory at \033[1m${conf}\033[0m"

# if macstrap was installed with the base installation, then delete the extracted /tmp/macstrap folder again
if [ -e "/tmp/macstrap" ]; then
  rm -rf "/tmp/macstrap"
fi

echo -e "\t- Removed installation files"
echo -e "Finished installing macstrap"
echo
echo "Next steps: If you want to install additional binaries or apps to the default"
echo "ones please have a look at the $conf/macstrap.cfg file how to add these."
