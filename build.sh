#!/bin/bash

declare -A base_images

base_images[kinetic]=ubuntu:kinetic
base_images[focal]=ubuntu:focal
base_images[jammy]=ubuntu:jammy

DEFAULT_BASE_IMAGE=jammy
DEFAULT_TAG=latest
DEFAULT_USE_PROXY=N
DEFAULT_PPA=upnpp1

tag=$DEFAULT_TAG
use_proxy=$DEFAULT_USE_PROXY

ppa=$DEFAULT_PPA

while getopts b:t:p:e: flag
do
    case "${flag}" in
        b) base_image=${OPTARG};;
        t) tag=${OPTARG};;
        p) proxy=${OPTARG};;
        e) ppa=${OPTARG};;
    esac
done

echo "base_image: $base_image";
echo "tag: $tag";
echo "proxy: $proxy";
echo "ppa: $ppa";

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
echo "PPA: ["$ppa"]"
echo "Proxy: ["$use_proxy"]"

docker build . \
    --build-arg BASE_IMAGE=${select_base_image} \
    --build-arg USE_APT_PROXY=${use_proxy} \
    --build-arg USE_PPA=${ppa} \
    -t giof71/upmpdcli:$tag
