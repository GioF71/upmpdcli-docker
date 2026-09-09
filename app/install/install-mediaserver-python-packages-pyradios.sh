#!/bin/bash

set -ex

if [[ "${BUILD_MODE}" = "full" ]]; then
    pip install --break-system-packages --ignore-installed pyradios beautifulsoup4
fi