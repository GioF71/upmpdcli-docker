#!/bin/bash

TAG_FAMILY="jammy"
TAG_SL_VERSION="upmpdcli-1.5.20-libupnpp-0.22.2"

TODAY=`date +%F`
echo "TODAY: "$TODAY

TAG_TODAY=$TAG_SL_VERSION"-"$TAG_FAMILY"-"$TODAY
echo "TODAY's tag: "$TAG_TODAY

TAG_INTERMEDIATE=$TAG_SL_VERSION"-"$TAG_FAMILY
echo "Intermediate tag: "$TAG_INTERMEDIATE

tags=($TAG_TODAY $TAG_INTERMEDIATE $TAG_FAMILY latest stable) 

for tag in "${tags[@]}"; do
        docker build \
                --build-arg BASE_IMAGE=ubuntu:jammy --tag giof71/upmpdcli:$tag \
                .
        #docker build \
        #        --push \
        #        --platform linux/amd64 \
        #        --tag giof71/upmpdcli:$tag \
        #        .
done

