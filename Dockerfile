FROM ubuntu:focal-20220113

RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y software-properties-common && \
	add-apt-repository ppa:jean-francois-dockes/upnpp1 && \
	apt-get update && \
	apt-get install upmpdcli -y && \
	apt-get install upmpdcli-qobuz -y && \
	apt-get install upmpdcli-spotify -y && \
	apt-get install upmpdcli-tidal -y && \
	apt-get remove software-properties-common -y && \
	apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/*

RUN upmpdcli -v

RUN mkdir -p /app
RUN mkdir -p /app/conf
RUN mkdir -p /app/doc

RUN cp /etc/upmpdcli.conf /app/conf/original.upmpdcli.conf

ENV UPMPD_FRIENDLY_NAME upmpd
ENV AV_FRIENDLY_NAME upmpd-av

ENV MPD_HOST localhost
ENV MPD_PORT 6600

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
