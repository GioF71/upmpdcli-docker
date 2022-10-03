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

    echo "UPNPPORT=["$UPNPPORT"]"
    if [ -z "${UPNPPORT}" ]; then
        echo "UPNPPORT not set"
    else 
        echo "Setting UPNPPORT to ["$UPNPPORT"]"
        sed -i 's/\#upnpport/upnpport/g' $CONFIG_FILE;
        sed -i 's/UPNPPORT/'"$UPNPPORT"'/g' $CONFIG_FILE;
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

    echo "Tidal Enable [$TIDAL_ENABLE]"
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
    echo "Qobuz Enable [$QOBUZ_ENABLE]"
    if [ "$QOBUZ_ENABLE" == "yes" ]; then
        echo "Processing Qobuz settings";
        sed -i 's/\#qobuzuser/qobuzuser/g' $CONFIG_FILE;
        sed -i 's/\#qobuzpass/qobuzpass/g' $CONFIG_FILE;
        sed -i 's/\#qobuzformatid/qobuzformatid/g' $CONFIG_FILE;
        sed -i 's/QOBUZ_USERNAME/'"$QOBUZ_USERNAME"'/g' $CONFIG_FILE;
        sed -i 's/QOBUZ_PASSWORD/'"$QOBUZ_PASSWORD"'/g' $CONFIG_FILE;
        sed -i 's/QOBUZ_FORMAT_ID/'"$QOBUZ_FORMAT_ID"'/g' $CONFIG_FILE;
    fi

    echo "ENABLE_UPRCL [$ENABLE_UPRCL]"
    if [ "$ENABLE_UPRCL" == "yes" ]; then
        sed -i 's/\#uprclconfdir/uprclconfdir/g' $CONFIG_FILE;
        echo "enabling uprclconfdir"
        sed -i 's/#uprclconfdir/'"uprclconfdir"'/g' $CONFIG_FILE;
        echo "enabling uprclmediadirs"
        sed -i 's/#uprclmediadirs/'"uprclmediadirs"'/g' $CONFIG_FILE;
        # set UPRCL_USER if not empty
        echo "UPRCL_TITLE [$UPRCL_TITLE]"
        if [ -n "${UPRCL_TITLE}" ]; then
            echo "Setting uprcltitle $UPRCL_TITLE"
            sed -i 's/#uprcltitle/'"uprcltitle"'/g' $CONFIG_FILE;
            sed -i 's/UPRCL_TITLE/'"$UPRCL_TITLE"'/g' $CONFIG_FILE;
        fi
        echo "UPRCL_USER [$UPRCL_USER]"
        if [ -n "${UPRCL_USER}" ]; then
            echo "Setting uprcluser $UPRCL_USER"
            sed -i 's/#uprcluser/'"uprcluser"'/g' $CONFIG_FILE;
            sed -i 's/UPRCL_USER/'"$UPRCL_USER"'/g' $CONFIG_FILE;
        fi
        echo "UPRCL_HOSTPORT [$UPRCL_HOSTPORT]"
        if [ -n "${UPRCL_HOSTPORT}" ]; then
            echo "Setting uprclhostport $UPRCL_HOSTPORT"
            sed -i 's/#uprclhostport/'"uprclhostport"'/g' $CONFIG_FILE;
            sed -i 's/UPRCL_HOSTPORT/'"$UPRCL_HOSTPORT"'/g' $CONFIG_FILE;
        fi
    fi

    cat $CONFIG_FILE
fi

DEFAULT_UID=1000
DEFAULT_GID=1000

if [ -z "${PUID}" ]; then
  PUID=$DEFAULT_UID;
  echo "Setting default value for PUID: ["$PUID"]"
fi

if [ -z "${PGID}" ]; then
  PGID=$DEFAULT_GID;
  echo "Setting default value for PGID: ["$PGID"]"
fi

USER_NAME=upmpd-user
GROUP_NAME=upmpd-user

HOME_DIR=/home/$USER_NAME

#cat /etc/passwd

### create home directory and ancillary directories
if [ ! -d "$HOME_DIR" ]; then
  echo "Home directory [$HOME_DIR] not found, creating."
  mkdir -p $HOME_DIR
  chown -R $PUID:$PGID $HOME_DIR
  ls -la $HOME_DIR -d
  ls -la $HOME_DIR
fi

### create group
if [ ! $(getent group $GROUP_NAME) ]; then
  echo "group $GROUP_NAME does not exist, creating..."
  groupadd -g $PGID $GROUP_NAME
else
  echo "group $GROUP_NAME already exists."
fi

### create user
if [ ! $(getent passwd $USER_NAME) ]; then
  echo "user $USER_NAME does not exist, creating..."
  useradd -g $PGID -u $PUID -s /bin/bash -M -d $HOME_DIR $USER_NAME
  id $USER_NAME
  echo "user $USER_NAME created."
else
  echo "user $USER_NAME already exists."
fi

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC
echo "Ready to start."

CMD_LINE="/usr/bin/upmpdcli -c $CONFIG_FILE"

su - $USER_NAME -c "$CMD_LINE"

