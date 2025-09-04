#!/bin/sh

set -ex

echo "BUILD_MODE=[${BUILD_MODE}]"

# we install python3 anyway, at least for openhome services
apt-get -y install python3

if [ "${BUILD_MODE}" = "full" ]; then
    apt-get -y install curl
    apt-get -y install exiftool
    apt-get -y install recoll recollcmd python3-recoll python3-mutagen python3-waitress python3-bottle sqlite3
    apt-get -y install python3-pip
    apt-get -y install python3-typing-extensions
fi
