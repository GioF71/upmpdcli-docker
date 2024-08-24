#!/bin/bash

set -ex

PPA_NAME=upnpp1
PPA_KEY=bd1ec68cab92bbd56698f1c507971a38c8a2ca38

echo $PPA_NAME > /app/conf/ppa.txt

apt-get update
apt-get install -y gnupg

mkdir -p /etc/apt/sources.list.d -p
cp /app/install/ubuntu.${PPA_NAME}.list /etc/apt/sources.list.d/${PPA_NAME}.list
# cat /etc/apt/sources.list.d/${PPA_NAME}.list
sed -i "s/UBUNTU_VERSION/${IMAGE_VERSION}/g" /etc/apt/sources.list.d/${PPA_NAME}.list
# cat /etc/apt/sources.list.d/${PPA_NAME}.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${PPA_KEY}
apt-get update
