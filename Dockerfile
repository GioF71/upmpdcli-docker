FROM ubuntu:focal-20220113

RUN apt-get update && \
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

VOLUME /var/cache/upmpdcli

RUN mkdir /app
RUN mkdir /app/doc

COPY upmpdcli.conf /etc/upmpdcli.conf

COPY run-upmpdcli.sh /run-upmpdcli.sh
RUN chmod u+x /run-upmpdcli.sh

COPY README.md /app/doc

ENTRYPOINT ["/run-upmpdcli.sh"]
