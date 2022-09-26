#!/bin/bash

declare -A base_images

base_images[kinetic]=ubuntu:kinetic
base_images[focal]=ubuntu:focal
base_images[jammy]=ubuntu:jammy

DEFAULT_BASE_IMAGE=jammy
DEFAULT_TAG=latest
DEFAULT_USE_PROXY=N

tag=$DEFAULT_TAG
use_proxy=$DEFAULT_USE_PROXY

while getopts b:t:p: flag
do
    case "${flag}" in
        b) base_image=${OPTARG};;
        t) tag=${OPTARG};;
        p) proxy=${OPTARG};;
    esac
done

echo "base_image: $base_image";
echo "tag: $tag";
echo "proxy: $proxy";

if [ -z "${base_image}" ]; then
  base_image=$DEFAULT_BASE_IMAGE
fi

if [ -z "${proxy}" ]; then
  use_proxy="N"
else
  use_proxy=$proxy
fi

if [[ -z ${base_images[$base_image]} ]]; then
  echo "Image for ["$base_image"] not found"
  select_base_image=${base_images[$DEFAULT_BASE_IMAGE]}
else
  select_base_image=${base_images[$base_image]}
fi

echo "Base Image: ["$select_base_image"]"
echo "Tag: ["$tag"]"
echo "Proxy: ["$use_proxy"]"

docker build . \
    --build-arg BASE_IMAGE=${select_base_image} \
    --build-arg USE_APT_PROXY=${use_proxy} \
    -t giof71/upmpdcli:$tag
