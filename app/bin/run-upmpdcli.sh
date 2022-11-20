#!/bin/bash

SOURCE_CONFIG_FILE=/app/conf/upmpdcli.conf
CONFIG_FILE=/app/conf/current-upmpdcli.conf

QOBUZ_CREDENTIALS_FILE=/user/config/qobuz.txt
TIDAL_CREDENTIALS_FILE=/user/config/tidal.txt

declare -A file_dict

source read-file.sh
source get-value.sh

if [ -f "$QOBUZ_CREDENTIALS_FILE" ]; then
    echo "Reading $QOBUZ_CREDENTIALS_FILE"
    read_file $QOBUZ_CREDENTIALS_FILE
    QOBUZ_USERNAME=$(get_value "QOBUZ_USERNAME" $PARAMETER_PRIORITY)
    QOBUZ_PASSWORD=$(get_value "QOBUZ_PASSWORD" $PARAMETER_PRIORITY)
    QOBUZ_FORMAT_ID=$(get_value "QOBUZ_FORMAT_ID" $PARAMETER_PRIORITY)
else
    echo "File $QOBUZ_CREDENTIALS_FILE not found."
fi

if [ -f "$TIDAL_CREDENTIALS_FILE" ]; then
    echo "Reading $TIDAL_CREDENTIALS_FILE"
    read_file $TIDAL_CREDENTIALS_FILE
    TIDAL_USERNAME=$(get_value "TIDAL_USERNAME" $PARAMETER_PRIORITY)
    TIDAL_PASSWORD=$(get_value "TIDAL_PASSWORD" $PARAMETER_PRIORITY)
    TIDAL_API_TOKEN=$(get_value "TIDAL_API_TOKEN" $PARAMETER_PRIORITY)
    TIDAL_QUALITY=$(get_value "TIDAL_QUALITY" $PARAMETER_PRIORITY)
else
    echo "File $TIDAL_CREDENTIALS_FILE not found."
fi

DEFAULT_UPNPPORT=49152
DEFAULT_PLG_MICRO_HTTP_PORT=49149

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

if [[ -n $PORT_OFFSET && $PORT_OFFSET -ge 0 ]]; then
    echo "Applying PORT_OFFSET=[$PORT_OFFSET]"
    UPNPPORT=`expr $DEFAULT_UPNPPORT + $PORT_OFFSET`
    PLG_MICRO_HTTP_PORT=`expr $DEFAULT_PLG_MICRO_HTTP_PORT - $PORT_OFFSET`
    echo "UPNPPORT=$UPNPPORT"
    echo "PLG_MICRO_HTTP_PORT=$PLG_MICRO_HTTP_PORT"
else
    echo "PORT_OFFSET not specified"
fi

cp $SOURCE_CONFIG_FILE $CONFIG_FILE

echo "UPNPIFACE=["$UPNPIFACE"]"
if [ -z "${UPNPIFACE}" ]; then
    echo "UPNPIFACE not set"
else 
    echo "Setting UPNPIFACE to ["$UPNPIFACE"]"
    sed -i 's/\#upnpiface/upnpiface/g' $CONFIG_FILE
    sed -i 's/UPNPIFACE/'"$UPNPIFACE"'/g' $CONFIG_FILE
fi

if [ -n "${FRIENDLY_NAME}" ]; then
    UPMPD_FRIENDLY_NAME="${FRIENDLY_NAME}"
    AV_FRIENDLY_NAME="${FRIENDLY_NAME}-av"
    MEDIA_SERVER_FRIENDLY_NAME="${FRIENDLY_NAME}"
fi

replace_parameter $CONFIG_FILE UPNPPORT "$UPNPPORT" upnpport
replace_parameter $CONFIG_FILE UPNPAV "$UPNPAV" upnpav
replace_parameter $CONFIG_FILE OPENHOME "$OPENHOME" openhome
if [ "${OPENHOME}" -eq 1 ]; then
    replace_parameter $CONFIG_FILE UPMPD_FRIENDLY_NAME "$UPMPD_FRIENDLY_NAME" friendlyname
fi
if [ "${UPNPAV}" -eq 1 ]; then
    replace_parameter $CONFIG_FILE AV_FRIENDLY_NAME "$AV_FRIENDLY_NAME" avfriendlyname
fi
replace_parameter $CONFIG_FILE MPD_HOST "$MPD_HOST" mpdhost
replace_parameter $CONFIG_FILE MPD_PORT "$MPD_PORT" mpdport
replace_parameter $CONFIG_FILE PLG_MICRO_HTTP_HOST "$PLG_MICRO_HTTP_HOST" plgmicrohttphost
replace_parameter $CONFIG_FILE PLG_MICRO_HTTP_PORT "$PLG_MICRO_HTTP_PORT" plgmicrohttpport

MEDIA_SERVER_ENABLED=0
if [[ "${ENABLE_UPRCL^^}" == "YES" || 
      "${TIDAL_ENABLE^^}" == "YES" ||
      "${QOBUZ_ENABLE^^}" == "YES" ]]; then
    MEDIA_SERVER_ENABLED=1
fi

echo "MEDIA_SERVER_ENABLED=[${MEDIA_SERVER_ENABLED}]"
if [ "${MEDIA_SERVER_ENABLED}" -eq 1 ]; then
    echo "Setting msfriendlyname to [${MEDIA_SERVER_FRIENDLY_NAME}]"
    replace_parameter $CONFIG_FILE MEDIA_SERVER_FRIENDLY_NAME "$MEDIA_SERVER_FRIENDLY_NAME" msfriendlyname
fi
echo "Tidal Enable [$TIDAL_ENABLE]"
if [ "${TIDAL_ENABLE^^}" == "YES" ]; then
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
if [ "${QOBUZ_ENABLE^^}" == "YES" ]; then
    echo "Processing Qobuz settings";
    sed -i 's/\#qobuzuser/qobuzuser/g' $CONFIG_FILE;
    sed -i 's/\#qobuzpass/qobuzpass/g' $CONFIG_FILE;
    sed -i 's/\#qobuzformatid/qobuzformatid/g' $CONFIG_FILE;
    sed -i 's/QOBUZ_USERNAME/'"$QOBUZ_USERNAME"'/g' $CONFIG_FILE;
    sed -i 's/QOBUZ_PASSWORD/'"$QOBUZ_PASSWORD"'/g' $CONFIG_FILE;
    sed -i 's/QOBUZ_FORMAT_ID/'"$QOBUZ_FORMAT_ID"'/g' $CONFIG_FILE;
fi

echo "ENABLE_UPRCL [$ENABLE_UPRCL]"
if [ "${ENABLE_UPRCL^^}" == "YES" ]; then
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
    UPRCL_USER_CONFIG_FILE="/user/config/recoll.conf.user"
    if [ -f "$UPRCL_USER_CONFIG_FILE" ]; then
        sed -i 's/#uprclconfrecolluser/'"uprclconfrecolluser"'/g' $CONFIG_FILE;
    fi
fi

MAIN_RADIO_LIST_FILENAME=/usr/share/upmpdcli/radio_scripts/radiolist.conf
USER_CONF_PATH=/user/config
ADDITIONAL_RADIO_LIST=additional-radio-list.txt

RADIO_LIST=/app/conf/radiolist.conf

ADDITIONAL_RADIO_LIST_FILENAME="$USER_CONF_PATH/$ADDITIONAL_RADIO_LIST"
cp $MAIN_RADIO_LIST_FILENAME $RADIO_LIST
if [ -f "$ADDITIONAL_RADIO_LIST_FILENAME" ]; then
    echo "Adding additional radio list file"
    cat $ADDITIONAL_RADIO_LIST_FILENAME
    cat $ADDITIONAL_RADIO_LIST_FILENAME >> $RADIO_LIST
else
    echo "No additional radio list file."
fi

cat $CONFIG_FILE

if [ "${ENABLE_UPRCL^^}" == "YES" ]; then
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
    chown -R $USER_NAME:$GROUP_NAME /user/config
fi

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC
echo "Ready to start."

CMD_LINE="/usr/bin/upmpdcli -c $CONFIG_FILE"

if [ "${ENABLE_UPRCL^^}" == "YES" ]; then
    su - $USER_NAME -c "$CMD_LINE"
else
    eval $CMD_LINE
fi
