#!/bin/bash

set -ex

echo $USE_PPA > /app/conf/ppa.txt

apt-get update
apt-get install -y software-properties-common
add-apt-repository ppa:jean-francois-dockes/${USE_PPA}
apt-get update

