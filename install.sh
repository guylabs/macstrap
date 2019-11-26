#!/bin/sh
set -euo
. version.sh

# Echo banner
. banner.sh

echo
echo "####################################"
echo "# Installing/updating macstrap ... #"
echo "####################################"
echo

# Set the paths
dirname=$(pwd)
lib="/usr/local/lib"
bin="/usr/local/bin"
conf="$HOME/.macstrap"

# Create directories in case they aren't already there
echo "We need sudo rights to change the owner of the \033[1m/usr/local\033[0m folder to \033[1m$(whoami):admin\033[0m to create the \033[1m$lib\033[0m and \033[1m$bin\033[0m directories."
echo
sudo mkdir -p $lib
sudo mkdir -p $bin
sudo chown -R "$(whoami)" /usr/local/*

echo
echo "Checking if homebrew is installed and up to date ..."
echo

# Check for homebrew
if test ! "$(hash brew)"; then
  echo "Installing homebrew ..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Updating homebrew ..."
  brew update
fi

# Install homebrew cask
echo
echo "Installing homebrew services, versions, fonts and drivers ..."

# Tap the services
brew tap homebrew/services

# Tap alternative versions
brew tap homebrew/cask-versions

# Tap the fonts
brew tap homebrew/cask-fonts

# Tap the drivers
brew tap homebrew/cask-drivers

# Remove existing macstrap if it exists
if [ -d "$lib/${PWD##*/}" ]; then
  rm -rf "$lib/${PWD##*/}"
fi

# Copy the macstrap to the lib folder
cp -R "$dirname" "$lib/"
echo
echo "Copied \033[1m${dirname}\033[0m to \033[1m${lib}\033[0m"

# Remove existing bin if it exists
if [ -L "$bin/macstrap" ]; then
  rm -f "$bin/macstrap"
fi

# Symlink macstrap
ln -s "$lib/macstrap/macstrap.sh" "$bin/macstrap"
echo "Symlinked \033[1m${bin}/macstrap\033[0m to \033[1m${lib}/macstrap/macstrap.sh\033[0m"

# Setup the configuration if not already existent
if [ ! -e "$conf/macstrap.cfg" ]; then

  echo
  echo "\033[1mPlease select how to configure macstrap\033[0m:"
  echo "[1] Get the configuration from the default macstrap configuration GIT repository (no versioning support)"
  echo "[2] Get the configuration from a custom GIT repository"
  echo
  printf "Enter your decision: "
  echo

  # create the temporary directory to clone or copy the configuration
  mkdir -p "$conf"
  cd "$conf"

  # read the option and execute the according task
  if [ $# -eq 0 ]; then
    read -r configureMacstrapOption
    case $configureMacstrapOption in
        "1")
            echo "Cloning the configuration from the default macstrap configuration GIT repository ..."
            git clone https://github.com/guylabs/macstrap-config.git $conf
            ;;
        "2")
            echo
            echo "\033[1mPlease enter the GIT repository URL where the macstrap configuration resides\033[0m:"
            read -r customGitUrl
            git clone $customGitUrl $conf
            ;;
        *)
            echo "No option selected. Cloning the configuration from the default macstrap configuration GIT repository ..."
            git clone https://github.com/guylabs/macstrap-config.git $conf
            ;;
    esac

  else
    echo "Cloning the configuration from the given macstrap configuration GIT repository: $1"
    git clone "$1" "$conf"
  fi

else
  echo "Configuration folder \033[1m$conf\033[0m and \033[1m$conf/macstrap.cfg\033[0m file already exists."
fi

# if macstrap was installed with the base installation, then delete the extracted /tmp/macstrap folder again
if [ -e "/tmp/macstrap" ]; then
  cd ~/
  rm -rf "/tmp/macstrap"
  echo
  echo "Removed installation files"
fi

echo
echo "\033[1;34m##########################################"
echo "\033[1;34m# macstrap \033[0;33mv$version\033[1;34m successfully installed #"
echo "\033[1;34m##########################################\033[0m"
