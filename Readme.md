# dots

WIP bootstrapping library for osx & ubuntu (and maybe others!)

## Installation

One-liner:

```
(mkdir -p /tmp/dots && cd /tmp/dots && curl -L https://github.com/guylabs/dots/archive/master.tar.gz | tar zx --strip 1 && sh ./install.sh)
```

## Mac OS X

The OSX build does the following:

- install homebrew
- installs binaries (graphicsmagick, python, sshfs, ack, git, etc.)
- sets OSX defaults
- installs applications via `homebrew-cask` (one-password, sublime-text, virtualbox, nv-alt, iterm2, etc.)
- sets up the ~/.bash_profile 

TODOs:

* Consider rewriting to be a cross-compiled Go project
* improve modularity (is there a way to source single functions from files?)
* generalize configuration (use secret gists for configuration)
* git-config
* ubuntu profile
* logging
* much more...

# License

MIT
