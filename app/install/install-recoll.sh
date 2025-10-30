#!/bin/bash

set -ex

echo "BUILD_MODE=[${BUILD_MODE}]"
echo "INSTALL_RECOLL=[$INSTALL_RECOLL]"
echo "COMPILE_RECOLL=[$COMPILE_RECOLL]"
ARCH=`dpkg --print-architecture`
echo "ARCH=[$ARCH]"

if [[ "${BUILD_MODE}" = "full" ]]; then
    if [[ "${INSTALL_RECOLL^^}" == "YES" ]] || [[ "${INSTALL_RECOLL^^}" == "Y" ]]; then
        echo "Recoll installation is requested."
        echo "COMPILE_RECOLL=[${COMPILE_RECOLL}]"
        # compiling is required if plafrom is not amd64, arm64v8 (arm64) or arm/v7 (armhf)
        if [[ -z ${COMPILE_RECOLL} ]] || [[ "${COMPILE_RECOLL^^}" == "NO" ]] || [[ "${COMPILE_RECOLL^^}" == "N" ]]; then
            if [[ ${ARCH} != "amd64" ]] && [[ ${ARCH} != "arm64" ]] && [[ ${ARCH} != "armhf" ]]; then
                echo "Compiling recoll is enforced because we are on architecture [${ARCH}]"
                COMPILE_RECOLL=yes
            else
                echo "We can install recoll because we are on architecture [${ARCH}]"
            fi
        fi
        if [[ "${COMPILE_RECOLL^^}" == "YES" ]] || [[ "${COMPILE_RECOLL^^}" == "Y" ]]; then
            if [[ "${ALLOW_COMPILE_RECOLL^^}" == "YES" ]] || [[ "${ALLOW_COMPILE_RECOLL^^}" == "Y" ]]; then
                echo "Compiling recoll is allowed ..."
                # install required dependencies ...
                apt-get-install \
                    libxml2-dev \
                    libxslt1-dev \
                    libmagic-dev \
                    libxapian-dev
                # compile recoll ...
                cd /build/recoll/src
                meson setup -Dpython-chm=false -Dpython-aspell=false -Dqtgui=false -Dx11mon=false -Daspell=false --prefix /usr build
                cd build
                ninja
                meson install
            else
                echo "Compiling recoll not allowed, skipping."
            fi
        else
            echo "Installing recoll ..."
            # we just install regular packages
            apt-get-install \
                python3-recoll \
                recollcmd
        fi
    else
        echo "Recoll installation is not requested."
    fi
fi
