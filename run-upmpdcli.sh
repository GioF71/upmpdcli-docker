#!/bin/bash

sed -i 's/UPMPD_FRIENDLY_NAME/'"$UPMPD_FRIENDLY_NAME"'/g' /etc/upmpdcli.conf
sed -i 's/AV_FRIENDLY_NAME/'"$AV_FRIENDLY_NAME"'/g' /etc/upmpdcli.conf

sed -i 's/MPD_HOST/'"$MPD_HOST"'/g' /etc/upmpdcli.conf
sed -i 's/MPD_PORT/'"$MPD_PORT"'/g' /etc/upmpdcli.conf

echo "Tidal Enable: $TIDAL_ENABLE"
if [ "$TIDAL_ENABLE" == "yes" ]; then \
    echo "Processing Tidal settings"; \
    sed -i 's/\#tidaluser/tidaluser/g' /etc/upmpdcli.conf; \
    sed -i 's/\#tidalpass/tidalpass/g' /etc/upmpdcli.conf; \
    sed -i 's/\#tidalapitoken/tidalapitoken/g' /etc/upmpdcli.conf; \
    sed -i 's/\#tidalquality/tidalquality/g' /etc/upmpdcli.conf; \
    sed -i 's/TIDAL_USERNAME/'"$TIDAL_USERNAME"'/g' /etc/upmpdcli.conf; \
    sed -i 's/TIDAL_PASSWORD/'"$TIDAL_PASSWORD"'/g' /etc/upmpdcli.conf; \
    sed -i 's/TIDAL_API_TOKEN/'"$TIDAL_API_TOKEN"'/g' /etc/upmpdcli.conf; \
    sed -i 's/TIDAL_QUALITY/'"$TIDAL_QUALITY"'/g' /etc/upmpdcli.conf; \
fi

echo "Qobuz Enable: $QOBUZ_ENABLE"
if [ "$QOBUZ_ENABLE" == "yes" ]; then \
    echo "Processing Qobuz settings"; \
    sed -i 's/\#qobuzuser/qobuzuser/g' /etc/upmpdcli.conf; \
    sed -i 's/\#qobuzpass/qobuzpass/g' /etc/upmpdcli.conf; \
    sed -i 's/\#qobuzformatid/qobuzformatid/g' /etc/upmpdcli.conf; \
    sed -i 's/QOBUZ_USERNAME/'"$QOBUZ_USERNAME"'/g' /etc/upmpdcli.conf; \
    sed -i 's/QOBUZ_PASSWORD/'"$QOBUZ_PASSWORD"'/g' /etc/upmpdcli.conf; \
    sed -i 's/QOBUZ_FORMAT_ID/'"$QOBUZ_FORMAT_ID"'/g' /etc/upmpdcli.conf; \
fi

cat /etc/upmpdcli.conf

/usr/bin/upmpdcli -c /etc/upmpdcli.conf
