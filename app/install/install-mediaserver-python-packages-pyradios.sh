#!/bin/bash

set -ex

if [[ "${BUILD_MODE}" = "full" ]]; then
    pip install --break-system-packages pyradios beautifulsoup4
fi