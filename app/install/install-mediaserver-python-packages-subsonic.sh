#!/bin/bash

set -ex

if [[ "${BUILD_MODE}" = "full" ]]; then
    if [[ "${UPMPDCLI_SELECTOR}" == "edge" ]]; then
        pip install --break-system-packages subsonic-connector==0.3.10b3
    elif [[ "${UPMPDCLI_SELECTOR}" == "master" ]]; then
        pip install --break-system-packages subsonic-connector==0.3.10b2
    else
        pip install --break-system-packages subsonic-connector==0.3.9
    fi
fi