#########################
# General configuration #
#########################

# Export PATH
export PATH=/usr/local/bin:$HOME/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH

# Put brew's ruby in front
export PATH=/usr/local/opt/ruby/bin:$PATH

# Use gnu tools instead
export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH

# Use atom as default editor
EDITOR="atom"

# Update the number of open files
ulimit -n 1000

# Add bash completion (for git and others)
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

###########
# Aliases #
###########

# Color ls
alias ls='pwd; ls --color=auto -ahF'

# Display as a list
alias ll='pwd; ls -1ah'

# Display the insides of a particular directory
alias lv='pwd; ls -R'

###########################
# Oh-my-zsh configuration #
###########################

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# The ZSH theme to use
ZSH_THEME="agnoster"

# The plugins to use in the zsh shell
plugins=(atom git npm bower brew)

# Load the oh-my-zsh configuraiton file
source $ZSH/oh-my-zsh.sh

########################
# Gradle configuration #
########################

export GRADLE_OPTS="-Xmx2048m -Xms256m -XX:MaxPermSize=512m"

#####################
# NVM configuration #
#####################

export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# export Google Chrome and Firefox binaries used for Karma tests as karma is not
# able to find the hombrew installed versions
export CHROME_BIN="~/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
export FIREFOX_BIN="~/Applications/Firefox.app/Contents/MacOS/firefox"

######################
# jEnv configuration #
######################

export PATH=$HOME/.jenv/bin:$PATH
eval "$(jenv init -)"