#!/bin/bash

set -ex

echo "BUILD_MODE=[${BUILD_MODE}]"
echo "INSTALL_RECOLL=[$INSTALL_RECOLL]"
echo "FORCE_COMPILE_RECOLL=[$FORCE_COMPILE_RECOLL]"
ARCH=`dpkg --print-architecture`
echo "ARCH=[$ARCH]"

if [[ "${BUILD_MODE}" = "full" ]]; then
    # we need to add contrib and free only if we also need to install recoll
    if [[ "${INSTALL_RECOLL}" == "yes" ]] || [[ "${INSTALL_RECOLL}" == "y" ]]; then
        echo "Adding contrib and non-free repositories."
        sed -i -e's/ main/ main contrib non-free/g' /etc/apt/sources.list.d/debian.sources
    else
        echo "No need to add contrib and non-free repositories."
    fi
fi

apt-get -qq -o=Dpkg::Use-Pty=0 update
