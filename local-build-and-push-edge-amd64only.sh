#!/bin/bash

TODAY=$(date '+%Y-%m-%d')

echo "TODAY=${TODAY}"

docker buildx build . \
    --platform linux/amd64 \
    --build-arg UPMPDCLI_SELECTOR=edge \
    --build-arg BUILD_MODE=full \
    --tag giof71/upmpdcli:edge \
    --tag giof71/upmpdcli:edge-full \
    --tag giof71/upmpdcli:edge-full-${TODAY} \
    --push

# renderer
docker buildx build . \
    --platform linux/amd64 \
    --build-arg UPMPDCLI_SELECTOR=edge \
    --build-arg BUILD_MODE=renderer \
    --tag giof71/upmpdcli:edge-renderer \
    --tag giof71/upmpdcli:edge-renderer-${TODAY} \
    --push
