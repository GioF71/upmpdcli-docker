#!/bin/sh

sed -i 's/UPMPD_FRIENDLY_NAME/'"$UPMPD_FRIENDLY_NAME"'/g' /etc/upmpdcli.conf
sed -i 's/AV_FRIENDLY_NAME/'"$AV_FRIENDLY_NAME"'/g' /etc/upmpdcli.conf

sed -i 's/MPD_HOST/'"$MPD_HOST"'/g' /etc/upmpdcli.conf
sed -i 's/MPD_PORT/'"$MPD_PORT"'/g' /etc/upmpdcli.conf

cat /etc/upmpdcli.conf

/usr/bin/upmpdcli -c /etc/upmpdcli.conf
