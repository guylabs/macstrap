#!/bin/sh
set -e

# Wether the system is an ARM based Mac
isArmArchitecture() {
    if [[ `uname -m` == 'arm64' ]]; then
        return 0
    else
        return 1
    fi
}
