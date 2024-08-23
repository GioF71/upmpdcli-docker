#!/bin/bash

set -ex

echo $PPA_NAME > /app/conf/ppa.txt

mkdir -p /etc/apt/sources.list.d -p
cp /app/install/ubuntu.${PPA_NAME}.list /etc/apt/sources.list.d/${PPA_NAME}.list
# cat /etc/apt/sources.list.d/${PPA_NAME}.list
sed -i "s/UBUNTU_VERSION/${IMAGE_VERSION}/g" /etc/apt/sources.list.d/${PPA_NAME}.list
# cat /etc/apt/sources.list.d/${PPA_NAME}.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${PPA_KEY}
apt-get update
apt-get install -y gnupg