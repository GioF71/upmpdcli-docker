#!/bin/bash

SOURCE_CONFIG_FILE=/app/conf/upmpdcli.conf
CONFIG_FILE=/app/conf/current-upmpdcli.conf

replace_parameter() {
    CFG_FILE=$1
    PARAM_NAME=$2
    PARAM_VALUE=$3
    PARAM_KEY=$4
    echo "$PARAM_NAME=["$PARAM_VALUE"] for key [$PARAM_KEY] on file $CFG_FILE"
    if [ -z "${PARAM_VALUE}" ]; then
        echo "$PARAM_NAME not set"
    else 
        echo "Setting $PARAM_NAME to ["$PARAM_VALUE"]"
        echo "enabling key [$PARAM_KEY]"
        sed -i "s/#${PARAM_KEY}/${PARAM_KEY}/g" $CFG_FILE;
        echo "Setting value for key [${PARAM_KEY}] to [${PARAM_VALUE}]"
        sed -i "s/${PARAM_NAME}/${PARAM_VALUE}/g" $CFG_FILE;
    fi
}

cp $SOURCE_CONFIG_FILE $CONFIG_FILE

echo "UPNPIFACE=["$UPNPIFACE"]"
if [ -z "${UPNPIFACE}" ]; then
    echo "UPNPIFACE not set"
else 
    echo "Setting UPNPIFACE to ["$UPNPIFACE"]"
    sed -i 's/\#upnpiface/upnpiface/g' $CONFIG_FILE
    sed -i 's/UPNPIFACE/'"$UPNPIFACE"'/g' $CONFIG_FILE
fi

replace_parameter $CONFIG_FILE UPNPPORT "$UPNPPORT" upnpport
#echo "UPNPPORT=["$UPNPPORT"]"
#if [ -z "${UPNPPORT}" ]; then
#    echo "UPNPPORT not set"
#else 
#    echo "Setting UPNPPORT to ["$UPNPPORT"]"
#    sed -i 's/\#upnpport/upnpport/g' $CONFIG_FILE;
#    sed -i 's/UPNPPORT/'"$UPNPPORT"'/g' $CONFIG_FILE;
#fi

replace_parameter $CONFIG_FILE UPMPD_FRIENDLY_NAME "$UPMPD_FRIENDLY_NAME" friendlyname
#echo "UPMPD_FRIENDLY_NAME=["$UPMPD_FRIENDLY_NAME"]"
#if [ -z "${UPMPD_FRIENDLY_NAME}" ]; then
#    echo "UPMPD_FRIENDLY_NAME not set"
#else 
#    echo "Setting UPMPD_FRIENDLY_NAME to ["$UPMPD_FRIENDLY_NAME"]"
#    sed -i 's/\#friendlyname/friendlyname/g' $CONFIG_FILE;
#    sed -i 's/UPMPD_FRIENDLY_NAME/'"$UPMPD_FRIENDLY_NAME"'/g' $CONFIG_FILE;
#fi

replace_parameter $CONFIG_FILE UPNPAV "$UPNPAV" upnpav
#echo "UPNPAV=["$UPNPAV"]"
#if [ -z "${UPNPAV}" ]; then
#    echo "UPNPAV not set"
#else 
#    echo "Setting UPNPAV to ["$UPNPAV"]"
#    sed -i 's/\#upnpav/upnpav/g' $CONFIG_FILE;
#    sed -i 's/UPNPAV/'"$UPNPAV"'/g' $CONFIG_FILE;
#fi

replace_parameter $CONFIG_FILE OPENHOME "$OPENHOME" openhome
#echo "OPENHOME=["$OPENHOME"]"
#if [ -z "${OPENHOME}" ]; then
#    echo "OPENHOME not set"
#else 
#    echo "Setting OPENHOME to ["$OPENHOME"]"
#    sed -i 's/\#openhome/openhome/g' $CONFIG_FILE;
#    sed -i 's/OPENHOME/'"$OPENHOME"'/g' $CONFIG_FILE;
#fi

replace_parameter $CONFIG_FILE AV_FRIENDLY_NAME "$AV_FRIENDLY_NAME" avfriendlyname
#echo "AV_FRIENDLY_NAME=["$AV_FRIENDLY_NAME"]"
#if [ -z "${AV_FRIENDLY_NAME}" ]; then
#    echo "AV_FRIENDLY_NAME not set"
#else 
#    echo "Setting AV_FRIENDLY_NAME to ["$AV_FRIENDLY_NAME"]"
#    sed -i 's/\#avfriendlyname/avfriendlyname/g' $CONFIG_FILE;
#    sed -i 's/AV_FRIENDLY_NAME/'"$AV_FRIENDLY_NAME"'/g' $CONFIG_FILE;
#fi

replace_parameter $CONFIG_FILE MPD_HOST "$MPD_HOST" mpdhost
#echo "MPD_HOST=["$MPD_HOST"]"
#if [ -z "${MPD_HOST}" ]; then
#    echo "MPD_HOST not set"
#else 
#    echo "Setting MPD_HOST to ["$MPD_HOST"]"
#    sed -i 's/\#mpdhost/mpdhost/g' $CONFIG_FILE;
#    sed -i 's/MPD_HOST/'"$MPD_HOST"'/g' $CONFIG_FILE;
#fi

replace_parameter $CONFIG_FILE MPD_PORT "$MPD_PORT" mpdport
#echo "MPD_PORT=["$MPD_PORT"]"
#if [ -z "${MPD_PORT}" ]; then
#    echo "MPD_PORT not set"
#else 
#    echo "Setting MPD_PORT to ["$MPD_PORT"]"
#    sed -i 's/\#mpdport/mpdport/g' $CONFIG_FILE;
#    sed -i 's/MPD_PORT/'"$MPD_PORT"'/g' $CONFIG_FILE;
#fi

replace_parameter $CONFIG_FILE PLG_MICRO_HTTP_HOST "$PLG_MICRO_HTTP_HOST" plgmicrohttphost
#echo "PLG_MICRO_HTTP_HOST=["$PLG_MICRO_HTTP_HOST"]"
#if [ -z "${PLG_MICRO_HTTP_HOST}" ]; then
#    echo "PLG_MICRO_HTTP_HOST not set"
#else 
#    echo "Setting PLG_MICRO_HTTP_HOST to ["$PLG_MICRO_HTTP_HOST"]"
#    sed -i 's/\#plgmicrohttphost/plgmicrohttphost/g' $CONFIG_FILE;
#    sed -i 's/PLG_MICRO_HTTP_HOST/'"$PLG_MICRO_HTTP_HOST"'/g' $CONFIG_FILE;
#fi

replace_parameter $CONFIG_FILE PLG_MICRO_HTTP_PORT "$PLG_MICRO_HTTP_PORT" plgmicrohttpport
#echo "PLG_MICRO_HTTP_PORT=["$PLG_MICRO_HTTP_PORT"]"
#if [ -z "${PLG_MICRO_HTTP_PORT}" ]; then
#    echo "PLG_MICRO_HTTP_PORT not set"
#else 
#    echo "Setting PLG_MICRO_HTTP_PORT to ["$PLG_MICRO_HTTP_PORT"]"
#    sed -i 's/\#plgmicrohttpport/plgmicrohttpport/g' $CONFIG_FILE;
#    sed -i 's/PLG_MICRO_HTTP_PORT/'"$PLG_MICRO_HTTP_PORT"'/g' $CONFIG_FILE;
#fi

replace_parameter $CONFIG_FILE MEDIA_SERVER_FRIENDLY_NAME "$MEDIA_SERVER_FRIENDLY_NAME" msfriendlyname

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
    echo "enabling cachedir"
    sed -i 's/#cachedir/'"cachedir"'/g' $CONFIG_FILE;
    echo "enabling uprclmediadirs"
    sed -i 's/#uprclmediadirs/'"uprclmediadirs"'/g' $CONFIG_FILE;
    echo "UPRCL_TITLE [$UPRCL_TITLE]"
    if [ -n "${UPRCL_TITLE}" ]; then
        echo "Setting uprcltitle $UPRCL_TITLE"
        sed -i 's/#uprcltitle/'"uprcltitle"'/g' $CONFIG_FILE;
        sed -i 's/UPRCL_TITLE/'"$UPRCL_TITLE"'/g' $CONFIG_FILE;
    fi
    # set UPRCL_USER if not empty
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
    echo "UPRCL_AUTOSTART [$UPRCL_AUTOSTART]"
    if [ -n "${UPRCL_AUTOSTART}" ]; then
        echo "Setting uprclautostart $UPRCL_AUTOSTART"
        sed -i 's/#uprclautostart/'"uprclautostart"'/g' $CONFIG_FILE;
        sed -i 's/UPRCL_AUTOSTART/'"$UPRCL_AUTOSTART"'/g' $CONFIG_FILE;
    fi
fi
cat $CONFIG_FILE

if [ "$ENABLE_UPRCL" == "yes" ]; then
    echo "UPRCL is enabled, creating user ...";
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
    ### create home directory and ancillary directories
    if [ ! -d "$HOME_DIR" ]; then
        echo "Home directory [$HOME_DIR] not found, creating."
        mkdir -p $HOME_DIR
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
    echo "UPRCL is enabled, create $USER_NAME (group: $GROUP_NAME)";
    # set permission for home dir
    chown -R $USER_NAME:$GROUP_NAME $HOME_DIR
    # Permissions of writable volumes
    chown -R $USER_NAME:$GROUP_NAME /var/cache/upmpdcli
    chown -R $USER_NAME:$GROUP_NAME /uprcl/confdir
fi

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC
echo "Ready to start."

CMD_LINE="/usr/bin/upmpdcli -c $CONFIG_FILE"

if [ "$ENABLE_UPRCL" == "yes" ]; then
    su - $USER_NAME -c "$CMD_LINE"
else
    eval $CMD_LINE
fi
