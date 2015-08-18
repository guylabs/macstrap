#!/usr/bin/env bash
set -eu

# update brew and cask packages
brew update && brew upgrade brew-cask
brew upgrade

# cleanup
brew cleanup
brew cask cleanup
