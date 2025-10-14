#!/bin/bash

set -ex

if [[ "${BUILD_MODE}" = "full" ]]; then
    if [[ "${UPMPDCLI_SELECTOR}" == "edge" ]]; then
        pip install --break-system-packages subsonic-connector==0.3.10
    elif [[ "${UPMPDCLI_SELECTOR}" == "master" ]]; then
        pip install --break-system-packages subsonic-connector==0.3.10
    else
        pip install --break-system-packages subsonic-connector==0.3.10b5
    fi
fi