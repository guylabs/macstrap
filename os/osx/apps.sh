#!/usr/bin/env bash
set -e

# Load the apps/casks/atom packages from the config file
source $config

# Show banner
echo -e "#############################################"
echo -e "# Installing the apps and atom packages ... #"
echo -e "#############################################"
echo

# Install apps
if [ ${#apps} -gt 0 ]; then
    echo -e "\t- Installing apps ..."
    brew cask install ${apps[@]}
else
    echo -e "\t- No apps defined in macstrap configuration."
fi

# Install atom packages
if [ ${#atomPackages} -gt 0 ]; then
    echo -e "\t- Installing atom packages ..."
    apm install ${atomPackages[@]}
else
    echo -e "\t- No atom packages defined in macstrap configuration."
fi

exit 0
