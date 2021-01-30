from debian:buster-slim

RUN apt-get update
RUN apt-get install curl -y

RUN curl https://www.lesbonscomptes.com/pages/lesbonscomptes.gpg \
         -o /usr/share/keyrings/lesbonscomptes.gpg

RUN /bin/bash -c 'set -ex && \
    ARCH=`uname -m` && \
    echo $ARCH && \
    if [ "$ARCH" == "x86_64" ]; then \
       curl https://www.lesbonscomptes.com/upmpdcli/pages/upmpdcli-buster.list -o /etc/apt/sources.list.d/upmpdcli.list; \
    else \
        curl https://www.lesbonscomptes.com/upmpdcli/pages/upmpdcli-rbuster.list -o /etc/apt/sources.list.d/upmpdcli.list; \
    fi'

RUN cat /etc/apt/sources.list.d/upmpdcli.list

RUN apt-get update
RUN apt-get install upmpdcli -y
RUN apt-get install upmpdcli-qobuz -y
RUN apt-get install upmpdcli-tidal -y

RUN rm -rf /var/lib/apt/lists/*

COPY run-upmpdcli.sh /run-upmpdcli.sh

RUN chmod u+x /run-upmpdcli.sh

COPY upmpdcli.conf /etc/upmpdcli.conf

ENV UPMPD_FRIENDLY_NAME upmpd
ENV AV_FRIENDLY_NAME upmpd-av

ENV MPD_HOST localhost
ENV MPD_PORT 6600

ENTRYPOINT ["/run-upmpdcli.sh"]
