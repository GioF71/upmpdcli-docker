#!/bin/bash

set -ex

#BASE_IMAGE is usually like the following
#   debian:bookworm-slim
#   we need to extract bookworm

IMAGE_FULL_NAME=$(echo $BASE_IMAGE | cut -d ":" -f 2)
echo "IMAGE_FULL_NAME=[$IMAGE_FULL_NAME]"

DEBIAN_VERSION=$(echo $IMAGE_FULL_NAME | cut -d "-" -f 1)
echo "DEBIAN_VERSION=[$DEBIAN_VERSION]"

if [ "$BUILD_MODE" = "full" ]; then
    declare -A needs_switch
    needs_switch[bookworm]=1
    add_switch=0
    if [[ -v needs_switch[$DEBIAN_VERSION] ]]; then
        add_switch=${needs_switch[$DEBIAN_VERSION]}
    fi
    pip_upgrade="pip install --no-cache-dir --upgrade pip"
    if [ $add_switch -eq 1 ]; then
        pip_upgrade="$pip_upgrade --break-system-packages"
    fi
    python_packages=(pyradios py-sonic subsonic-connector==0.1.17 mutagen)
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

apt-get update
apt-get install -y wget

GPG_KEY_FILE="/usr/share/keyrings/lesbonscomptes.gpg"

if [ ! -f "${GPG_KEY_FILE}" ]; then
    wget https://www.lesbonscomptes.com/pages/lesbonscomptes.gpg -O "${GPG_KEY_FILE}"
fi

ARCH=`uname -m`

REPO_LIST="upmpdcli.list"

echo "ARCH=[$ARCH]"
if [[ "$ARCH" == "x86_64" ]]; then
    REPO_URL="https://www.lesbonscomptes.com/upmpdcli/pages/upmpdcli-$DEBIAN_VERSION.list"
else
    REPO_URL="https://www.lesbonscomptes.com/upmpdcli/pages/upmpdcli-r$DEBIAN_VERSION.list"
fi

REPO_FILE="/etc/apt/sources.list.d/${REPO_LIST}"

if [ ! -f "${REPO_FILE}" ]; then
    wget $REPO_URL -O "/etc/apt/sources.list.d/${REPO_LIST}"
fi

apt-get update
