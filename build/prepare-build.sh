#!/bin/bash
set -ev

# Use empty macstrap config as we want to test macstrap and not the installation of the brew packages
rm -rf ~/.macstrap/macstrap.cfg
cp ./build/macstrap-test.cfg ~/.macstrap/macstrap.cfg

# Start with the installation
macstrap install