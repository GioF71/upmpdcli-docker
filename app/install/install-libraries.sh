#!/bin/bash

set -ex

ARCH=`dpkg --print-architecture`
echo "BUILD_MODE=[${BUILD_MODE}] ARCH=[$ARCH]"

if [[ "${BUILD_MODE}" = "full" ]]; then
    apt-get-install \
        python3 \
        curl \
        exiftool \
        python3-mutagen \
        python3-waitress \
        python3-bottle sqlite3 \
        python3-pip \
        python3-typing-extensions
else
    # we install python3 anyway, it's needed at least for openhome services
    apt-get-install python3
fi
