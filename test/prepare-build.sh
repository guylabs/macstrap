#!/bin/sh
set -e

# Use empty macstrap config as we want to test macstrap and not the installation of the brew packages
rm -rf ~/.macstrap/macstrap.cfg
cp ~/.macstrap/test/macstrap-test.cfg ~/.macstrap/macstrap.cfg

# Uninstall preinstalled brew packages from Travis CI
brew uninstall postgis postgresql

# Start with the installation
macstrap install
