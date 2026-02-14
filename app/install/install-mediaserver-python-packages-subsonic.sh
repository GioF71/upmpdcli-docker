#!/bin/bash

set -ex

if [[ "${BUILD_MODE}" = "full" ]]; then
    if [[ "${UPMPDCLI_SELECTOR}" == "edge" ]]; then
        pip install --break-system-packages subsonic-connector==0.3.10 python-dateutil
    elif [[ "${UPMPDCLI_SELECTOR}" == "master" ]]; then
        pip install --break-system-packages subsonic-connector==0.3.10 python-dateutil
    else
        pip install --break-system-packages subsonic-connector==0.3.10
    fi
fi