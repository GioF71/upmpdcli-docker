#!/bin/bash

set -ex

echo "BASE_IMAGE=[$BASE_IMAGE]"

if [[ "$BASE_IMAGE" == ubuntu* ]]; then
    echo "Setup for ubuntu"
    /app/install/setup-ubuntu.sh
elif [[ "$BASE_IMAGE" == debian* ]]; then
    echo "Setup for debian"
    /app/install/setup-debian.sh
else
    exit 1
fi
