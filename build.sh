#!/bin/bash

declare -A base_images

base_images[bookworm]=debian:bookworm-slim
base_images[lunar]=ubuntu:lunar
base_images[kinetic]=ubuntu:kinetic
base_images[jammy]=ubuntu:jammy
base_images[focal]=ubuntu:focal
base_images[bionic]=ubuntu:bionic

DEFAULT_BASE_IMAGE=jammy
DEFAULT_TAG=local
DEFAULT_USE_PROXY=N
DEFAULT_PPA=upnpp1
DEFAULT_BUILD_MODE=full

DEFAULT_CACHE_MODE=""

tag=$DEFAULT_TAG
use_proxy=$DEFAULT_USE_PROXY

ppa=$DEFAULT_PPA

while getopts b:t:p:e:m:c: flag
do
    case "${flag}" in
        b) base_image=${OPTARG};;
        t) tag=${OPTARG};;
        p) proxy=${OPTARG};;
        e) ppa=${OPTARG};;
        m) build_mode=${OPTARG};;
        c) cache_mode=${OPTARG};;
    esac
done

echo "base_image: $base_image";
echo "tag: $tag";
echo "proxy: $proxy";
echo "ppa: $ppa";
echo "build_mode: $build_mode";
echo "cache_mode: $cache_mode";

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

if [[ -z "${build_mode}" ]]; then
  build_mode=$DEFAULT_BUILD_MODE
fi

if [[ -z "${cache_mode}" ]]; then
  cache_mode=$DEFAULT_CACHE_MODE
fi

echo "Base Image: ["$select_base_image"]"
echo "Tag: ["$tag"]"
echo "PPA: ["$ppa"]"
echo "Build Mode: ["$build_mode"]"
echo "Proxy: ["$use_proxy"]"

cmd_line="docker build . ${cache_mode} \
    --build-arg BASE_IMAGE=${select_base_image} \
    --build-arg USE_APT_PROXY=${use_proxy} \
    --build-arg USE_PPA=${ppa} \
    --build-arg BUILD_MODE=${build_mode} \
    -t giof71/upmpdcli:$tag"

echo "cmd_line=[$cmd_line]"
eval "$cmd_line"

