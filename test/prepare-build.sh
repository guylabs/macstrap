#!/bin/sh
set -e

# Use empty macstrap config as we want to test macstrap and not the installation of the brew packages
rm -rf ~/.macstrap/macstrap.cfg
cp ~/.macstrap/test/macstrap-test.cfg ~/.macstrap/macstrap.cfg

# List all preinstalled brew packages on Travis CI
brew deps --include-build --tree $(brew leaves)

# Uninstall preinstalled brew packages from Travis CI
brew uninstall postgis
brew uninstall postgres

# Start with the installation
macstrap install
