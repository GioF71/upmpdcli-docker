#!/bin/bash

TODAY=$(date '+%Y-%m-%d')
MPD_VERSION=0.23.17

echo "TODAY=${TODAY}"

docker buildx build . \
    --platform linux/amd64,linux/arm64/v8,linux/arm/v7 \
    --build-arg BASE_IMAGE=ubuntu:noble \
    --build-arg BUILD_MODE=full \
    --tag giof71/upmpdcli:noble-full \
    --tag giof71/upmpdcli:noble-full${TODAY} \
    --tag giof71/upmpdcli:latest \
    --tag giof71/upmpdcli:latest-full \
    --tag giof71/upmpdcli:stable \
    --tag giof71/upmpdcli:stable-full \
    --tag giof71/upmpdcli:ubuntu-lts \
    --tag giof71/upmpdcli:ubuntu-lts-full \
    --push

# renderer
docker buildx build . \
    --platform linux/amd64,linux/arm64/v8,linux/arm/v7 \
    --build-arg BASE_IMAGE=ubuntu:noble \
    --build-arg BUILD_MODE=renderer \
    --tag giof71/upmpdcli:renderer \
    --tag giof71/upmpdcli:latest-renderer \
    --tag giof71/upmpdcli:noble-renderer \
    --tag giof71/upmpdcli:noble-renderer-${TODAY} \
    --tag giof71/upmpdcli:stable-renderer \
    --tag giof71/upmpdcli:ubuntu-lts-renderer \
    --push
