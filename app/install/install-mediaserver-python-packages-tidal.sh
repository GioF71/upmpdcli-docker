#!/bin/bash

set -ex

if [[ "${BUILD_MODE}" = "full" ]]; then
    pip install --break-system-packages tidalapi==0.8.8
fi