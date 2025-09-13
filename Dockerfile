ARG BASE_IMAGE="${BASE_IMAGE:-debian:stable-slim}"
FROM ${BASE_IMAGE} AS base

ARG DEBIAN_FRONTEND=noninteractive
ARG BUILD_MODE=full
ARG FORCE_COMPILE_RECOLL=no
ARG INSTALL_RECOLL=yes
# compiling is allowed by default
ARG ALLOW_COMPILE_RECOLL=yes

RUN echo "BUILD_MODE=[$BUILD_MODE}]" && \
    echo "FORCE_COMPILE_RECOLL=[${FORCE_COMPILE_RECOLL}]" && \
    echo "INSTALL_RECOLL=[${INSTALL_RECOLL}]" && \
    echo "ALLOW_COMPILE_RECOLL=[${ALLOW_COMPILE_RECOLL}]"

COPY app/bin/apt-get-install /usr/bin
RUN chmod +x /usr/bin/apt-get-install

# this one will also execute apt-get update
COPY app/install/setup-repositories.sh /install/
COPY app/install/install-initial-dependencies.sh /install/
RUN chmod +x /install/setup-repositories.sh && \
    /install/setup-repositories.sh && \
    rm /install/setup-repositories.sh && \
    chmod +x /install/install-initial-dependencies.sh && \
    /install/install-initial-dependencies.sh && \
    rm /install/install-initial-dependencies.sh

# build npupnp
COPY npupnp /build/npupnp
RUN cd /build/npupnp && \
    meson setup --prefix /usr build && \
    cd /build/npupnp/build && \
    ninja && meson install && \
    cd / && \
    rm -Rf /build/npupnp

# build libupnpp
COPY libupnpp /build/libupnpp
RUN cd /build/libupnpp && \
    meson setup --prefix /usr build && \
    cd /build/libupnpp/build && \
    ninja && meson install && \
    cd / && \
    rm -Rf /build/libupnpp

ARG UPMPDCLI_SELECTOR=release
# build upmpdcli
COPY upmpdcli-${UPMPDCLI_SELECTOR} /build/upmpdcli
RUN cd /build/upmpdcli && \
    meson setup --prefix /usr build && \
    cd /build/upmpdcli/build && \
    ninja && \
    meson install && \
    cd / && \
    rm -Rf /build/upmpdcli

# common libraries
COPY app/install/install-libraries.sh /install/
RUN chmod +x /install/install-libraries.sh && \
    /install/install-libraries.sh

# radios
COPY app/install/install-mediaserver-python-packages-pyradios.sh /install/
RUN chmod +x /install/install-mediaserver-python-packages-pyradios.sh && \
    /install/install-mediaserver-python-packages-pyradios.sh

# tidal
COPY app/install/install-mediaserver-python-packages-tidal.sh /install/
RUN chmod +x /install/install-mediaserver-python-packages-tidal.sh && \
    /install/install-mediaserver-python-packages-tidal.sh

# subsonic
COPY app/install/install-mediaserver-python-packages-subsonic.sh /install/
RUN chmod +x /install/install-mediaserver-python-packages-subsonic.sh && \
    /install/install-mediaserver-python-packages-subsonic.sh

# recoll
# copy recoll repository, will be used by install-recoll.sh
COPY recoll /build/recoll
# execute recoll installation (via packages, or via compile)
COPY app/install/install-recoll.sh /install/
RUN chmod +x /install/install-recoll.sh && \
    /install/install-recoll.sh
# recoll-tools
COPY app/install/install-recoll-tools.sh /install/
RUN chmod +x /install/install-recoll-tools.sh && \
    /install/install-recoll-tools.sh

# get rid of unnecessary stuff
RUN apt-get -y -qq -o=Dpkg::Use-Pty=0 remove pkg-config meson cmake build-essential && \
    apt-get -y -qq -o=Dpkg::Use-Pty=0 autoremove && \
    rm -Rf /var/lib/apt/lists/* && \
    rm -Rf /build && \
    rm /usr/bin/apt-get-install && \
    rm -rf /install

# keep track of how the build has been done
RUN mkdir -p /app/conf && \
    echo "${BUILD_MODE}" > /app/conf/build_mode.txt && \
    echo "${INSTALL_RECOLL}" > /app/conf/install_recoll.txt && \
    echo "${FORCE_COMPILE_RECOLL}" > /app/conf/force_compile_recoll.txt

FROM scratch
COPY --from=base / /

LABEL maintainer="GioF71"
LABEL source="https://github.com/GioF71/upmpdcli-docker"

RUN mkdir -p /app
RUN mkdir -p /app/conf
RUN mkdir -p /app/doc

RUN cp /etc/upmpdcli.conf /app/conf/original.upmpdcli.conf

ENV UPMPD_FRIENDLY_NAME=""
ENV AV_FRIENDLY_NAME=""
ENV FRIENDLY_NAME=""
ENV OH_PRODUCT_ROOM=""

ENV RENDERER_MODE=""
ENV UPNPAV=""
ENV OPENHOME=""

ENV UPNPAV_SKIP_NAME_POSTFIX=""
ENV UPNPAV_POSTFIX=""
ENV UPNPAV_POSTFIX_PREPEND_SPACE=""

ENV MPD_HOST=""
ENV MPD_PORT=""
ENV MPD_PASSWORD=""
ENV MPD_TIMEOUT_MS=""

ENV PORT_OFFSET=""

ENV AUTO_UPNPIFACE_URL=""
ENV ENABLE_AUTO_UPNPIFACE=""
ENV UPNPIFACE=""
ENV UPNPIP=""
ENV UPNPPORT=""

ENV OWN_QUEUE=""

ENV UPRCL_ENABLE=""
# BEGIN DEPRECATED
ENV ENABLE_UPRCL="" 
# END DEPRECATED
ENV UPRCL_USER=""
ENV UPRCL_HOSTPORT=""
ENV UPRCL_TITLE="Local Music"
ENV UPRCL_AUTOSTART=""

ENV CHECK_CONTENT_FORMAT=""

ENV QOBUZ_ENABLE=no
ENV QOBUZ_TITLE=""
ENV QOBUZ_USERNAME="qobuz_username"
ENV QOBUZ_PASSWORD="qobuz_password"
ENV QOBUZ_FORMAT_ID=5
ENV QOBUZ_RENUM_TRACKS=""
ENV QOBUZ_EXPLICIT_ITEM_NUMBERS=""
ENV QOBUZ_PREPEND_ARTIST_TO_ALBUM=""

ENV HRA_ENABLE=no
ENV HRA_USERNAME="hra_username"
ENV HRA_PASSWORD="hra_password"
ENV HRA_LANG="en"

ENV RADIOS_TITLE="Upmpdcli Radio List"
ENV RADIOS_ENABLE=""
ENV RADIOS_AUTOSTART=""

ENV BBC_ENABLE=""
ENV BBC_PROGRAMME_DAYS=""

ENV RADIO_BROWSER_ENABLE=""

ENV SUBSONIC_ENABLE=""
ENV SUBSONIC_AUTOSTART=""
ENV SUBSONIC_BASE_URL=""
ENV SUBSONIC_PORT=""
ENV SUBSONIC_SERVER_PATH=""
ENV SUBSONIC_TITLE=""
ENV SUBSONIC_USER=""
ENV SUBSONIC_PASSWORD=""
ENV SUBSONIC_LEGACYAUTH=""
ENV SUBSONIC_ITEMS_PER_PAGE=""
ENV SUBSONIC_APPEND_YEAR_TO_ALBUM_CONTAINER=""
ENV SUBSONIC_APPEND_CODECS_TO_ALBUM=""
ENV SUBSONIC_PREPEND_NUMBER_IN_ALBUM_LIST="" 
ENV SUBSONIC_WHITELIST_CODECS=""
ENV SUBSONIC_TRANSCODE_CODEC=""
ENV SUBSONIC_TRANSCODE_MAX_BITRATE=""
ENV SUBSONIC_ENABLE_INTERNET_RADIOS=""
ENV SUBSONIC_ENABLE_IMAGE_CACHING=""

ENV TIDAL_ENABLE=""
ENV TIDAL_TITLE=""
ENV TIDAL_AUDIO_QUALITY=""
ENV TIDAL_PREPEND_NUMBER_IN_ITEM_LIST=""
ENV TIDAL_ENABLE_IMAGE_CACHING=""
ENV TIDAL_ALLOW_FAVORITE_ACTIONS=""
ENV TIDAL_ALLOW_BOOKMARK_ACTIONS=""
ENV TIDAL_ALLOW_STATISTICS_ACTIONS=""
ENV TIDAL_ENABLE_USER_AGENT_WHITELIST=""

ENV RADIO_PARADISE_ENABLE=""

ENV MOTHER_EARTH_RADIO_ENABLE=""
ENV PUID=""
ENV PGID=""

ENV PLG_MICRO_HTTP_HOST=""
ENV PLG_MICRO_HTTP_PORT=""
ENV PLG_PROXY_METHOD=""

ENV MEDIA_SERVER_FRIENDLY_NAME=""

ENV LOG_ENABLE=""
ENV LOG_LEVEL=""

ENV UPNP_LOG_ENABLE=""
ENV UPNP_LOG_LEVEL=""

ENV ENABLE_OPENHOME_RADIO_SERVICE=""
ENV DUMP_ADDITIONAL_RADIO_LIST=""

ENV WEBSERVER_DOCUMENT_ROOT=""

ENV SKIP_CHOWN_CACHE=""

ENV STARTUP_DELAY_SEC=0

VOLUME /uprcl/confdir
VOLUME /uprcl/mediadirs
VOLUME /user/config
VOLUME /cache
VOLUME /log

COPY app/conf/upmpdcli.conf /app/conf/upmpdcli.conf

COPY app/bin/run-upmpdcli.sh /app/bin/
COPY app/bin/get-version.sh /app/bin/
COPY app/bin/get-version-ext.sh /app/bin/
COPY app/bin/read-file.sh /app/bin/
COPY app/bin/get-value.sh /app/bin/
COPY app/bin/config-builder.sh /app/bin/
RUN chmod +x /app/bin/*.sh

COPY app/bin/get_tidal_credentials.py /app/bin/
RUN chmod +x /app/bin/get_tidal_credentials.py

COPY README.md /app/doc

WORKDIR /app/bin

ENTRYPOINT ["/app/bin/run-upmpdcli.sh"]
