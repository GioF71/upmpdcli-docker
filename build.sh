#!/bin/bash

declare -A base_images

base_images[stable]=debian:bookworm-slim
base_images[trixie]=debian:trixie-slim
base_images[bookworm]=debian:bookworm-slim
base_images[bullseye]=debian:bullseye-slim
base_images[noble]=ubuntu:noble
base_images[mantic]=ubuntu:mantic
base_images[lunar]=ubuntu:lunar
base_images[kinetic]=ubuntu:kinetic
base_images[jammy]=ubuntu:jammy
base_images[focal]=ubuntu:focal
base_images[lib]=giof71/upmpdcli:lib

DEFAULT_BASE_IMAGE=stable
DEFAULT_TAG=local
DEFAULT_BUILD_MODE=full

DEFAULT_CACHE_MODE=""

tag=$DEFAULT_TAG

while getopts b:t:m:c:d:s: flag
do
    case "${flag}" in
        b) base_image=${OPTARG};;
        t) tag=${OPTARG};;
        m) build_mode=${OPTARG};;
        c) cache_mode=${OPTARG};;
        d) docker_file=${OPTARG};;
        s) upmpdcli_selector=${OPTARG};;
    esac
done

echo "base_image: $base_image"
echo "tag: $tag"
echo "build_mode: $build_mode"
echo "cache_mode: $cache_mode"
echo "docker_file: $docker_file"
echo "upmpdcli_selector: $upmpdcli_selector"

if [ -z "${base_image}" ]; then
  base_image=$DEFAULT_BASE_IMAGE
fi

if [ -z "${docker_file}" ]; then
  docker_file=Dockerfile
fi

if [ -z "${upmpdcli_selector}" ]; then
  upmpdcli_selector=master
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
echo "Build Mode: ["$build_mode"]"

cmd_line="docker build . ${cache_mode} \
    -f ${docker_file} \
    --build-arg BASE_IMAGE=${select_base_image} \
    --build-arg BUILD_MODE=${build_mode} \
    --build-arg UPMPDCLI_SELECTOR=${upmpdcli_selector} \
    --progress=plain \
    -t giof71/upmpdcli:$tag"

echo "cmd_line=[$cmd_line]"
eval "$cmd_line"

