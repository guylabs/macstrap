#!/usr/bin/env bash
set -eu

#
# Application installer (via brew-cask)
#

# Check for Homebrew
if test ! $(which brew); then
  echo "Installing homebrew ..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Apps
apps=(
  1password
  alfred
  atom
  cyberduck
  dropbox
  firefox
  google-chrome
  intellij-idea
  iterm2
  java
  skype
  transmission
  virtualbox
  vlc
)

# Casks
casks=(
  font-clear-sans
  font-m-plus
  font-roboto
)

# Atom packages
atomPackages=()

# Specify the location of the apps
appdir="/Applications"

# Install homebrew-cask
echo "Installing homebrew cask ..."
brew tap phinze/homebrew-cask
brew install brew-cask

# Tap alternative versions
brew tap caskroom/versions

# Tap the fonts
brew tap caskroom/fonts

# Load the additional apps/casks/atom packages from the config file and merge it together with the default apps/casks/atom packages
source $config
appsToInstall=(`for item in "${apps[@]}" "${additionalApps[@]}" ; do echo "$item" ; done | sort -du`)
casksToInstall=(`for item in "${casks[@]}" "${additionalCasks[@]}" ; do echo "$item" ; done | sort -du`)
atomPackagesToInstall=(`for item in "${atomPackages[@]}" "${additionalAtomPackages[@]}" ; do echo "$item" ; done | sort -du`)

# Install apps
echo -e "Installing apps to \033[1m$appdir\033[0m ..."
brew cask install --appdir=$appdir ${appsToInstall[@]}

# Install casks
echo "Installing casks ..."
brew cask install ${casksToInstall[@]}

# Install atom packages
echo "Installing atom packages ..."
apm install ${atomPackagesToInstall[@]}

# Link with alfred
brew cask alfred link

# Remove outdated versions from the cellar
brew cleanup

exit 0
