#!/bin/sh

set -ex

echo "BUILD_MODE=[${BUILD_MODE}]"

if [ "${BUILD_MODE}" = "full" ]; then
    apt-get -y install curl
    apt-get -y install python3
    apt-get -y install exiftool
    apt-get -y install recoll recollcmd python3-recoll python3-mutagen python3-waitress python3-bottle sqlite3
    apt-get -y install python3-pip
fi
