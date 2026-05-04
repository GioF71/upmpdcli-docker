#!/bin/bash

set -ex

if [[ "${BUILD_MODE}" = "full" ]]; then
    if [[ "${UPMPDCLI_SELECTOR}" == "edge" ]]; then
        pip install --break-system-packages tidalapi==0.8.11
    elif [[ "${UPMPDCLI_SELECTOR}" == "master" ]]; then
        pip install --break-system-packages tidalapi==0.8.11
    else
        pip install --break-system-packages tidalapi==0.8.11
    fi
fi