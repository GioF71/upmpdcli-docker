#!/bin/bash

SOURCE_CONFIG_FILE=/app/conf/upmpdcli.conf
CONFIG_FILE=/app/conf/current-upmpdcli.conf

if test -f "$CONFIG_FILE"; then 
    echo "Configuration file [$CONFIG_FILE] already exists, skipping text substitution"
else 
    echo "Configuration file [$CONFIG_FILE] not found, creating."
    cp $SOURCE_CONFIG_FILE $CONFIG_FILE

    echo "UPNPIFACE=["$UPNPIFACE"]"
    if [ -z "${UPNPIFACE}" ]; then
        echo "UPNPIFACE not set"
    else 
        echo "Setting UPNPIFACE to ["$UPNPIFACE"]"
        sed -i 's/\#upnpiface/upnpiface/g' $CONFIG_FILE;
        sed -i 's/UPNPIFACE/'"$UPNPIFACE"'/g' $CONFIG_FILE;
    fi

    echo "UPMPD_FRIENDLY_NAME=["$UPMPD_FRIENDLY_NAME"]"
    if [ -z "${UPMPD_FRIENDLY_NAME}" ]; then
        echo "UPMPD_FRIENDLY_NAME not set"
    else 
        echo "Setting UPMPD_FRIENDLY_NAME to ["$UPMPD_FRIENDLY_NAME"]"
        sed -i 's/\#friendlyname/friendlyname/g' $CONFIG_FILE;
        sed -i 's/UPMPD_FRIENDLY_NAME/'"$UPMPD_FRIENDLY_NAME"'/g' $CONFIG_FILE;
    fi

    echo "UPNPAV=["$UPNPAV"]"
    if [ -z "${UPNPAV}" ]; then
        echo "UPNPAV not set"
    else 
        echo "Setting UPNPAV to ["$UPNPAV"]"
        sed -i 's/\#upnpav/upnpav/g' $CONFIG_FILE;
        sed -i 's/UPNPAV/'"$UPNPAV"'/g' $CONFIG_FILE;
    fi

    echo "OPENHOME=["$OPENHOME"]"
    if [ -z "${OPENHOME}" ]; then
        echo "OPENHOME not set"
    else 
        echo "Setting OPENHOME to ["$OPENHOME"]"
        sed -i 's/\#openhome/openhome/g' $CONFIG_FILE;
        sed -i 's/OPENHOME/'"$OPENHOME"'/g' $CONFIG_FILE;
    fi

    echo "AV_FRIENDLY_NAME=["$AV_FRIENDLY_NAME"]"
    if [ -z "${AV_FRIENDLY_NAME}" ]; then
        echo "AV_FRIENDLY_NAME not set"
    else 
        echo "Setting AV_FRIENDLY_NAME to ["$AV_FRIENDLY_NAME"]"
        sed -i 's/\#avfriendlyname/avfriendlyname/g' $CONFIG_FILE;
        sed -i 's/AV_FRIENDLY_NAME/'"$AV_FRIENDLY_NAME"'/g' $CONFIG_FILE;
    fi

    echo "MPD_HOST=["$MPD_HOST"]"
    if [ -z "${MPD_HOST}" ]; then
        echo "MPD_HOST not set"
    else 
        echo "Setting MPD_HOST to ["$MPD_HOST"]"
        sed -i 's/\#mpdhost/mpdhost/g' $CONFIG_FILE;
        sed -i 's/MPD_HOST/'"$MPD_HOST"'/g' $CONFIG_FILE;
    fi

    echo "MPD_PORT=["$MPD_PORT"]"
    if [ -z "${MPD_PORT}" ]; then
        echo "MPD_PORT not set"
    else 
        echo "Setting MPD_PORT to ["$MPD_PORT"]"
        sed -i 's/\#mpdport/mpdport/g' $CONFIG_FILE;
        sed -i 's/MPD_PORT/'"$MPD_PORT"'/g' $CONFIG_FILE;
    fi

    echo "Tidal Enable: $TIDAL_ENABLE"
    if [ "$TIDAL_ENABLE" == "yes" ]; then
        echo "Processing Tidal settings";
        sed -i 's/\#tidaluser/tidaluser/g' $CONFIG_FILE;
        sed -i 's/\#tidalpass/tidalpass/g' $CONFIG_FILE; \
        sed -i 's/\#tidalapitoken/tidalapitoken/g' $CONFIG_FILE;
        sed -i 's/\#tidalquality/tidalquality/g' $CONFIG_FILE;
        sed -i 's/TIDAL_USERNAME/'"$TIDAL_USERNAME"'/g' $CONFIG_FILE;
        sed -i 's/TIDAL_PASSWORD/'"$TIDAL_PASSWORD"'/g' $CONFIG_FILE;
        sed -i 's/TIDAL_API_TOKEN/'"$TIDAL_API_TOKEN"'/g' $CONFIG_FILE;
        sed -i 's/TIDAL_QUALITY/'"$TIDAL_QUALITY"'/g' $CONFIG_FILE;
    fi
    echo "Qobuz Enable: $QOBUZ_ENABLE"
    if [ "$QOBUZ_ENABLE" == "yes" ]; then
        echo "Processing Qobuz settings";
        sed -i 's/\#qobuzuser/qobuzuser/g' $CONFIG_FILE;
        sed -i 's/\#qobuzpass/qobuzpass/g' $CONFIG_FILE;
        sed -i 's/\#qobuzformatid/qobuzformatid/g' $CONFIG_FILE;
        sed -i 's/QOBUZ_USERNAME/'"$QOBUZ_USERNAME"'/g' $CONFIG_FILE;
        sed -i 's/QOBUZ_PASSWORD/'"$QOBUZ_PASSWORD"'/g' $CONFIG_FILE;
        sed -i 's/QOBUZ_FORMAT_ID/'"$QOBUZ_FORMAT_ID"'/g' $CONFIG_FILE;
    fi
#    if [ -z "${UPRCL_MEDIADIRS}" ]; then
#        echo "Variable UPRCL_MEDIADIRS not specified";
#    else
#        echo "Variable UPRCL_MEDIADIRS has been specified specified: [$UPRCL_MEDIADIRS]";
#        sed -i 's/\#uprclmediadirs/uprclmediadirs/g' $CONFIG_FILE;
#        sed -i 's/UPRCL_MEDIADIRS/'"$UPRCL_MEDIADIRS"'/g' $CONFIG_FILE;
#    fi
    cat $CONFIG_FILE
fi

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC
echo "Ready to start."

/usr/bin/upmpdcli -c $CONFIG_FILE

