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

ENV UPNPAV 1
ENV OPENHOME 1

ENV MPD_HOST ""
ENV MPD_PORT ""

ENV UPNPIFACE ""
ENV UPNPPORT ""

ENV ENABLE_UPRCL ""
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

ENV PUID ""
ENV PGID ""

ENV PLG_MICRO_HTTP_HOST ""
ENV PLG_MICRO_HTTP_PORT ""

ENV MEDIA_SERVER_FRIENDLY_NAME ""

ENV STARTUP_DELAY_SEC 0

VOLUME /var/cache/upmpdcli
VOLUME /uprcl/confdir
VOLUME /uprcl/mediadirs
VOLUME /user/config

COPY app/conf/upmpdcli.conf /app/conf/upmpdcli.conf

COPY app/bin/run-upmpdcli.sh /app/bin/run-upmpdcli.sh
RUN chmod u+x /app/bin/run-upmpdcli.sh

COPY README.md /app/doc

WORKDIR /app/bin

ENTRYPOINT ["/app/bin/run-upmpdcli.sh"]
