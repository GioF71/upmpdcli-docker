#!/bin/bash

TODAY=$(date '+%Y-%m-%d')

echo "TODAY=${TODAY}"

docker buildx build . \
    --platform linux/amd64,linux/arm64/v8,linux/arm/v7 \
    --build-arg UPMPDCLI_SELECTOR=master \
    --build-arg BUILD_MODE=full \
    --tag giof71/upmpdcli:debian-stable-slim-full \
    --tag giof71/upmpdcli:debian-stable-slim-full-${TODAY} \
    --tag giof71/upmpdcli:latest \
    --tag giof71/upmpdcli:latest-full \
    --tag giof71/upmpdcli:stable \
    --tag giof71/upmpdcli:stable-full \
    --push

# renderer
docker buildx build . \
    --platform linux/amd64,linux/arm64/v8,linux/arm/v7 \
    --build-arg UPMPDCLI_SELECTOR=master \
    --build-arg BUILD_MODE=renderer \
    --tag giof71/upmpdcli:debian-stable-slim-renderer \
    --tag giof71/upmpdcli:debian-stable-slim-renderer-${TODAY} \
    --tag giof71/upmpdcli:renderer \
    --tag giof71/upmpdcli:latest-renderer \
    --tag giof71/upmpdcli:stable-renderer \
    --push
