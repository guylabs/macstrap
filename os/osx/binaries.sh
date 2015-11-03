#!/usr/bin/env bash
set -e

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes/grep

# Load the binaries and the global NPM packages from the config file
source $config

# Show banner
echo -e "#######################################################"
echo -e "# Installing the binaries and global NPM packages ... #"
echo -e "#######################################################"
echo

# Install binaries
if [ ${#binaries} -gt 0 ]; then
    echo -e "\t- Installing binaries ..."
    brew install ${binaries[@]}
else
    echo -e "\t- No binaries defined in macstrap configuration."
fi

# Install nvm
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  source "$HOME/.nvm/nvm.sh"
  nvm install stable
  nvm alias default stable
else
  echo -e "\t- NVM not installed as the ~/.nvm folder is already present."
fi


# Install NPM packages
if [ ${#globalNpmPackages} -gt 0 ]; then
    echo -e "\t- Installing global NPM packages within the NVM default..."
    npm install -g ${globalNpmPackages[@]}
else
    echo -e "\t- No global NPM packages defined in macstrap configuration."
fi

# Install jEnv
if [ ! -d "$HOME/.jenv" ]; then
  git clone https://github.com/gcuisinier/jenv.git ~/.jenv
  export PATH=$HOME/.jenv/bin:$PATH
  eval "$(jenv init -)"
  jenv add `/usr/libexec/java_home`
  jenv global 1.7
else
  echo -e "\t- jEnv not installed as the ~/.jenv folder is already present."
fi

exit 0
