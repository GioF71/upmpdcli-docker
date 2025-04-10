#!/bin/bash

TODAY=$(date '+%Y-%m-%d')

echo "TODAY=${TODAY}"

docker buildx build . \
    --platform linux/amd64 \
    --build-arg UPMPDCLI_SELECTOR=master \
    --build-arg BUILD_MODE=full \
    --tag giof71/upmpdcli:master-amd64 \
    --tag giof71/upmpdcli:master-amd64-full \
    --tag giof71/upmpdcli:master-amd64-full-${TODAY} \
    --push

# renderer
docker buildx build . \
    --platform linux/amd64 \
    --build-arg UPMPDCLI_SELECTOR=master \
    --build-arg BUILD_MODE=renderer-amd64 \
    --tag giof71/upmpdcli:master-renderer-amd64 \
    --tag giof71/upmpdcli:master-renderer-amd64-${TODAY} \
    --push
