#!/usr/bin/env bash
set -e

# exit 1
# paths
osx="$os/osx"

# Show banner
echo -e "############################"
echo -e "# Bootstrapping system ... #"
echo -e "############################"
echo

# Update homebrew
brew update

# Run each program
bash "$osx/apps.sh"
bash "$osx/binaries.sh"

# Remove outdated versions from the cellar
brew cleanup
brew cask cleanup

# Symlink the .bash_profile configuration file
if [[ ! -e "$HOME/.bash_profile" ]]; then
  ln -s "$osx/profile.sh" "$HOME/.bash_profile"
  echo -e "Symlinked \033[1m$osx/profile.sh\033[0m => \033[1m$HOME/.bash_profile\033[0m"
else
  echo -e "\033[1m$HOME/.bash_profile\033[0m already exists. Please remove it and bootstrap again."
fi

# Symlink the .zshrc configuration file
if [[ ! -e "$HOME/.zshrc" ]]; then
  ln -s "$osx/profile.sh" "$HOME/.zshrc"
  echo -e "Symlinked \033[1m$osx/profile.sh\033[0m => \033[1m$HOME/.zshrc\033[0m"
else
  echo -e "\033[1m$HOME/.zshrc\033[0m already exists. Please remove it and bootstrap again."
fi

# Symlink the .gitconfig configuration file
if [[ ! -e "$HOME/.gitconfig" ]]; then
  ln -s "$osx/git-config.sh" "$HOME/.gitconfig"
  echo -e "Symlinked \033[1m$osx/git-config.sh\033[0m => \033[1m$HOME/.gitconfig\033[0m"
else
  echo -e "\033[1m$HOME/.gitconfig\033[0m already exists. Please remove it and bootstrap again."
fi

# Install oh-my-zsh
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
rm -rf ~/.zshrc
mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc

# Set the defaults at the end such that when something fails here the apps and binaries are already installed
bash "$osx/defaults.sh"