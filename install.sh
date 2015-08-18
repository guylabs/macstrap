#!/usr/bin/env bash
set -eu
source version.sh

# Echo banner
source banner.sh

echo -e "Installing macstrap ..."

# Set the paths
dirname=$(pwd)
lib="/usr/local/lib"
bin="/usr/local/bin"
conf="$HOME/.macstrap"

# Create directories in case they aren't already there
mkdir -p $lib
mkdir -p $bin

# Remove existing macstrap if it exists
if [ -e "$lib/${PWD##*/}" ]; then
  rm -rf "$lib/${PWD##*/}"
fi

# Copy the macstrap to the lib folder
cp -R $dirname "$lib/"
echo -e "\t- Copied \033[1m${dirname}\033[0m to \033[1m${lib}\033[0m"

# Remove existing bin if it exists
if [ -L "$bin/macstrap" ]; then
  rm -f "$bin/macstrap"
fi

# Symlink macstrap
ln -s "$lib/macstrap/macstrap.sh" "$bin/macstrap"
echo -e "\t- Symlinked \033[1m${bin}/macstrap\033[0m to \033[1m${lib}/macstrap/macstrap.sh\033[0m"

# Create the config directory in user home
mkdir -p $conf
echo -e "\t- Created config directory at \033[1m${conf}\033[0m"

# Copy the skeleton configuration files to config directory
if [ ! -e "$conf/macstrap.cfg" ]; then
  cp "$lib/macstrap/conf/macstrap.cfg" "$conf/macstrap.cfg"
  echo -e "\t- Copied the skeleton configuration to \033[1m$conf/macstrap.cfg\033[0m"
fi

# if macstrap was installed with the base installation, then delete the extracted /tmp/macstrap folder again
if [ -e "/tmp/macstrap" ]; then
  rm -rf "/tmp/macstrap"
fi

echo -e "\t- Removed installation files"
echo -e "Finished installing macstrap. Checking if homebrew and cask is installed and up to date ..."
echo

# Check for homebrew
if test ! $(which brew); then
  echo "Installing homebrew ..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Updating homebrew ..."
  brew update
fi

# Install homebrew cask
echo "Installing homebrew cask ..."
brew install caskroom/cask/brew-cask

# Tap alternative versions
brew tap caskroom/versions

# Tap the fonts
brew tap caskroom/fonts

echo "#############################################################################"
echo
echo "Next steps: If you want to install additional binaries or apps to the default"
echo "ones please have a look at the \033[1m$conf/macstrap.cfg\033[0m file how to add these."
