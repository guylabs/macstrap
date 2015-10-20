#!/usr/bin/env bash
set -eu

# update OS X software packages
echo "Updating the OS X app store applications ..."
softwareupdate -ia

# update brew and cask packages
echo "Updating the apps and binaries ..."
brew update && brew upgrade brew-cask
brew upgrade

# update oh-my-zsh
upgrade_oh_my_zsh

# cleanup
echo "Cleaning up ..."
brew cleanup
brew cask cleanup
