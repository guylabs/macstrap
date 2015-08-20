#!/usr/bin/env bash
set -eu

# Update homebrew
brew update

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
  elasticsearch
  git
  gradle
  graphicsmagick
  jenv
  mackup
  maven
  node
  postgresql
  rename
  sshfs
  tomcat
  tree
  wget
)

globalNpmPackages=(
  bower
  grunt-cli
)

# Load the additional binaries from the config file and merge it together with the default binaries
source $config
binariesToInstall=(`for item in "${binaries[@]}" "${additionalBinaries[@]}" ; do echo "$item" ; done | sort -du`)
globalNpmPackagesInstall=(`for item in "${globalNpmPackages[@]}" "${additionalGlobalNpmPackages[@]}" ; do echo "$item" ; done | sort -du`)

# Install the binaries
brew install ${binariesToInstall[@]}

# Install global npm packages
npm install -g ${globalNpmPackagesInstall[@]}

# Install spot
if test ! $(which spot); then
  curl -L https://raw.githubusercontent.com/rauchg/spot/master/spot.sh -o /usr/local/bin/spot && chmod +x /usr/local/bin/spot
fi

# Remove outdated versions from the cellar
brew cleanup

exit 0
