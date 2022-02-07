#!/bin/bash

TAG_FAMILY="focal-20220113"
TAG_SL_VERSION="upmpdcli-1.5.12-libupnpp-0.21.0"

TODAY=`date +%F`
echo "TODAY: "$TODAY

TAG_TODAY=$TAG_SL_VERSION"-"$TAG_FAMILY"-"$TODAY
echo "TODAY's tag: "$TAG_TODAY

TAG_INTERMEDIATE=$TAG_SL_VERSION"-"$TAG_FAMILY
echo "Intermediate tag: "$TAG_INTERMEDIATE

tags=($TAG_TODAY $TAG_INTERMEDIATE $TAG_FAMILY latest stable) 

for tag in "${tags[@]}"; do
        docker build \
                --push \
                --platform linux/arm/v7,linux/arm64,linux/amd64 \
                --tag giof71/upmpdcli:$tag \
                .
        #docker build \
        #        --push \
        #        --platform linux/amd64 \
        #        --tag giof71/upmpdcli:$tag \
        #        .
done

