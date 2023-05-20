ARG BASE_IMAGE="${BASE_IMAGE:-ubuntu:jammy}"
FROM ${BASE_IMAGE} AS BASE
ARG USE_PPA="${USE_PPA:-upnpp1}"
ARG USE_APT_PROXY

RUN mkdir -p /app/conf

COPY app/conf/01proxy /app/conf/

RUN if [ "$USE_APT_PROXY" = "Y" ]; then \
	echo "Using apt proxy"; \
	cp /app/conf/01proxy /etc/apt/apt.conf.d/01proxy; \
	echo /etc/apt/apt.conf.d/01proxy; \
	else \
	echo "Building without proxy"; \
	fi

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y software-properties-common
RUN apt-get install -y exiftool
RUN add-apt-repository ppa:jean-francois-dockes/${USE_PPA}
RUN apt-get update
RUN apt-get install -y upmpdcli
RUN apt-get install -y upmpdcli-*
RUN apt-get install -y python3 
RUN apt-get install -y python3-pip
RUN apt-get install -y git
RUN pip install pyradios
RUN pip install subsonic-connector==0.1.14
RUN apt-get remove -y software-properties-common
RUN apt-get -y autoremove
RUN	rm -rf /var/lib/apt/lists/*

RUN upmpdcli -v

RUN echo "--- BEGIN upmpdcli.conf ---"
RUN cat /etc/upmpdcli.conf
RUN echo "--- END   upmpdcli.conf ---"

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

ENV MPD_HOST ""
ENV MPD_PORT ""

ENV PORT_OFFSET ""

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

ENV TIDAL_ENABLE no
ENV TIDAL_USERNAME tidal_username
ENV TIDAL_PASSWORD tidal_password
ENV TIDAL_API_TOKEN tidal_api_token
ENV TIDAL_QUALITY low

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
COPY app/bin/read-file.sh /app/bin/
COPY app/bin/get-value.sh /app/bin/
COPY app/bin/config-builder.sh /app/bin/
RUN chmod u+x /app/bin/*.sh

COPY README.md /app/doc

WORKDIR /app/bin

ENTRYPOINT ["/app/bin/run-upmpdcli.sh"]
