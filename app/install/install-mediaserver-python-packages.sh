#!/bin/sh

set -ex

echo "BUILD_MODE=[${BUILD_MODE}]"

if [ "${BUILD_MODE}" = "full" ]; then
    pip install --break-system-packages subsonic-connector==0.3.9
    pip install --break-system-packages tidalapi
    pip install --break-system-packages pyradios
fi