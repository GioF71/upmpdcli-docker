#!/bin/bash

set -ex

PPA_NAME=upnpp1
PPA_KEY=bd1ec68cab92bbd56698f1c507971a38c8a2ca38

echo $PPA_NAME > /app/conf/ppa.txt

apt-get update
apt-get install -y gnupg

# gpg --no-default-keyring --keyring /app/install/lesbonscomptes.gpg --keyserver keyserver.ubuntu.com --recv-key bd1ec68cab92bbd56698f1c507971a38c8a2ca38
# curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/spotify.gpg

mkdir -p /etc/apt/sources.list.d -p
cp /app/install/ubuntu.${PPA_NAME}.list /etc/apt/sources.list.d/${PPA_NAME}.list
# cat /etc/apt/sources.list.d/${PPA_NAME}.list
sed -i "s/UBUNTU_VERSION/${IMAGE_VERSION}/g" /etc/apt/sources.list.d/${PPA_NAME}.list
# cat /etc/apt/sources.list.d/${PPA_NAME}.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${PPA_KEY}
apt-get update
