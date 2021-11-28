#!/bin/bash

CONFIG_FILE=/etc/upmpdcli-config-file.conf

if test -f "$CONFIG_FILE"; then 
    echo "Configuration file [$CONFIG_FILE] already exists, skipping text substitution"
else 
    echo "Configuration file [$CONFIG_FILE] not found, creating."
    cp /etc/upmpdcli.conf $CONFIG_FILE
    sed -i 's/UPMPD_FRIENDLY_NAME/'"$UPMPD_FRIENDLY_NAME"'/g' $CONFIG_FILE
    sed -i 's/AV_FRIENDLY_NAME/'"$AV_FRIENDLY_NAME"'/g' $CONFIG_FILE
    sed -i 's/MPD_HOST/'"$MPD_HOST"'/g' $CONFIG_FILE
    sed -i 's/MPD_PORT/'"$MPD_PORT"'/g' $CONFIG_FILE
    echo "Tidal Enable: $TIDAL_ENABLE"
    if [ "$TIDAL_ENABLE" == "yes" ]; then \
        echo "Processing Tidal settings"; \
        sed -i 's/\#tidaluser/tidaluser/g' $CONFIG_FILE; \
        sed -i 's/\#tidalpass/tidalpass/g' $CONFIG_FILE; \
        sed -i 's/\#tidalapitoken/tidalapitoken/g' $CONFIG_FILE; \
        sed -i 's/\#tidalquality/tidalquality/g' $CONFIG_FILE; \
        sed -i 's/TIDAL_USERNAME/'"$TIDAL_USERNAME"'/g' $CONFIG_FILE; \
        sed -i 's/TIDAL_PASSWORD/'"$TIDAL_PASSWORD"'/g' $CONFIG_FILE; \
        sed -i 's/TIDAL_API_TOKEN/'"$TIDAL_API_TOKEN"'/g' $CONFIG_FILE; \
        sed -i 's/TIDAL_QUALITY/'"$TIDAL_QUALITY"'/g' $CONFIG_FILE; \
    fi
    echo "Qobuz Enable: $QOBUZ_ENABLE"
    if [ "$QOBUZ_ENABLE" == "yes" ]; then \
        echo "Processing Qobuz settings"; \
        sed -i 's/\#qobuzuser/qobuzuser/g' $CONFIG_FILE; \
        sed -i 's/\#qobuzpass/qobuzpass/g' $CONFIG_FILE; \
        sed -i 's/\#qobuzformatid/qobuzformatid/g' $CONFIG_FILE; \
        sed -i 's/QOBUZ_USERNAME/'"$QOBUZ_USERNAME"'/g' $CONFIG_FILE; \
        sed -i 's/QOBUZ_PASSWORD/'"$QOBUZ_PASSWORD"'/g' $CONFIG_FILE; \
        sed -i 's/QOBUZ_FORMAT_ID/'"$QOBUZ_FORMAT_ID"'/g' $CONFIG_FILE; \
    fi
    cat $CONFIG_FILE
fi

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC
echo "Ready to start."

/usr/bin/upmpdcli -c $CONFIG_FILE

