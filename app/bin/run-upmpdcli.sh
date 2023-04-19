#!/bin/bash

## error codes
# 1 Generic error
# 2 Invalid RENDERER_MODE value

SOURCE_CONFIG_FILE=/app/conf/upmpdcli.conf
CONFIG_FILE=/app/conf/current-upmpdcli.conf

QOBUZ_CREDENTIALS_FILE=/user/config/qobuz.txt
TIDAL_CREDENTIALS_FILE=/user/config/tidal.txt
DEEZER_CREDENTIALS_FILE=/user/config/deezer.txt
HRA_CREDENTIALS_FILE=/user/config/hra.txt

declare -A file_dict

source read-file.sh
source get-value.sh
source config-builder.sh

DEFAULT_UPNPAV=0
DEFAULT_OPENHOME=1

if [[ -z "$UPNPAV" ]]; then
    UPNPAV=$DEFAULT_UPNPAV
fi

if [[ -z "$OPENHOME" ]]; then
    OPENHOME=$DEFAULT_OPENHOME
fi

if [[ -n $ENABLE_UPRCL ]]; then
    echo "ENABLE_UPRCL is deprecated, use UPRCL_ENABLE instead"
    if [[ -z "$UPRCL_ENABLE" ]]; then
        echo "Setting UPRCL_ENABLE to ENABLE_UPRCL ($ENABLE_UPRCL) for you"
        UPRCL_ENABLE=$ENABLE_UPRCL
    fi
fi

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

if [ -f "$DEEZER_CREDENTIALS_FILE" ]; then
    echo "Reading $DEEZER_CREDENTIALS_FILE"
    read_file $DEEZER_CREDENTIALS_FILE
    DEEZER_USERNAME=$(get_value "DEEZER_USERNAME" $PARAMETER_PRIORITY)
    DEEZER_PASSWORD=$(get_value "DEEZER_PASSWORD" $PARAMETER_PRIORITY)
else
    echo "File $DEEZER_CREDENTIALS_FILE not found."
fi

if [ -f "$HRA_CREDENTIALS_FILE" ]; then
    echo "Reading $HRA_CREDENTIALS_FILE"
    read_file $HRA_CREDENTIALS_FILE
    HRA_USERNAME=$(get_value "HRA_USERNAME" $PARAMETER_PRIORITY)
    HRA_PASSWORD=$(get_value "HRA_PASSWORD" $PARAMETER_PRIORITY)
    HRA_LANG=$(get_value "HRA_LANG" $PARAMETER_PRIORITY)
else
    echo "File $HRA_CREDENTIALS_FILE not found."
fi

DEFAULT_UPNPPORT=49152
DEFAULT_PLG_MICRO_HTTP_PORT=49149


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

# log support
if [ "${LOG_ENABLE^^}" == "YES" ]; then
    sed -i "s/#logfilename/logfilename/g" $CONFIG_FILE;
    if [ -n "${LOG_LEVEL}" ]; then
        set_parameter $CONFIG_FILE LOG_LEVEL "$LOG_LEVEL" loglevel
    fi
fi

echo "UPNPIFACE=["$UPNPIFACE"]"
if [ -z "${UPNPIFACE}" ]; then
    echo "UPNPIFACE not set"
else 
    echo "Setting UPNPIFACE to ["$UPNPIFACE"]"
    sed -i 's/\#upnpiface/upnpiface/g' $CONFIG_FILE
    sed -i 's/UPNPIFACE/'"$UPNPIFACE"'/g' $CONFIG_FILE
fi

# Renderer mode
if [ -n "${RENDERER_MODE}" ]; then
    echo "RENDERER_MODE = [${RENDERER_MODE}]"
    UPNPAV=0
    OPENHOME=0
    if [ "${RENDERER_MODE^^}" == "OPENHOME" ]; then
        OPENHOME=1
    elif [ "${RENDERER_MODE^^}" == "UPNPAV" ]; then
        UPNPAV=1
    elif [ "${RENDERER_MODE^^}" == "BOTH" ]; then
        UPNPAV=1
        OPENHOME=1
    elif [ "${RENDERER_MODE^^}" != "NONE" ]; then
        echo "Invalid RENDERER_MODE [${RENDERER_MODE}]"
        exit 2
    fi
    echo "RENDERER_MODE=[${RENDERER_MODE}] => OPENHOME=[${OPENHOME}] UPNPAV=[${UPNPAV}]"
fi

# Friendly name management
if [ -n "${FRIENDLY_NAME}" ]; then
    echo "FRIENDLY_NAME=[${FRIENDLY_NAME}], UPNPAV_SKIP_NAME_POSTFIX=[${UPNPAV_SKIP_NAME_POSTFIX}]"
    UPMPD_FRIENDLY_NAME="${FRIENDLY_NAME}"
    echo "UPMPD_FRIENDLY_NAME=[${UPMPD_FRIENDLY_NAME}]"
    if [[ -z "${UPNPAV_SKIP_NAME_POSTFIX}" || "${UPNPAV_SKIP_NAME_POSTFIX^^}" == "YES" ]] && 
          [ "${OPENHOME}" -eq 0 ] && 
          [ "${UPNPAV}" -eq 1 ]; then
        AV_FRIENDLY_NAME="${FRIENDLY_NAME}"
    else
        AV_FRIENDLY_NAME="${FRIENDLY_NAME}-av"
    fi
    echo "AV_FRIENDLY_NAME=[${AV_FRIENDLY_NAME}]"
    MEDIA_SERVER_FRIENDLY_NAME="${FRIENDLY_NAME}"
    echo "MEDIA_SERVER_FRIENDLY_NAME=[${MEDIA_SERVER_FRIENDLY_NAME}]"
fi

set_parameter $CONFIG_FILE UPNPPORT "$UPNPPORT" upnpport
set_parameter $CONFIG_FILE UPNPAV "$UPNPAV" upnpav
set_parameter $CONFIG_FILE OPENHOME "$OPENHOME" openhome
if [ "${OPENHOME}" -eq 1 ]; then
    set_parameter $CONFIG_FILE UPMPD_FRIENDLY_NAME "$UPMPD_FRIENDLY_NAME" friendlyname
fi
if [ "${UPNPAV}" -eq 1 ]; then
    set_parameter $CONFIG_FILE AV_FRIENDLY_NAME "$AV_FRIENDLY_NAME" avfriendlyname
fi
set_parameter $CONFIG_FILE MPD_HOST "$MPD_HOST" mpdhost
set_parameter $CONFIG_FILE MPD_PORT "$MPD_PORT" mpdport
set_parameter $CONFIG_FILE PLG_MICRO_HTTP_HOST "$PLG_MICRO_HTTP_HOST" plgmicrohttphost
set_parameter $CONFIG_FILE PLG_MICRO_HTTP_PORT "$PLG_MICRO_HTTP_PORT" plgmicrohttpport

set_parameter $CONFIG_FILE OWN_QUEUE "$OWN_QUEUE" ownqueue

MEDIA_SERVER_ENABLED=0
if [[ "${UPRCL_ENABLE^^}" == "YES" || 
      "${RADIO_BROWSER_ENABLE^^}" == "YES" ||
      "${SUBSONIC_ENABLE^^}" == "YES" ||
      "${HRA_ENABLE^^}" == "YES" ||
      "${TIDAL_ENABLE^^}" == "YES" ||
      "${DEEZER_ENABLE^^}" == "YES" ||
      "${HRA_ENABLE^^}" == "YES" ||
      "${QOBUZ_ENABLE^^}" == "YES" ]]; then
    MEDIA_SERVER_ENABLED=1
fi

echo "MEDIA_SERVER_ENABLED=[${MEDIA_SERVER_ENABLED}]"
if [ "${MEDIA_SERVER_ENABLED}" -eq 1 ]; then
    echo "Setting msfriendlyname to [${MEDIA_SERVER_FRIENDLY_NAME}]"
    set_parameter $CONFIG_FILE MEDIA_SERVER_FRIENDLY_NAME "$MEDIA_SERVER_FRIENDLY_NAME" msfriendlyname
fi

echo "RADIO_BROWSER_ENABLE=[$RADIO_BROWSER_ENABLE]"
if [ "${RADIO_BROWSER_ENABLE^^}" == "YES" ]; then
    echo "Enabling Radio Browser";
    sed -i 's/\#radio-browseruser/radio-browseruser/g' $CONFIG_FILE;
fi

echo "SUBSONIC_ENABLE=[$SUBSONIC_ENABLE]"
if [ "${SUBSONIC_ENABLE^^}" == "YES" ]; then
    echo "Enabling Subsonic, processing settings";
    sed -i 's/\#subsonicuser/subsonicuser/g' $CONFIG_FILE
    echo "SUBSONIC_AUTOSTART=[$SUBSONIC_AUTOSTART]"
    if [ "${SUBSONIC_AUTOSTART^^}" == "YES" ]; then
        sed -i 's/\#subsonicautostart/subsonicautostart/g' $CONFIG_FILE;
    fi
    echo "Setting subsonic base_url [$SUBSONIC_BASE_URL]"
    sed -i 's/\#subsonicbaseurl/subsonicbaseurl/g' $CONFIG_FILE
    sed -i 's,SUBSONIC_BASE_URL,'"$SUBSONIC_BASE_URL"',g' $CONFIG_FILE
    echo "Setting subsonic port [$SUBSONIC_PORT]"
    sed -i 's/\#subsonicport/subsonicport/g' $CONFIG_FILE
    sed -i 's/SUBSONIC_PORT/'"$SUBSONIC_PORT"'/g' $CONFIG_FILE
    echo "Setting subsonic username [$SUBSONIC_USER]"
    sed -i 's/SUBSONIC_USER/'"$SUBSONIC_USER"'/g' $CONFIG_FILE
    echo "Setting subsonic password [$SUBSONIC_PASSWORD]"
    sed -i 's/\#subsonicpassword/subsonicpassword/g' $CONFIG_FILE
    sed -i 's/SUBSONIC_PASSWORD/'"$SUBSONIC_PASSWORD"'/g' $CONFIG_FILE
    if [[ -n "${SUBSONIC_ITEMS_PER_PAGE}" ]]; then
        sed -i 's/\#subsonicitemsperpage/subsonicitemsperpage/g' $CONFIG_FILE
        sed -i 's/SUBSONIC_ITEMS_PER_PAGE/'"$SUBSONIC_ITEMS_PER_PAGE"'/g' $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_APPEND_YEAR_TO_ALBUM}" ]]; then
        sed -i 's/\#subsonicappendyeartoalbum/subsonicappendyeartoalbum/g' $CONFIG_FILE
        append_year=1
        if [[ "${SUBSONIC_APPEND_YEAR_TO_ALBUM^^}" == "NO" ]]; then
            append_year=0
        elif [[ ! "${SUBSONIC_APPEND_YEAR_TO_ALBUM^^}" == "YES" ]]; then
            echo "Invalid SUBSONIC_APPEND_YEAR_TO_ALBUM [${SUBSONIC_APPEND_YEAR_TO_ALBUM}]"
            exit 2
        fi
        sed -i 's/SUBSONIC_APPEND_YEAR_TO_ALBUM/'"$append_year"'/g' $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_APPEND_CODECS_TO_ALBUM}" ]]; then
        sed -i 's/\#subsonicappendcodecstoalbum/subsonicappendcodecstoalbum/g' $CONFIG_FILE
        append_year=1
        if [[ "${SUBSONIC_APPEND_CODECS_TO_ALBUM^^}" == "NO" ]]; then
            append_year=0
        elif [[ ! "${SUBSONIC_APPEND_CODECS_TO_ALBUM^^}" == "YES" ]]; then
            echo "Invalid SUBSONIC_APPEND_CODECS_TO_ALBUM [${SUBSONIC_APPEND_CODECS_TO_ALBUM}]"
            exit 2
        fi
        sed -i 's/SUBSONIC_APPEND_CODECS_TO_ALBUM/'"$append_year"'/g' $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_WHITELIST_CODECS}" ]]; then
        sed -i 's/\#subsonicwhitelistcodecs/subsonicwhitelistcodecs/g' $CONFIG_FILE
        sed -i 's/SUBSONIC_WHITELIST_CODECS/'"$SUBSONIC_WHITELIST_CODECS"'/g' $CONFIG_FILE
    fi
fi

echo "Tidal Enable [$TIDAL_ENABLE]"
if [ "${TIDAL_ENABLE^^}" == "YES" ]; then
    echo "Processing Tidal settings";
    sed -i 's/\#tidaluser/tidaluser/g' $CONFIG_FILE;
    sed -i 's/\#tidalpass/tidalpass/g' $CONFIG_FILE;
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

echo "Deezer Enable [$DEEZER_ENABLE]"
if [ "${DEEZER_ENABLE^^}" == "YES" ]; then
    echo "Processing Deezer settings";
    sed -i 's/\#deezeruser/deezeruser/g' $CONFIG_FILE;
    sed -i 's/\#deezerpass/deezerpass/g' $CONFIG_FILE;
    sed -i 's/DEEZER_USERNAME/'"$DEEZER_USERNAME"'/g' $CONFIG_FILE;
    sed -i 's/DEEZER_PASSWORD/'"$DEEZER_PASSWORD"'/g' $CONFIG_FILE;
fi

echo "HRA Enable [$HRA_ENABLE]"
if [ "${HRA_ENABLE^^}" == "YES" ]; then
    echo "Processing HRA settings";
    sed -i 's/\#hrauser/hrauser/g' $CONFIG_FILE;
    sed -i 's/\#hrapass/hrapass/g' $CONFIG_FILE;
    sed -i 's/\#hralang/hralang/g' $CONFIG_FILE;
    sed -i 's/HRA_USERNAME/'"$HRA_USERNAME"'/g' $CONFIG_FILE;
    sed -i 's/HRA_PASSWORD/'"$HRA_PASSWORD"'/g' $CONFIG_FILE;
    sed -i 's/HRA_LANG/'"$HRA_LANG"'/g' $CONFIG_FILE;
fi

echo "UPRCL_ENABLE [$UPRCL_ENABLE]"
if [ "${UPRCL_ENABLE^^}" == "YES" ]; then
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
    if [ "${DUMP_ADDITIONAL_RADIO_LIST^^}" == "YES" ]; then
        cat $ADDITIONAL_RADIO_LIST_FILENAME
    fi
    cat $ADDITIONAL_RADIO_LIST_FILENAME >> $RADIO_LIST
else
    echo "No additional radio list file."
fi

cat $CONFIG_FILE

USER_MODE=0
# user is create when using UPRCL, or when at least PUID is set
if [[ "${UPRCL_ENABLE^^}" == "YES" || -n "${PUID}" ]]; then
    USER_MODE=1
    echo "Creating user ...";
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
    chown -R $USER_NAME:$GROUP_NAME /cache
    # Fix permission errors on existing files
    find /cache -type d -exec chmod 755 {} \;
    find /cache -type f -exec chmod 644 {} \;
    chown -R $USER_NAME:$GROUP_NAME /uprcl/confdir
    chown -R $USER_NAME:$GROUP_NAME /user/config
    chown -R $USER_NAME:$GROUP_NAME /log
fi

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC
echo "Ready to start."

CMD_LINE="/usr/bin/upmpdcli -c $CONFIG_FILE"

if [ "${USER_MODE}" -eq 1 ]; then
    echo "USER MODE"
    su - $USER_NAME -c "$CMD_LINE"
else
    echo "ROOT MODE"
    eval $CMD_LINE
fi
