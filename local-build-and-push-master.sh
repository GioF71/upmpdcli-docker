#!/bin/bash

TODAY=$(date '+%Y-%m-%d')

echo "TODAY=${TODAY}"

docker buildx build . \
    --platform linux/amd64,linux/arm64/v8,linux/arm/v7 \
    --build-arg BASE_IMAGE=debian:stable-slim \
    --build-arg BRANCH_NAME=master \
    --build-arg BUILD_MODE=full \
    --tag giof71/upmpdcli:master \
    --tag giof71/upmpdcli:master-full \
    --tag giof71/upmpdcli:master-full-${TODAY} \
    --push

# renderer
docker buildx build . \
    --platform linux/amd64,linux/arm64/v8,linux/arm/v7 \
    --build-arg BASE_IMAGE=debian:stable-slim \
    --build-arg BRANCH_NAME=master \
    --build-arg BUILD_MODE=renderer \
    --tag giof71/upmpdcli:master-renderer \
    --tag giof71/upmpdcli:master-renderer-${TODAY} \
    --push
