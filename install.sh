#!/usr/bin/env bash
set -eu
source version.sh

# Echo banner
source banner.sh

echo
echo -e "####################################"
echo -e "# Installing/updating macstrap ... #"
echo -e "####################################"
echo

# Set the paths
dirname=$(pwd)
lib="/usr/local/lib"
bin="/usr/local/bin"
conf="$HOME/.macstrap"

# Install the XCode command line tools first as GIT is needed by homebrew
echo -e "First we need to install XCode command line tools. Please press the install button on the dialog ..."
xcode-select --install > /dev/null 2>&1 || true
echo
echo -e "If the installation failed, press Ctrl+c and execute the $(pwd)/install.sh script again ..."
echo
echo -e "When the installation is finished or no installation popped up, press any key to continue ..."
read -e

# Create directories in case they aren't already there
echo -e "We need sudo rights to change the owner of the \033[1m/usr/local\033[0m folder to \033[1m$(whoami):admin\033[0m to create the \033[1m$lib\033[0m and \033[1m$bin\033[0m directories."
echo
sudo mkdir -p $lib
sudo mkdir -p $bin
sudo chown -R `whoami` /usr/local/*

# Remove existing macstrap if it exists
if [ -d "$lib/${PWD##*/}" ]; then
  rm -rf "$lib/${PWD##*/}"
fi

# Copy the macstrap to the lib folder
cp -R $dirname "$lib/"
echo
echo -e "Copied \033[1m${dirname}\033[0m to \033[1m${lib}\033[0m"

# Remove existing bin if it exists
if [ -L "$bin/macstrap" ]; then
  rm -f "$bin/macstrap"
fi

# Symlink macstrap
ln -s "$lib/macstrap/macstrap.sh" "$bin/macstrap"
echo -e "Symlinked \033[1m${bin}/macstrap\033[0m to \033[1m${lib}/macstrap/macstrap.sh\033[0m"

# Setup the configuration if not already existent
if [ ! -e "$conf/macstrap.cfg" ]; then

  echo
  echo -e "\033[1mPlease select how to configure macstrap\033[0m:"
  echo -e "[1] Get the configuration from the default macstrap configuration GIT repository (no versioning support)"
  echo -e "[2] Get the configuration from a custom GIT repository"
  echo
  echo -n "Enter your decision: "
  echo

  # read the option and execute the according task
  read -e configureMacstrapOption

  # create the temporary directory to clone or copy the configuration
  mkdir -p $conf
  cd $conf

  case $configureMacstrapOption in
      "1")
          echo "Cloning the configuration from the default macstrap configuration GIT repository ..."
          git clone https://github.com/guylabs/macstrap-config.git $conf
          ;;
      "2")
          echo
          echo -e "\033[1mPlease enter the GIT repository URL where the macstrap configuration resides\033[0m:"
          read -e customGitUrl
          git clone $customGitUrl $conf
          ;;
      *)
          echo "No option selected. Cloning the configuration from the default macstrap configuration GIT repository ..."
          git clone https://github.com/guylabs/macstrap-config.git $conf
          ;;
  esac

else
  echo -e "Configuration folder \033[1m$conf\033[0m and \033[1m$conf/macstrap.cfg\033[0m file already exists."
fi

# if macstrap was installed with the base installation, then delete the extracted /tmp/macstrap folder again
if [ -e "/tmp/macstrap" ]; then
  cd ~/
  rm -rf "/tmp/macstrap"
fi

echo
echo -e "Removed installation files"
echo -e "Checking if homebrew and cask are installed and up to date ..."
echo

# Check for homebrew
if test ! $(which brew); then
  echo "Installing homebrew ..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Updating homebrew ..."
  brew update
fi

# Install homebrew cask
echo
echo "Installing homebrew cask services, versions and fonts..."

# Tap the services
brew tap homebrew/services

# Tap alternative versions
brew tap caskroom/versions

# Tap the fonts
brew tap caskroom/fonts

# Tap the drivers
brew tap caskroom/drivers

echo
echo -e "\033[1;34m##########################################"
echo -e "\033[1;34m# macstrap \033[0;33mv$version\033[1;34m successfully installed #"
echo -e "\033[1;34m##########################################\033[0m"
