#!/usr/bin/env bash
set -eu

# modules
source "$lib/symlink/index.sh"
source "$lib/is-osx/index.sh"

# Only run if on a Mac
if [[ 0 -eq `osx` ]]; then
  exit 0
fi

# exit 1
# paths
osx="$os/osx"

# Run each program
sh "$osx/defaults.sh"
sh "$osx/binaries.sh"
sh "$osx/apps.sh"

# Symlink the profile
if [[ ! -e "$HOME/.bash_profile" ]]; then
  symlink "$osx/profile.sh" "$HOME/.bash_profile"
  echo -e "Symlinked \033[1m$osx/profile.sh\033[0m => \033[1m$HOME/.bash_profile\033[0m"
  source $HOME/.bash_profile
else
  echo -e "\033[1m$HOME/.bash_profile\033[0m already exists. Please remove it and bootstrap again."
fi
