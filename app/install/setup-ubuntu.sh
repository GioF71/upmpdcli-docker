#!/bin/bash

set -ex

#BASE_IMAGE is usually like the following
#   ubuntu:lunar
#   ubuntu:jammy
#   we need to extract lunar or jammy

UBUNTU_VERSION=$(echo $BASE_IMAGE | cut -d ":" -f 2)
echo "UBUNTU_VERSION=[$UBUNTU_VERSION]"

declare -A needs_switch
needs_switch[jammy]=0
needs_switch[lunar]=1

python_packages=(pyradios py-sonic subsonic-connector==0.1.17 mutagen)

add_switch=${needs_switch[$UBUNTU_VERSION]}

#upgrade pip
pip_upgrade="pip install --upgrade pip"
if [ $add_switch -eq 1 ]; then
    pip_upgrade="$pip_upgrade --break-system-packages"
fi
echo "pip_upgrade=[$pip_upgrade]"
eval "$pip_upgrade"

for pkg in "${python_packages[@]}"
do
    echo "Installing ${pkg} with add_switch [$add_switch]..."
    cmd="pip install "
    if [ $add_switch -eq 1 ]; then
        cmd="$cmd --break-system-packages"
    fi
    cmd="$cmd ${pkg}"
    echo "cmd=[$cmd]"
    eval "$cmd"
done

apt-get update
apt-get install -y software-properties-common
add-apt-repository ppa:jean-francois-dockes/${USE_PPA}
apt-get update

