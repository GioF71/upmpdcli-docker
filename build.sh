#!/bin/bash

declare -A base_images

base_images[bionic]=ubuntu:bionic
base_images[jammy]=ubuntu:jammy

DEFAULT_BASE_IMAGE=jammy
DEFAULT_TAG=latest

tag=$DEFAULT_TAG

while getopts b:d:t: flag
do
    case "${flag}" in
        b) base_image=${OPTARG};;
        t) tag=${OPTARG};;
    esac
done

echo "base_image: $base_image";
echo "tag: $tag";

if [ -z "${base_image}" ]; then
  base_image=$DEFAULT_BASE_IMAGE
fi

expanded_base_image=${base_images[$base_image]}

echo "Base Image: ["$expanded_base_image"]"
echo "Tag: ["$tag"]"

docker build . \
    --build-arg BASE_IMAGE=${expanded_base_image} \
    -t giof71/upmpdcli:$tag
