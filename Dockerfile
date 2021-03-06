from debian:buster-slim

RUN apt-get update
RUN apt-get install curl -y
RUN apt-get install gpg -y
RUN apt-get install dirmngr -y

RUN apt-get --no-install-recommends install -y ca-certificates

RUN mkdir -p /root/.gnupg
RUN chmod 755 /root/.gnupg

RUN gpg --no-default-keyring --keyring /root/lesbonscomptes.gpg --keyserver pool.sks-keyservers.net --recv-key F8E3347256922A8AE767605B7808CE96D38B9201
RUN echo "gpg completed"
RUN mv /root/lesbonscomptes.gpg /usr/share/keyrings/

COPY upmpdcli-buster.list /root
COPY upmpdcli-rbuster.list /root


RUN /bin/bash -c 'set -ex && \
    ARCH=`uname -m` && \
    echo $ARCH && \
    if [ "$ARCH" == "x86_64" ]; then \
       mv /root/upmpdcli-buster.list /etc/apt/sources.list.d/upmpdcli.list; \
    else \
       mv /root/upmpdcli-rbuster.list /etc/apt/sources.list.d/upmpdcli.list; \
    fi'

RUN cat /etc/apt/sources.list.d/upmpdcli.list

RUN apt-get update
RUN apt-get install upmpdcli -y
RUN apt-get install upmpdcli-qobuz -y
#RUN apt-get install upmpdcli-spotify -y
#RUN apt-get install upmpdcli-tidal -y

RUN rm -rf /var/lib/apt/lists/*

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

COPY upmpdcli.conf /etc/upmpdcli.conf

COPY run-upmpdcli.sh /run-upmpdcli.sh
RUN chmod u+x /run-upmpdcli.sh

ENTRYPOINT ["/run-upmpdcli.sh"]
