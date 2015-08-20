# Export PATH
export PATH=/usr/local/bin:$HOME/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH

# Put brew's ruby in front
export PATH=/usr/local/opt/ruby/bin:$PATH

# Use gnu tools instead
export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH

# Setup jEnv
export PATH=$HOME/.jenv/bin:$PATH
eval "$(jenv init -)"
jenv add `/usr/libexec/java_home`

# Use atom as default editor
EDITOR="atom"

# Add gradle properties
export GRADLE_OPTS="-Xmx2048m -Xms256m -XX:MaxPermSize=512m"

# Add bash completion (for git and others)
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

# Start an HTTP server from a directory, optionally specifying the port
function server() {
    local port="${1:-8000}"
    open "http://localhost:${port}/" && python -m SimpleHTTPServer "$port"
}

# On branches, this will return the branch name. (no branch) otherwise
git_branch() {
  ref="$(git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///')"
  if [[ "$ref" != "" ]]; then
    echo "$ref "
  fi
}

# Fastest possible way to check if repo is dirty
git_dirty() {
  # If the git status has *any* changes (e.g. dirty), echo our character
  if [[ -n "$(git status --porcelain 2> /dev/null)" ]]; then
    echo "☢ "
  fi
}

git_progress() {
  # Detect in-progress actions (e.g. merge, rebase)
  # https://github.com/git/git/blob/v1.9-rc2/wt-status.c#L1199-L1241
  git_dir="$(git rev-parse --git-dir)"

  # git merge
  if [[ -f "$git_dir/MERGE_HEAD" ]]; then
    echo "merge "
  elif [[ -d "$git_dir/rebase-apply" ]]; then
    # git am
    if [[ -f "$git_dir/rebase-apply/applying" ]]; then
      echo "am "
    # git rebase
    else
      echo "rebase "
    fi
  elif [[ -d "$git_dir/rebase-merge" ]]; then
    # git rebase --interactive/--merge
    echo "rebase "
  elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
    # git cherry-pick
    echo "cherry-pick "
  fi
  if [[ -f "$git_dir/BISECT_LOG" ]]; then
    # git bisect
    echo "bisect "
  fi
  if [[ -f "$git_dir/REVERT_HEAD" ]]; then
    # git revert --no-commit
    echo "revert "
  fi
}

# Add git to the terminal prompt
git_prompt() {
  # Don't go any further if we're not in a git repo
  git rev-parse --is-inside-work-tree &> /dev/null || return

  # Stylize
  echo -n $color_red
  echo -n "$(git_branch)"
  echo -n $color_reset
  echo -n $color_purple
  echo -n "$(git_progress)"
  echo -n $color_reset
  echo -n $color_yellow
  echo -n "$(git_dirty)"
  echo -n $color_reset
}

# colors
color_bold="\[$(tput bold)\]"
color_reset="\[$(tput sgr0)\]"
color_red="\[$(tput setaf 1)\]"
color_green="\[$(tput setaf 2)\]"
color_yellow="\[$(tput setaf 3)\]"
color_blue="\[$(tput setaf 4)\]"
color_purple="\[$(tput setaf 5)\]"
color_teal="\[$(tput setaf 6)\]"
color_white="\[$(tput setaf 7)\]"
color_black="\[$(tput setaf 8)\]"
bg_yellow="\[$(tput setab 3)\]"

## Customize the terminal input line
prompt() {
  PS1="$bg_yellow $color_reset ☁  $color_blue\W$color_reset $(git_prompt): "
}

PROMPT_COMMAND=prompt

###########
# Aliases #
###########

# Add hub
eval "$(hub alias -s)"

# Color ls
alias ls='ls --color=auto -ahF'

# Display as a list
alias ll='ls -1'

# Display the insides of a particular directory
alias lv='ls -R'

# Get the process on a given port
function port() {
  lsof -i ":${1:-80}"
}

# Update the number of open files
ulimit -n 1000

# Load ~/.bash_profile.local if it exists
if [[ -e $HOME/.bash_profile.local ]]; then
  source $HOME/.bash_profile.local
fi
