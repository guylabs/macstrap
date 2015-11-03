#!/usr/bin/env bash
set -e

# Show banner
echo -e "###########################"
echo -e "# Updating the system ... #"
echo -e "###########################"
echo

# update OS X software packages
echo -e "\t- Updating the OS X app store applications ..."
softwareupdate -ia

# update brew and cask packages
echo -e "\t- Updating the apps and binaries ..."
brew update
brew upgrade

# update apm packages
apm upgrade

# update nvm
if test $(which nvm); then
  echo -e "\t- Updating NVM ..."
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
fi

# update jEnv
if test $(which jenv); then
  echo -e "\t- Updating jEnv ..."
  cd ~/.jenv/ && git pull
fi

# update oh-my-zsh
if test $(which upgrade_oh_my_zsh); then
  echo -e "\t- Updating oh-my-zsh ..."
  upgrade_oh_my_zsh
fi

# cleanup
echo -e "\t- Cleaning up homebrew ..."
brew cleanup
brew cask cleanup
