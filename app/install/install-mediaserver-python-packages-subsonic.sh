#!/bin/bash

set -ex

if [[ "${BUILD_MODE}" = "full" ]]; then
    if [[ "${UPMPDCLI_SELECTOR}" == "edge" ]]; then
        pip install --break-system-packages subsonic-connector==0.3.11 python-dateutil python-dotenv
    elif [[ "${UPMPDCLI_SELECTOR}" == "master" ]]; then
        pip install --break-system-packages subsonic-connector==0.3.11 python-dateutil python-dotenv
    else
        pip install --break-system-packages subsonic-connector==0.3.11 python-dateutil python-dotenv
    fi
fi