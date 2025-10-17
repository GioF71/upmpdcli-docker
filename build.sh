#!/bin/bash

declare -A base_images

base_images[stable]=debian:stable-slim
base_images[trixie]=debian:trixie-slim

DEFAULT_BASE_IMAGE=stable
DEFAULT_TAG=local
DEFAULT_BUILD_MODE=full
DEFAULT_INSTALL_RECOLL=yes
# avoiding compile is faster to build
DEFAULT_COMPILE_RECOLL=no

DEFAULT_CACHE_MODE=""

tag=$DEFAULT_TAG

while getopts b:t:m:c:d:s:r:f: flag
do
    case "${flag}" in
        b) base_image=${OPTARG};;
        t) tag=${OPTARG};;
        m) build_mode=${OPTARG};;
        c) cache_mode=${OPTARG};;
        d) docker_file=${OPTARG};;
        s) upmpdcli_selector=${OPTARG};;
        r) install_recoll=${OPTARG};;
        f) compile_recoll=${OPTARG};;
    esac
done

echo "base_image [$base_image]"
echo "tag [$tag]"
echo "build_mode [$build_mode]"
echo "cache_mode [$cache_mode]"
echo "docker_file [$docker_file]"
echo "upmpdcli_selector [$upmpdcli_selector]"
echo "install_recoll: $install_recoll"
echo "compile_recoll: $compile_recoll"

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

if [[ -z "${install_recoll}" ]]; then
  install_recoll=$DEFAULT_INSTALL_RECOLL
else
    if [[ "${install_recoll^^}" == "YES" ]] || [[ "${install_recoll^^}" == "Y" ]]; then
        install_recoll="yes"
    elif [[ "${install_recoll^^}" == "NO" ]] || [[ "${install_recoll^^}" == "N" ]]; then
        install_recoll="no"
    else
        echo "Invalid install_recoll=[$install_recoll], must be yes or no"
        exit 1
    fi
fi

if [[ -z "${compile_recoll}" ]]; then
  compile_recoll=$DEFAULT_COMPILE_RECOLL
else
    if [[ "${compile_recoll^^}" == "YES" ]] || [[ "${compile_recoll^^}" == "Y" ]]; then
        compile_recoll="yes"
    elif [[ "${compile_recoll^^}" == "NO" ]] || [[ "${compile_recoll^^}" == "N" ]]; then
        compile_recoll="no"
    else
        echo "Invalid compile_recoll=[$compile_recoll], must be yes or no"
        exit 1
    fi
fi

echo "Base Image: ["$select_base_image"]"
echo "Tag: ["$tag"]"
echo "Build Mode: ["$build_mode"]"
echo "Install Recoll: ["$install_recoll"]"
echo "Force compile Recoll: ["$compile_recoll"]"

cmd_line="docker build . ${cache_mode} \
    -f ${docker_file} \
    --build-arg BASE_IMAGE=${select_base_image} \
    --build-arg BUILD_MODE=${build_mode} \
    --build-arg INSTALL_RECOLL=${install_recoll} \
    --build-arg COMPILE_RECOLL=${compile_recoll} \
    --build-arg UPMPDCLI_SELECTOR=${upmpdcli_selector} \
    --progress=plain \
    -t giof71/upmpdcli:$tag"

echo "cmd_line=[$cmd_line]"
eval "$cmd_line"

