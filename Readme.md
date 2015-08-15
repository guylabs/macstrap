# macstrap

Bootstrapping library for OS X.

## Installation

One-liner:

```
mkdir -p /tmp/macstrap && cd /tmp/macstrap && curl -L https://github.com/guylabs/macstrap/archive/master.tar.gz | tar zx --strip 1 && sh ./install.sh
```

## Mac OS X

The OS X build does the following:

- install `homebrew`
- installs default binaries
- sets OS X defaults
- installs applications via `homebrew-cask`
- sets up the ~/.bash_profile

# License

The macstrap is available under the MIT license.

(c) Matthew Mueller - https://github.com/matthewmueller/dots
(c) Modifications by Guy Brand
