[![Build Status](https://travis-ci.org/guylabs/macstrap.svg?branch=master)](https://travis-ci.org/guylabs/macstrap)

# macstrap

> Easily set up your OS X from scratch.

macstrap is a command line tool to simplify the initial setup or the reinstallation of command line tools and GUI
applications in OS X. To install and keep them up to date macstrap uses [homebrew](http://brew.sh) for the command
line tools and [homebrew cask](http://caskroom.io) for the GUI applications.

When a reinstallation of an already setup OS X is needed then macstrap is able to first store the configuration of the
configured applications for example in a dropbox folder, on an external hard drive, etc. to be able to restore it
again when the OS X is reinstalled. This saves you time and additionally you have a backup of your application configurations.
Underneath macstrap uses [mackup](https://github.com/lra/mackup) to store and retrieve the configurations again. Please check the projects site to see what it is able to backup for you.

#Table of contents

- [Requirements](#requirements)
- [Installation and update](#installation-and-update)
- [Configuration](#configuration)
    - [Default configuration](#default-configuration)
    - [Custom configuration](#custom-configuration)
    - [Migrating the configuration](#migrating-the-configuration)
- [Commands](#commands)
    - [`install`](#install)
    - [`update`](#update)
    - [`update macstrap`](#update-macstrap)
    - [`backup`](#backup)
    - [`restore`](#restore)
- [Acknowledgements](#acknowledgements)
- [License](#license)

## Requirements

macstrap has been tested on OS X 10.13+ and therefore this is needed as requirement. It is possible that it
also works with earlier versions of OS X but this is not supported.

## Installation and update

First read the [Configuration](#configuration) section as it is important how you want to configure macstrap. Also have
a look at the [Migrating the configuration](#migrating-the-configuration) section before you update such that everything
is still working properly with the new version of macstrap. After that you can install or update macstrap by executing the following line.

```shell
mkdir -p /tmp/macstrap && cd /tmp/macstrap && curl -L https://github.com/guylabs/macstrap/archive/master.tar.gz | tar zx --strip 1 && bash ./install.sh && rm -rf /tmp/macstrap && cd ~
```

This will install macstrap to the `/usr/local/lib` folder and create proper symlinks in the `/usr/local/bin` folder such
that you are easily able to execute the `macstrap` command from the command line. It will also install the following required
applications:

* The OS X command line tools which macstrap needs for Git
* [homebrew](http://brew.sh) to install the command line tools.
* [homebrew cask](http://caskroom.io) to install the GUI applications.

When you are asked to select how to configure macstrap choose the default option, or use your custom configuration.

If you already have macstrap installed the install script will replace the old version and keep your configurations.

When done exeute `macstrap install` to install the command line tools and GUI applications, based on the configuration set above.

## Configuration

macstrap is configured with a so called "configuration GIT repository" to enable versioning (tagging and branching) of the configuration.
While installing macstrap you will be asked how to configure macstrap and are able to select the default configuration which I use or
point to a GIT repository where your custom configuration resides.

Please have a look at the following sections to see what the default configuration contains and how to create a custom configuration.

### Default configuration

The default macstrap configuration resides in the [`macstrap-config`](https://github.com/guylabs/macstrap-config) GIT repository.
This repository is built up with the needed structure and contains all required default scripts and configurations which I use for my setup.

Please have a look at the [`macstrap.cfg`](https://github.com/guylabs/macstrap-config/blob/master/macstrap.cfg) to see which apps,
command line tools etc. will be installed if you choose the default configuration.

### Custom configuration

If you want to create a custom configuration please follow these steps:

1. Fork the [`macstrap-config`](https://github.com/guylabs/macstrap-config) repository as this also serves as template configuration repository.
2. Checkout the `README.md` files in each folder to see how to customize your configuration and have a look at the default scripts how they are built up.
3. When you finished the customizations then please commit and push the changes to your repository.
4. When you now install macstrap then please choose to select your own GIT repository and then point to the HTTPS clone URL of your customized configuration repository.

### Migrating the configuration

When you upgrade to a newer version of macstrap then please check the changes done in the default [`macstrap-config`](https://github.com/guylabs/macstrap-config) GIT repository
and adapt it with your version. You can easily compare the two repositories as you did a fork of the default one. This way you can easily merge the changes and update
your custom repository.

## Commands

macstrap offers several commands which are used to install or update the system. The following sections describe all available commands.

### `install`

This command will execute the [`install.sh`](https://github.com/guylabs/macstrap-config/blob/master/commands/install.sh) of the defined configuration repository.
In the default configuration it will install all GUI applications and command line tools which are defined in the [`macstrap-config`](https://github.com/guylabs/macstrap-config) repository.

### `update`

This command will execute the [`update.sh`](https://github.com/guylabs/macstrap-config/blob/master/commands/update.sh) of the defined configuration repository.
In the default configuration it will update all GUI applications and command line tools to the latest available version with the help of [homebrew](http://brew.sh) and [homebrew cask](http://caskroom.io).

### `update-macstrap`

This command will download the newest master version of macstrap and execute the `install.sh` script to update macstrap.

### `backup`

This command will execute the [`backup.sh`](https://github.com/guylabs/macstrap-config/blob/master/commands/backup.sh) of the defined configuration repository.
In the default configuration it will use [mackup](https://github.com/lra/mackup) to backup the configurations.

### `restore`

This command will execute the [`restore.sh`](https://github.com/guylabs/macstrap-config/blob/master/commands/restore.sh) of the defined configuration repository.
In the default configuration it will use [mackup](https://github.com/lra/mackup) to restore the configurations.

# Acknowledgements

macstrap itself is a fork of the [dots](https://github.com/matthewmueller/dots) project which has the base functionality
to install and update the command line tools and the GUI applications. So please also have a look at this project if you
also need a similar functionality for Ubuntu. At this point I want to thank Matthew for his nice work.

# License

macstrap is available under the [MIT license](https://github.com/guylabs/macstrap/blob/master/LICENSE).

(c) Matthew Mueller - Forked project (https://github.com/matthewmueller/dots)
(c) Modifications by Guy Brand
