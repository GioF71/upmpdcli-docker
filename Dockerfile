ARG BASE_IMAGE="${BASE_IMAGE:-ubuntu:jammy}"
FROM ${BASE_IMAGE} AS BASE
ARG BASE_IMAGE="${BASE_IMAGE:-ubuntu:jammy}"
ARG USE_PPA="${USE_PPA:-upnpp1}"
ARG BUILD_MODE="${BUILD_MODE:-full}"
ARG USE_APT_PROXY

RUN mkdir -p /app/conf
RUN mkdir -p /app/install

COPY app/conf/01proxy /app/conf/

RUN if [ "$USE_APT_PROXY" = "Y" ]; then \
		echo "Using apt proxy"; \
		cp /app/conf/01proxy /etc/apt/apt.conf.d/01proxy; \
		echo /etc/apt/apt.conf.d/01proxy; \
	else \
		echo "Building without proxy"; \
	fi

ARG DEBIAN_FRONTEND=noninteractive

RUN if [ "$BUILD_MODE" = "full" ]; then \
		apt-get update; \
		apt-get install -y python3 python3-pip; \
	fi

COPY app/install/* /app/install
RUN chmod u+x /app/install/*.sh
RUN /app/install/setup.sh

RUN apt-get install -y upmpdcli
RUN apt-get install -y --no-install-recommends iproute2 grep

RUN if [ "$BUILD_MODE" = "full" ]; then \
		apt-get install -y \
			upmpdcli-bbc \
			upmpdcli-deezer \
			upmpdcli-hra \
			upmpdcli-qobuz \
			upmpdcli-radio-browser \
			upmpdcli-radio-paradise \
			upmpdcli-mother-earth-radio \
			upmpdcli-radios \
			upmpdcli-subsonic \
			upmpdcli-tidal \
			upmpdcli-uprcl; \
		fi

RUN if [ "$BUILD_MODE" = "full" ]; then \
		apt-get install -y \
			recollcmd; \
		fi

RUN if [ "$BUILD_MODE" = "full" ]; then \
		apt-get install -y exiftool; \
	fi

RUN if [ "$BUILD_MODE" = "full" ]; then \
		apt-get install -y git; \
	fi

RUN apt-get remove -y software-properties-common

RUN apt-get -y autoremove
RUN	rm -rf /var/lib/apt/lists/*

RUN if [ "$USE_APT_PROXY" = "Y" ]; then \
		rm /etc/apt/apt.conf.d/01proxy; \
	fi

RUN echo $BUILD_MODE > /app/conf/build_mode.txt

FROM scratch
COPY --from=BASE / /

LABEL maintainer="GioF71"
LABEL source="https://github.com/GioF71/upmpdcli-docker"

RUN mkdir -p /app
RUN mkdir -p /app/conf
RUN mkdir -p /app/doc

RUN cp /etc/upmpdcli.conf /app/conf/original.upmpdcli.conf

ENV UPMPD_FRIENDLY_NAME ""
ENV AV_FRIENDLY_NAME ""
ENV FRIENDLY_NAME ""
ENV OH_PRODUCT_ROOM ""

ENV RENDERER_MODE ""
ENV UPNPAV ""
ENV OPENHOME ""

ENV UPNPAV_SKIP_NAME_POSTFIX ""
ENV UPNPAV_POSTFIX ""
ENV UPNPAV_POSTFIX_PREPEND_SPACE ""

ENV MPD_HOST ""
ENV MPD_PORT ""

ENV PORT_OFFSET ""

ENV AUTO_UPNPIFACE_URL ""
ENV ENABLE_AUTO_UPNPIFACE ""
ENV UPNPIFACE ""
ENV UPNPPORT ""

ENV OWN_QUEUE ""

ENV UPRCL_ENABLE ""
# BEGIN DEPRECATED
ENV ENABLE_UPRCL "" 
# END DEPRECATED
ENV UPRCL_USER ""
ENV UPRCL_HOSTPORT ""
ENV UPRCL_TITLE "Local Music"
ENV UPRCL_AUTOSTART ""

ENV CHECK_CONTENT_FORMAT ""

ENV QOBUZ_ENABLE no
ENV QOBUZ_USERNAME qobuz_username
ENV QOBUZ_PASSWORD qobuz_password
ENV QOBUZ_FORMAT_ID 5

ENV DEEZER_ENABLE no
ENV DEEZER_USERNAME deezer_username
ENV DEEZER_PASSWORD deezer_password

ENV HRA_ENABLE no
ENV HRA_USERNAME hra_username
ENV HRA_PASSWORD hra_password
ENV HRA_LANG en

ENV RADIOS_ENABLE ""
ENV RADIOS_AUTOSTART ""

ENV BBC_ENABLE ""
ENV BBC_PROGRAMME_DAYS ""

ENV RADIO_BROWSER_ENABLE ""

ENV SUBSONIC_ENABLE ""
ENV SUBSONIC_AUTOSTART ""
ENV SUBSONIC_BASE_URL ""
ENV SUBSONIC_PORT ""
ENV SUBSONIC_USER ""
ENV SUBSONIC_PASSWORD ""
ENV SUBSONIC_ITEMS_PER_PAGE ""
ENV SUBSONIC_APPEND_YEAR_TO_ALBUM ""
ENV SUBSONIC_APPEND_CODECS_TO_ALBUM ""
ENV SUBSONIC_WHITELIST_CODECS ""
ENV SUBSONIC_DOWNLOAD_PLUGIN ""
ENV SUBSONIC_PLUGIN_BRANCH ""

ENV TIDAL_ENABLE ""
ENV TIDAL_TOKEN_TYPE ""
ENV TIDAL_ACCESS_TOKEN ""
ENV TIDAL_REFRESH_TOKEN ""
ENV TIDAL_EXPIRY_TIME ""
ENV TIDAL_AUDIO_QUALITY ""
ENV TIDAL_DOWNLOAD_PLUGIN ""
ENV TIDAL_PLUGIN_BRANCH ""

ENV RADIO_PARADISE_ENABLE ""
ENV RADIO_PARADISE_DOWNLOAD_PLUGIN ""
ENV RADIO_PARADISE_PLUGIN_BRANCH ""

ENV MOTHER_EARTH_RADIO_ENABLE ""
ENV MOTHER_EARTH_RADIO_DOWNLOAD_PLUGIN ""
ENV MOTHER_EARTH_RADIO_PLUGIN_BRANCH ""

ENV PUID ""
ENV PGID ""

ENV PLG_MICRO_HTTP_HOST ""
ENV PLG_MICRO_HTTP_PORT ""

ENV MEDIA_SERVER_FRIENDLY_NAME ""

ENV LOG_ENABLE ""
ENV LOG_LEVEL ""

ENV DUMP_ADDITIONAL_RADIO_LIST ""

ENV STARTUP_DELAY_SEC 0

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
RUN chmod u+x /app/bin/*.sh

COPY app/bin/get-tidal-credentials.py /app/bin/
RUN chmod u+x /app/bin/get-tidal-credentials.py

COPY README.md /app/doc

WORKDIR /app/bin

ENTRYPOINT ["/app/bin/run-upmpdcli.sh"]
