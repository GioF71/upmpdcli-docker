from debian:buster

RUN apt-get update
RUN apt-get install curl -y

RUN curl https://www.lesbonscomptes.com/pages/lesbonscomptes.gpg -o /usr/share/keyrings/lesbonscomptes.gpg
RUN curl https://www.lesbonscomptes.com/upmpdcli/pages/upmpdcli-buster.list -o /root/amd64.list
RUN curl https://www.lesbonscomptes.com/upmpdcli/pages/upmpdcli-rbuster.list -o /root/arm.list

ARG LIST_FILE_NAME=amd64.list

RUN cp /root/$LIST_FILE_NAME /etc/apt/sources.list.d/upmpdcli.list

RUN cat /etc/apt/sources.list.d/upmpdcli.list

RUN rm /root/*.list

RUN apt-get update
RUN apt-get install upmpdcli -y
RUN rm -rf /var/lib/apt/lists/*

COPY run-upmpdcli.sh /run-upmpdcli.sh

RUN chmod u+x /run-upmpdcli.sh

COPY upmpdcli.conf /etc/upmpdcli.conf

ENV UPMPD_FRIENDLY_NAME upmpd
ENV AV_FRIENDLY_NAME upmpd-av

ENV MPD_HOST localhost
ENV MPD_PORT 6600

ENTRYPOINT ["/run-upmpdcli.sh"]
