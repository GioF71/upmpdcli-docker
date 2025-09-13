#!/bin/bash

set -ex

apt-get-install \
    ca-certificates \
    bash \
    curl \
    libcurl4-openssl-dev \
    net-tools \
    iproute2 \
    grep \
    git \
    build-essential \
    meson \
    pkg-config \
    cmake \
    libexpat1-dev \
    libmicrohttpd-dev \
    libjsoncpp-dev \
    libmpdclient-dev