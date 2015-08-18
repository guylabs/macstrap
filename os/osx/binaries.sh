#!/usr/bin/env bash
set -eu

#
# Binary installer
#

# Check for Homebrew
if test ! $(which brew); then
  echo "Installing homebrew ..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew
brew update && brew upgrade brew-cask

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep

# Install other useful binaries
binaries=(
  ack
  atom
  elasticsearch
  fish
  git
  gradle
  graphicsmagick
  jenv
  mackup
  node
  postgresql
  rename
  sshfs
  tomcat
  tree
  wget
)

# Load the additional binaries from the config file and merge it together with the default binaries
source $config
binariesToInstall=(`for item in "${binaries[@]}" "${additionalBinaries[@]}" ; do echo "$item" ; done | sort -du`)

# Install the binaries
brew install ${binariesToInstall[@]}

# Install spot
if test ! $(which spot); then
  curl -L https://raw.githubusercontent.com/rauchg/spot/master/spot.sh -o /usr/local/bin/spot && chmod +x /usr/local/bin/spot
fi

# Remove outdated versions from the cellar
brew cleanup

exit 0
