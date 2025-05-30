ARG BASE_IMAGE="${BASE_IMAGE:-debian:stable-slim}"
FROM ${BASE_IMAGE} AS base

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update

RUN apt-get -y install \
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

# create build directory
WORKDIR /build

# build npupnp
COPY npupnp /build/npupnp
WORKDIR /build/npupnp
RUN meson setup --prefix /usr build
WORKDIR /build/npupnp/build
RUN ninja
RUN meson install

# build libupnpp
WORKDIR /build
COPY libupnpp /build/libupnpp
WORKDIR /build/libupnpp
RUN meson setup --prefix /usr build
WORKDIR /build/libupnpp/build
RUN ninja
RUN meson install

ARG UPMPDCLI_SELECTOR=release
# build upmpdcli
WORKDIR /build
COPY upmpdcli-${UPMPDCLI_SELECTOR} /build/upmpdcli
WORKDIR /build/upmpdcli
RUN meson setup --prefix /usr build
WORKDIR /build/upmpdcli/build
RUN ninja
RUN meson install

ARG BUILD_MODE=full

WORKDIR /install
COPY app/install/install-libraries.sh /install/
RUN chmod +x /install/install-libraries.sh
RUN /bin/sh -c /install/install-libraries.sh
COPY app/install/*pyradios.sh /install/
RUN chmod +x /install/*.sh
RUN if [ "${BUILD_MODE}" = "full" ]; then /bin/sh -c /install/install-mediaserver-python-packages-pyradios.sh; fi
COPY app/install/*tidal.sh /install/
RUN chmod +x /install/*.sh
RUN if [ "${BUILD_MODE}" = "full" ]; then /bin/sh -c /install/install-mediaserver-python-packages-tidal.sh; fi
COPY app/install/*subsonic.sh /install/
RUN chmod +x /install/*.sh
RUN if [ "${BUILD_MODE}" = "full" ]; then /bin/sh -c /install/install-mediaserver-python-packages-subsonic.sh; fi

RUN mkdir -p /app/conf
RUN echo "${BUILD_MODE}" > /app/conf/build_mode.txt

RUN apt-get -y remove pkg-config meson cmake build-essential
RUN apt-get -y autoremove
RUN	rm -Rf /var/lib/apt/lists/*
RUN rm -Rf /build

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
