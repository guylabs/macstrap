#!/usr/bin/env bash
set -eu

# Update homebrew
brew update

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep

# Load the binaries and the global NPM packages from the config file
source $config

# Install the binaries
brew install ${binaries[@]}

# Install the latest stable node version and the global npm packages
nvm install stable
nvm alias default stable
npm install -g ${globalNpmPackages[@]}

# Install oh-my-zsh
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh

# Remove outdated versions from the cellar
brew cleanup

exit 0
