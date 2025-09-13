#!/bin/bash

set -ex

echo "BUILD_MODE=[${BUILD_MODE}]"
echo "INSTALL_RECOLL=[$INSTALL_RECOLL]"

if [ "${BUILD_MODE}" = "full" ]; then
    if [[ "${INSTALL_RECOLL^^}" == "YES" ]] || [[ "${INSTALL_RECOLL^^}" == "Y" ]]; then
        # recoll dependencies
        # this requires the non-free repo
        apt-get-install --no-install-recommends unrar
        # additional python libraries
        pip install --break-system-packages legacy-cgi
    fi
fi
