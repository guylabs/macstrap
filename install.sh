#!/bin/sh
set -e
. version.sh
. utils.sh

# Echo banner
. banner.sh

echo
echo "####################################"
echo "# Installing/updating macstrap ... #"
echo "####################################"
echo

defaultConfigGitRepositoryUrl="https://github.com/guylabs/macstrap-config.git"

# Set the paths
dirname=$(pwd)
lib="/usr/local/lib"
bin="/usr/local/bin"
conf="$HOME/.macstrap"

# Create directories in case they aren't already there
printf "We need sudo rights to change the owner of the \033[1m/usr/local\033[0m folder to \033[1m%s:admin\033[0m to create the \033[1m%s\033[0m and \033[1m%s\033[0m directories.\n" "$(whoami)" "$lib" "$bin"
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
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if isArmArchitecture; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(brew --prefix)/bin/brew shellenv"
  fi
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
  rm -rf "${lib:?}/${PWD##*/}"
fi

# Copy the macstrap to the lib folder
cp -R "$dirname" "$lib/"
echo
printf "Copied \033[1m%s\033[0m to \033[1m%s\033[0m\n" "$dirname" "$lib"

# Remove existing bin if it exists
if [ -L "$bin/macstrap" ]; then
  rm -f "$bin/macstrap"
fi

# Symlink macstrap
ln -s "$lib/macstrap/macstrap.sh" "$bin/macstrap"
printf "Symlinked \033[1m%s/macstrap\033[0m to \033[1m%s/macstrap/macstrap.sh\033[0m\n" "$bin" "$lib"

# Setup the configuration if not already existent
if [ ! -e "$conf/macstrap.cfg" ]; then

  # create the temporary directory to clone or copy the configuration
  mkdir -p "$conf"
  cd "$conf"

  if [ -z "$1" ]; then

    echo
    printf "\033[1mPlease provide the configuration for macstrap\033[0m:\n"
    echo "  The configuration of macstrap is based on a GIT repository. You can enter a custom HTTPS URL which points to a GIT repository,"
    echo "  or do not provide a URL and the default GIT repository is used instead: $defaultConfigGitRepositoryUrl"
    echo
    echo "  When using a secured Git repository and you configured 2 factor authentication, use the given access token as password when requested to enter the credentials."
    echo 
    printf "Configuration GIT repository HTTPS URL: "
    echo

    read -r customGitUrl

    if [ -z "$customGitUrl" ]; then
      printf "Using default GIT repository: $defaultConfigGitRepositoryUrl"
      echo
      git clone "$defaultConfigGitRepositoryUrl" "$conf"
    else
      git clone "$customGitUrl" "$conf"
    fi
  else
    printf "Unattended installation with configuration GIT repository: \033[1m%s\033[0m\n" "$1"
    git clone "$1" "$conf"
  fi
else
  printf "Configuration folder \033[1m%s\033[0m and \033[1m%s/macstrap.cfg\033[0m file already exists.\n" "$conf" "$conf"
fi

# if macstrap was installed with the base installation, then delete the extracted /tmp/macstrap folder again
if [ -e "/tmp/macstrap" ]; then
  cd ~/
  rm -rf "/tmp/macstrap"
  echo
  echo "Removed installation files"
fi

echo
printf "\033[1;34m##########################################\n"
printf "\033[1;34m# macstrap \033[0;33mv%s\033[1;34m successfully installed #\n" "$version"
printf "\033[1;34m##########################################\033[0m\n"
