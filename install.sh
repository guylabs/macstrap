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
confMackup="$HOME/.mackup"

# Install the XCode command line tools first as GIT is needed by homebrew
if test ! $(which git); then
  echo -e "\t- First we need to install XCode command line tools. Please press the install button on the dialog ..."
  xcode-select --install > /dev/null 2>&1
  echo
  echo -e "\t\t- Press any key when the installation has completed."
  read -e
fi

# Create directories in case they aren't already there
echo -e "We need sudo rights to change the owner of the \033[1m/usr/local\033[0m folder to \033[1m$(whoami):admin\033[0m to create the \033[1m$lib\033[0m and \033[1m$bin\033[0m directories."
echo
sudo chown -R $(whoami):admin /usr/local
mkdir -p $lib
mkdir -p $bin

# Remove existing macstrap if it exists
if [ -d "$lib/${PWD##*/}" ]; then
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

# Copy the skeleton configuration files to config directory
if [ ! -e "$conf/macstrap.cfg" ]; then
  mkdir -p $conf
  cp -rn "$lib/macstrap/conf/macstrap.cfg" "$conf/macstrap.cfg"
  echo -e "\t- Copied the skeleton macstrap configuration to \033[1m$conf/macstrap.cfg\033[0m"
fi
if [ ! -e "$conf/themes" ]; then
  mkdir -p "$conf/themes"
  cp -rn "$lib/macstrap/conf/themes" "$conf/"
  echo -e "\t- Copied the skeleton macstrap themes to \033[1m$conf/themes\033[0m"
fi
if [ ! -e "$HOME/.mackup.cfg" ]; then
  cp -rn "$lib/macstrap/conf/.mackup.cfg" "$HOME/.mackup.cfg"
  echo -e "\t- Copied the skeleton mackup configuration to \033[1m$HOME/.mackup.cfg\033[0m"
fi
if [ ! -d "$HOME/.mackup" ]; then
  cp -rn "$lib/macstrap/conf/.mackup" $confMackup
  echo -e "\t- Copied the additional mackup configurations to \033[1m${confMackup}\033[0m"
fi

# if macstrap was installed with the base installation, then delete the extracted /tmp/macstrap folder again
if [ -e "/tmp/macstrap" ]; then
  rm -rf "/tmp/macstrap"
fi

echo -e "\t- Removed installation files"
echo -e "\t- Checking if homebrew, cask and mackup are installed and up to date ..."
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

# Install mackup
if test ! $(which mackup); then
  echo "Installing mackup ..."
  brew install mackup

  # prompt for the option to continue
  echo
  echo -e "\033[1mPlease select how to continue\033[0m (you can always backup the app configurations afterwards with 'macstrap backup'):"
  echo -e "[1] Back up the app configurations now"
  echo -e "[2] Do a dry run of the app configurations backup"
  echo -e "[3] Finish the installation of macstrap without backing up the app configurations"
  echo
  echo -n "Enter your decision: "

  # read the option and execute the according task
  read -e installMackupOption
  case $installMackupOption in
    "1" )
      # TODO: run 'mackup backup'
      echo "mackup backup is not implemented in version $version"
      ;;
    "2" )
      echo
      echo "mackup dry run: "
      mackup --dry-run --force backup
      ;;
    "3" )
      echo "Finishing the installation..."
      ;;
    *)
      echo "Nothing selected. Finishing installation..."
      ;;
  esac
fi

echo
echo -e "\033[1;34m##########################################"
echo -e "\033[1;34m# macstrap \033[0;33mv$version\033[1;34m successfully installed #"
echo -e "\033[1;34m##########################################\033[0m"
echo
echo -e "Next steps: Please have a look at the \033[1m${conf}/macstrap.cfg\033[0m configuration"
echo -e "file on how to configure macstrap."
