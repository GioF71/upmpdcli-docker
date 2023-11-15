#!/bin/bash

set -ex

echo "BASE_IMAGE=[$BASE_IMAGE]"

IMAGE_VERSION=$(echo $BASE_IMAGE | cut -d ":" -f 2)
echo "IMAGE_VERSION=[$IMAGE_VERSION]"

if [ "$BUILD_MODE" = "full" ]; then
    declare -A needs_switch
    needs_switch[bookworm-slim]=1
    needs_switch[mantic]=1
    add_switch=0
    if [[ -v needs_switch[$IMAGE_VERSION] ]]; then
        add_switch=${needs_switch[$IMAGE_VERSION]}
        if [ $add_switch -eq 1 ]; then
            echo "yes" > /app/conf/pip-install-break-needed
        else
            echo "no" > /app/conf/pip-install-break-needed
        fi
    fi
    pip_upgrade="pip install --no-cache-dir --upgrade pip"
    if [ $add_switch -eq 1 ]; then
        pip_upgrade="$pip_upgrade --break-system-packages"
    fi
    python_packages=(pyradios py-sonic subsonic-connector==0.1.17 mutagen tidalapi==0.7.3)
    for pkg in "${python_packages[@]}"
    do
        echo "Installing ${pkg} with add_switch [$add_switch]..."
        cmd="pip install --no-cache-dir"
        if [ $add_switch -eq 1 ]; then
            cmd="$cmd --break-system-packages"
        fi
        cmd="$cmd ${pkg}"
        echo "cmd=[$cmd]"
        eval "$cmd"
    done
fi

if [[ "$BASE_IMAGE" == ubuntu* ]]; then
    echo "Setup for ubuntu"
    /app/install/setup-ubuntu.sh
elif [[ "$BASE_IMAGE" == debian* ]]; then
    echo "Setup for debian"
    /app/install/setup-debian.sh
else
    exit 1
fi
