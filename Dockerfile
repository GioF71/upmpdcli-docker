ARG USE_APT_PROXY
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN mkdir -p /app
RUN mkdir -p /app/conf
RUN mkdir -p /app/doc

COPY app/conf/01proxy /app/conf/

RUN if [ "$USE_APT_PROXY" = "Y" ]; then \
	echo "Using apt proxy"; \
	cp /app/conf/01proxy /etc/apt/apt.conf.d/01proxy; \
	echo /etc/apt/apt.conf.d/01proxy; \
	else \
	echo "Building without proxy"; \
	fi

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y software-properties-common && \
	add-apt-repository ppa:jean-francois-dockes/upnpp1 && \
	apt-get update && \
	apt-get install upmpdcli -y && \
	apt-get install upmpdcli-* -y && \
	apt-get remove software-properties-common -y && \
	apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/*

RUN upmpdcli -v

RUN echo "--- BEGIN upmpdcli.conf ---"
RUN cat /etc/upmpdcli.conf
RUN echo "--- END   upmpdcli.conf ---"

RUN cp /etc/upmpdcli.conf /app/conf/original.upmpdcli.conf

ENV UPMPD_FRIENDLY_NAME ""
ENV AV_FRIENDLY_NAME ""

ENV UPNPAV 1
ENV OPENHOME 1

ENV MPD_HOST ""
ENV MPD_PORT ""

ENV UPNPIFACE ""
ENV UPNPPORT ""

ENV TIDAL_ENABLE no
ENV TIDAL_USERNAME tidal_username
ENV TIDAL_PASSWORD tidal_password
ENV TIDAL_API_TOKEN tidal_api_token
ENV TIDAL_QUALITY low

ENV QOBUZ_ENABLE no
ENV QOBUZ_USERNAME qobuz_username
ENV QOBUZ_PASSWORD qobuz_password
ENV QOBUZ_FORMAT_ID 5

ENV STARTUP_DELAY_SEC 0

#ENV UPRCL_MEDIADIRS ""

VOLUME /var/cache/upmpdcli
#VOLUME /media-dir

COPY app/conf/upmpdcli.conf /app/conf/upmpdcli.conf

COPY app/bin/run-upmpdcli.sh /app/bin/run-upmpdcli.sh
RUN chmod u+x /app/bin/run-upmpdcli.sh

COPY README.md /app/doc

WORKDIR /app/bin

ENTRYPOINT ["/app/bin/run-upmpdcli.sh"]
