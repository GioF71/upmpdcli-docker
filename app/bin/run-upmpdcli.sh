#!/bin/bash

## error codes
# 1 Generic error
# 2 Invalid RENDERER_MODE value
# 3 Invalid argument

# display upmpdcli version.
upmpdcli -v

USER_CONF_PATH=/user/config

current_user_id=$(id -u)
echo "Current user id is [$current_user_id]"

if [[ "${current_user_id}" != "0" ]]; then
    echo "Not running as root, will not be able to:"
    echo "- create users" 
    echo "- update plugins" 
fi

if [[ "${RADIO_PARADISE_DOWNLOAD_PLUGIN^^}" == "YES" ]] ||
    [[ "${TIDAL_DOWNLOAD_PLUGIN^^}" == "YES" ]] ||
    [[ "${SUBSONIC_DOWNLOAD_PLUGIN^^}" == "YES" ]] ||
    [[ "${MOTHER_EARTH_RADIO_DOWNLOAD_PLUGIN^^}" == "YES" ]]; then
    echo "WARNING: Plugin downloading is deprecated. Use master/edge images instead."
fi

if [[ $current_user_id -eq 0 ]] && [[ "${MOTHER_EARTH_RADIO_DOWNLOAD_PLUGIN^^}" == "YES" ]]; then
    echo "Downloading updated Mother Earth Radio plugin"
    if [[ -n "${MOTHER_EARTH_RADIO_PLUGIN_BRANCH}" ]]; then
        echo "  using branch [$MOTHER_EARTH_RADIO_PLUGIN_BRANCH]"
        cd /app
        mkdir -p src
        cd /app/src
        git clone https://framagit.org/GioF71/upmpdcli.git --branch ${MOTHER_EARTH_RADIO_PLUGIN_BRANCH}
        echo "  copying updated files ..."
        mkdir -p /usr/share/upmpdcli/cdplugins/mother-earth-radio
        cp -r upmpdcli/src/mediaserver/cdplugins/mother-earth-radio/* /usr/share/upmpdcli/cdplugins/mother-earth-radio/
        echo "  copied, removing repo ..."
        rm -Rf upmpdcli
        echo "  repo removed."
        cd ..
        rm -Rf src
        echo "  src directory removed."
    fi
    # return to the path
    cd /app/bin
fi

if [[ $current_user_id -eq 0 ]] && [[ "${RADIO_PARADISE_DOWNLOAD_PLUGIN^^}" == "YES" ]]; then
    echo "Downloading updated Radio Paradise plugin"
    if [[ -n "${RADIO_PARADISE_PLUGIN_BRANCH}" ]]; then
        echo "  using branch [$RADIO_PARADISE_PLUGIN_BRANCH]"
        cd /app
        mkdir -p src
        cd /app/src
        git clone https://framagit.org/GioF71/upmpdcli.git --branch ${RADIO_PARADISE_PLUGIN_BRANCH}
        echo "  copying updated files ..."
        mkdir -p /usr/share/upmpdcli/cdplugins/radio-paradise
        cp -r upmpdcli/src/mediaserver/cdplugins/radio-paradise/* /usr/share/upmpdcli/cdplugins/radio-paradise/
        echo "  copied, removing repo ..."
        rm -Rf upmpdcli
        echo "  repo removed."
        cd ..
        rm -Rf src
        echo "  src directory removed."
    fi
    # return to the path
    cd /app/bin
fi

if [[ $current_user_id -eq 0 ]] && [[ "${SUBSONIC_DOWNLOAD_PLUGIN^^}" == "YES" ]]; then
    echo "Downloading updated subsonic plugin"
    if [[ -n "${SUBSONIC_PLUGIN_BRANCH}" ]]; then
        echo "  using branch [$SUBSONIC_PLUGIN_BRANCH]"
        cd /app
        mkdir -p src
        cd /app/src
        git clone https://framagit.org/GioF71/upmpdcli.git --branch ${SUBSONIC_PLUGIN_BRANCH}
        echo "  copying updated files ..."
        cp -r upmpdcli/src/mediaserver/cdplugins/subsonic/* /usr/share/upmpdcli/cdplugins/subsonic/
        echo "  copied, removing repo ..."
        rm -Rf upmpdcli
        echo "  repo removed."
        cd ..
        rm -Rf src
        echo "  src directory removed."
    fi
    # return to the path
    cd /app/bin
fi

if [[ $current_user_id -eq 0 ]] && [[ "${TIDAL_DOWNLOAD_PLUGIN^^}" == "YES" ]]; then
    echo "Downloading updated tidal plugin"
    if [[ -n "${TIDAL_PLUGIN_BRANCH}" ]]; then
        echo "  using branch [$TIDAL_PLUGIN_BRANCH]"
        cd /app
        mkdir -p src
        cd /app/src
        git clone https://framagit.org/GioF71/upmpdcli.git --branch ${TIDAL_PLUGIN_BRANCH}
        echo "  copying updated files ..."
        mkdir -p /usr/share/upmpdcli/cdplugins/tidal
        cp -r upmpdcli/src/mediaserver/cdplugins/tidal/* /usr/share/upmpdcli/cdplugins/tidal/
        echo "  copied, removing repo ..."
        rm -Rf upmpdcli
        echo "  repo removed."
        cd ..
        rm -Rf src
        echo "  src directory removed."
    fi
    # return to the path
    cd /app/bin
fi

SOURCE_CONFIG_FILE=/app/conf/upmpdcli.conf
CONFIG_FILE=/tmp/current-upmpdcli.conf

QOBUZ_CREDENTIALS_FILE=/user/config/qobuz.txt
HRA_CREDENTIALS_FILE=/user/config/hra.txt

UPMPDCLI_ADDITIONAL_FILE=/user/config/upmpdcli-additional.txt

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

if [[ -f "$QOBUZ_CREDENTIALS_FILE" ]]; then
    echo "Reading $QOBUZ_CREDENTIALS_FILE"
    read_file $QOBUZ_CREDENTIALS_FILE
    QOBUZ_USERNAME=$(get_value "QOBUZ_USERNAME" $PARAMETER_PRIORITY)
    QOBUZ_PASSWORD=$(get_value "QOBUZ_PASSWORD" $PARAMETER_PRIORITY)
    QOBUZ_FORMAT_ID=$(get_value "QOBUZ_FORMAT_ID" $PARAMETER_PRIORITY)
else
    echo "File $QOBUZ_CREDENTIALS_FILE not found."
fi

if [[ -f "$HRA_CREDENTIALS_FILE" ]]; then
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

RADIO_LIST=/tmp/radiolist.conf

MAIN_RADIO_LIST_FILENAME=/usr/share/upmpdcli/radio_scripts/radiolist.conf
ADDITIONAL_RADIO_LIST=additional-radio-list.txt

ADDITIONAL_RADIO_LIST_FILENAME="$USER_CONF_PATH/$ADDITIONAL_RADIO_LIST"
cp $MAIN_RADIO_LIST_FILENAME $RADIO_LIST
if [[ -f "$ADDITIONAL_RADIO_LIST_FILENAME" ]]; then
    echo "Adding additional radio list file"
    if [[ "${DUMP_ADDITIONAL_RADIO_LIST^^}" == "YES" ]]; then
        cat $ADDITIONAL_RADIO_LIST_FILENAME
    fi
    cat $ADDITIONAL_RADIO_LIST_FILENAME >> $RADIO_LIST
else
    echo "No additional radio list file."
fi

enable_openhome_radio_service=0
if [[ -z "${ENABLE_OPENHOME_RADIO_SERVICE}" ]] || [[ "${ENABLE_OPENHOME_RADIO_SERVICE^^}" == "YES" || "${ENABLE_OPENHOME_RADIO_SERVICE^^}" == "Y" ]]; then
    enable_openhome_radio_service=1
elif [[ "${ENABLE_OPENHOME_RADIO_SERVICE^^}" != "NO" && "${ENABLE_OPENHOME_RADIO_SERVICE^^}" != "N" ]]; then
    echo "Invalid ENABLE_OPENHOME_RADIO_SERVICE=[${ENABLE_OPENHOME_RADIO_SERVICE}]"
    exit 1
fi

if [[ $enable_openhome_radio_service -eq 1 ]]; then
    echo "radiolist = ${RADIO_LIST}" >> $CONFIG_FILE
    echo "upradiostitle = ${RADIOS_TITLE}" >> $CONFIG_FILE
fi

set_upnp_iface=0
if [[ "$ENABLE_AUTO_UPNPIFACE" == "1" || "${ENABLE_AUTO_UPNPIFACE^^}" == "YES" || "${ENABLE_AUTO_UPNPIFACE^^}" == "Y" ]]; then
    if [[ -z "${UPNPIFACE}" ]]; then
        set_upnp_iface=1
    else
        echo "Cannot set UPNPIFACE with ENABLE_AUTO_UPNPIFACE enabled"
        exit 1
    fi
fi

set_upnp_ip=0
if [[ -z "${ENABLE_AUTO_UPNPIP}" || "$ENABLE_AUTO_UPNPIP" == "1" || "${ENABLE_AUTO_UPNPIP^^}" == "YES" || "${ENABLE_AUTO_UPNPIP^^}" == "Y" ]]; then
    if [[ -z "${UPNPIP}" ]]; then
        set_upnp_ip=1
    else
        echo "Cannot set UPNPIP with ENABLE_AUTO_UPNPIP enabled"
        exit 1
    fi
fi

if [[ $set_upnp_iface -eq 1 && $set_upnp_ip -eq 1 ]]; then
    echo "Cannot enable both ENABLE_AUTO_UPNPIFACE and ENABLE_AUTO_UPNPIP"
    exit 1
fi

if [[ $set_upnp_iface -eq 1 || $set_upnp_ip -eq 1 ]]; then
    if [[ -z "${AUTO_UPNPIFACE_URL}" ]]; then
        AUTO_UPNPIFACE_URL=1.1.1.1
    fi
    iface=$(ip route get $AUTO_UPNPIFACE_URL | grep -oP 'dev\s+\K[^ ]+')
    select_ip=$(ifconfig $iface | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
    if [[ set_upnp_iface -eq 1 ]]; then
        echo "Automatically setting UPNPIFACE to ["$iface"]"
        echo "upnpiface = $iface" >> $CONFIG_FILE
    fi
    if [[ set_upnp_ip -eq 1 ]]; then
        echo "Automatically setting UPNPIP to ["$select_ip"]"
        echo "upnpip = $select_ip" >> $CONFIG_FILE
    fi
fi

echo "UPNPIFACE=["$UPNPIFACE"]"
if [[ -z "${UPNPIFACE}" ]]; then
    echo "UPNPIFACE not set"
else 
    echo "Setting UPNPIFACE to ["$UPNPIFACE"]"
    echo "upnpiface = $UPNPIFACE" >> $CONFIG_FILE
fi

echo "UPNPIP=["$UPNPIP"]"
if [[ -z "${UPNPIP}" ]]; then
    echo "UPNPIP not set"
else 
    echo "Setting UPNPIP to ["$UPNPIP"]"
    echo "upnpip = $UPNPIP" >> $CONFIG_FILE
fi

# Renderer mode
if [[ -n "${RENDERER_MODE}" ]]; then
    echo "RENDERER_MODE = [${RENDERER_MODE}]"
    UPNPAV=0
    OPENHOME=0
    if [[ "${RENDERER_MODE^^}" == "OPENHOME" ]]; then
        OPENHOME=1
    elif [[ "${RENDERER_MODE^^}" == "UPNPAV" ]]; then
        UPNPAV=1
    elif [[ "${RENDERER_MODE^^}" == "BOTH" ]]; then
        UPNPAV=1
        OPENHOME=1
    elif [[ "${RENDERER_MODE^^}" != "NONE" ]]; then
        echo "Invalid RENDERER_MODE [${RENDERER_MODE}]"
        exit 2
    fi
    echo "RENDERER_MODE=[${RENDERER_MODE}] => OPENHOME=[${OPENHOME}] UPNPAV=[${UPNPAV}]"
fi

# Friendly name management
if [[ -n "${FRIENDLY_NAME}" ]]; then
    echo "FRIENDLY_NAME=[${FRIENDLY_NAME}], UPNPAV_SKIP_NAME_POSTFIX=[${UPNPAV_SKIP_NAME_POSTFIX}]"
    if [[ -z "${UPMPD_FRIENDLY_NAME}" ]] && [[ $OPENHOME -eq 1 && $UPNPAV -eq 1 ]]; then
        UPMPD_FRIENDLY_NAME="${FRIENDLY_NAME} (OpenHome)"
    else
        UPMPD_FRIENDLY_NAME="${FRIENDLY_NAME}"
    fi
    echo "UPMPD_FRIENDLY_NAME=[${UPMPD_FRIENDLY_NAME}]"
    if [[ -z "${UPNPAV_SKIP_NAME_POSTFIX}" || "${UPNPAV_SKIP_NAME_POSTFIX^^}" == "YES" ]] && 
          [ "${OPENHOME}" -eq 0 ] && 
          [ "${UPNPAV}" -eq 1 ]; then
        AV_FRIENDLY_NAME="${FRIENDLY_NAME}"
    else
        PREPENDED=" "
        if [[ "${UPNPAV_POSTFIX_PREPEND_SPACE^^}" == "N" || "${UPNPAV_POSTFIX_PREPEND_SPACE^^}" == "NO" ]]; then
            PREPENDED=""
        elif [[ -n "${UPNPAV_POSTFIX_PREPEND_SPACE^^}" && !("${UPNPAV_POSTFIX_PREPEND_SPACE^^}" == "Y" || "${UPNPAV_POSTFIX_PREPEND_SPACE^^}" == "YES") ]]; then
            echo "Invalid UPNPAV_POSTFIX_PREPEND_SPACE [${UPNPAV_POSTFIX_PREPEND_SPACE}]"
            exit 2
        fi
        AV_POSTFIX=""
        if [[ -n "${UPNPAV_POSTFIX}" ]]; then
            AV_POSTFIX=${UPNPAV_POSTFIX}
        fi
        # prepend only if AV_POSTFIX is not empty
        if [[ -n "${AV_POSTFIX}" ]]; then
            AV_POSTFIX="$PREPENDED$AV_POSTFIX"
        fi
        AV_FRIENDLY_NAME="${FRIENDLY_NAME}${AV_POSTFIX}"
    fi
    echo "AV_FRIENDLY_NAME=[${AV_FRIENDLY_NAME}]"
    echo "OH_PRODUCT_ROOM=[${OH_PRODUCT_ROOM}]"
    MEDIA_SERVER_FRIENDLY_NAME="${FRIENDLY_NAME}"
    echo "MEDIA_SERVER_FRIENDLY_NAME=[${MEDIA_SERVER_FRIENDLY_NAME}]"
fi

if [[ -n "${UPNPPORT}" ]]; then
    echo "upnpport = $UPNPPORT" >> $CONFIG_FILE
fi

echo "upnpav = ${UPNPAV}" >> $CONFIG_FILE
echo "openhome = ${OPENHOME}" >> $CONFIG_FILE

if [[ "${OPENHOME}" -eq 1 ]]; then
    echo "friendlyname = ${UPMPD_FRIENDLY_NAME}" >> $CONFIG_FILE
fi
if [[ "${UPNPAV}" -eq 1 ]]; then
    echo "avfriendlyname = ${AV_FRIENDLY_NAME}" >> $CONFIG_FILE
fi
if [[ "${OPENHOME}" -eq 1 ]] || [[ "${UPNPAV}" -eq 1 ]]; then
    if [[ -n "${OH_PRODUCT_ROOM}" ]]; then
        echo "ohproductroom = ${OH_PRODUCT_ROOM}" >> $CONFIG_FILE
    elif [[ "${OPENHOME}" -eq 1 ]]; then
        echo "ohproductroom = ${UPMPD_FRIENDLY_NAME}" >> $CONFIG_FILE
    elif [[ "${UPNPAV}" -eq 1 ]]; then
        echo "ohproductroom = ${AV_FRIENDLY_NAME}" >> $CONFIG_FILE
    fi
fi

if [[ -n "${MPD_HOST}" ]]; then
    echo "mpdhost = $MPD_HOST" >> $CONFIG_FILE
fi
if [[ -n "${MPD_PORT}" ]]; then
    echo "mpdport = $MPD_PORT" >> $CONFIG_FILE
fi
if [[ -n "${MPD_PASSWORD}" ]]; then
    echo "mpdpassword = $MPD_PASSWORD" >> $CONFIG_FILE
fi
if [[ -n "${MPD_TIMEOUT_MS}" ]]; then
    echo "mpdtimeoutms = $MPD_TIMEOUT_MS" >> $CONFIG_FILE
fi
if [[ -n "${OWN_QUEUE}" ]]; then
    echo "ownqueue = $OWN_QUEUE" >> $CONFIG_FILE
fi

set_parameter $CONFIG_FILE PLG_MICRO_HTTP_HOST "$PLG_MICRO_HTTP_HOST" plgmicrohttphost
set_parameter $CONFIG_FILE PLG_MICRO_HTTP_PORT "$PLG_MICRO_HTTP_PORT" plgmicrohttpport
set_parameter $CONFIG_FILE PLG_PROXY_METHOD "$PLG_PROXY_METHOD" plgproxymethod


echo "CHECK_CONTENT_FORMAT=[${CHECK_CONTENT_FORMAT}]"
if [[ -n "${CHECK_CONTENT_FORMAT}" ]]; then
    if [[ "${CHECK_CONTENT_FORMAT^^}" == "YES" || "${CHECK_CONTENT_FORMAT^^}" == "Y" ]]; then
        check_content_format_value=1
    elif [[ "${CHECK_CONTENT_FORMAT^^}" == "NO" || "${CHECK_CONTENT_FORMAT^^}" == "N" ]]; then
        check_content_format_value=0
    else
        echo "Invalid CHECK_CONTENT_FORMAT [${CHECK_CONTENT_FORMAT}]"
        exit 2
    fi
    echo "Setting checkcontentformat to [$check_content_format_value]"
    set_parameter $CONFIG_FILE CHECK_CONTENT_FORMAT "$check_content_format_value" checkcontentformat
fi

echo "WEBSERVER_DOCUMENT_ROOT=[${WEBSERVER_DOCUMENT_ROOT}]"
if [[ -n "${WEBSERVER_DOCUMENT_ROOT}" ]]; then
    echo "Setting webserverdocumentroot to [$WEBSERVER_DOCUMENT_ROOT]"
    echo "webserverdocumentroot = $WEBSERVER_DOCUMENT_ROOT" >> $CONFIG_FILE
fi

MEDIA_SERVER_ENABLED=0
if [[ "${UPRCL_ENABLE^^}" == "YES" || 
      "${RADIO_BROWSER_ENABLE^^}" == "YES" ||
      "${RADIOS_ENABLE^^}" == "YES" ||
      "${BBC_ENABLE^^}" == "YES" ||
      "${SUBSONIC_ENABLE^^}" == "YES" ||
      "${TIDAL_ENABLE^^}" == "YES" ||
      "${HRA_ENABLE^^}" == "YES" ||
      "${HRA_ENABLE^^}" == "YES" ||
      "${RADIO_PARADISE_ENABLE^^}" == "YES" ||
      "${MOTHER_EARTH_RADIO_ENABLE^^}" == "YES" ||
      "${QOBUZ_ENABLE^^}" == "YES" ]]; then
    MEDIA_SERVER_ENABLED=1
fi

echo "MEDIA_SERVER_ENABLED=[${MEDIA_SERVER_ENABLED}]"
if [[ "${MEDIA_SERVER_ENABLED}" -eq 1 ]]; then
    echo "Setting msfriendlyname to [${MEDIA_SERVER_FRIENDLY_NAME}]"
    set_parameter $CONFIG_FILE MEDIA_SERVER_FRIENDLY_NAME "$MEDIA_SERVER_FRIENDLY_NAME" msfriendlyname
fi

echo "RADIOS_ENABLE=[$RADIOS_ENABLE]"
if [[ "${RADIOS_ENABLE^^}" == "YES" ]]; then
    echo "Enabling Radios";
    RADIOS_ENABLE=YES
    echo "upradiosuser = upradiosuser" >> $CONFIG_FILE
    if [[ -z "${RADIOS_AUTOSTART}" || "${RADIOS_AUTOSTART}" == "1" || "${RADIOS_AUTOSTART^^}" == "YES" ]]; then
        RADIOS_AUTOSTART=1
        echo "upradiosautostart = $RADIOS_AUTOSTART" >> $CONFIG_FILE
    fi
fi

echo "BBC_ENABLE=[$BBC_ENABLE]"
if [[ "${BBC_ENABLE^^}" == "YES" ]]; then
    echo "Enabling BBC";
    BBC_ENABLE=YES
    echo "bbcuser = bbcuser" >> $CONFIG_FILE
    echo "bbctitle = BBC" >> $CONFIG_FILE
    if [[ -n "${BBC_PROGRAMME_DAYS}" ]]; then
        if ! [[ $BBC_PROGRAMME_DAYS =~ '^[0-9]+$' ]]; then
            echo "BBC_PROGRAMME_DAYS [$BBC_PROGRAMME_DAYS] is not a number, ignored."
        fi
        echo "bbcprogrammedays = $BBC_PROGRAMME_DAYS" >> $CONFIG_FILE
    fi
fi

echo "RADIO_BROWSER_ENABLE=[$RADIO_BROWSER_ENABLE]"
if [[ "${RADIO_BROWSER_ENABLE^^}" == "YES" ]]; then
    echo "Enabling Radio Browser";
    RADIO_BROWSER_ENABLE=YES
    echo "radio-browseruser = radio-browseruser" >> $CONFIG_FILE
    echo "radio-browsertitle = Radio Browser" >> $CONFIG_FILE
fi

echo "SUBSONIC_ENABLE=[$SUBSONIC_ENABLE]"
if [[ "${SUBSONIC_ENABLE^^}" == "YES" ]]; then
    echo "Enabling Subsonic, processing settings";
    SUBSONIC_ENABLE=YES
    # do we need to download a newer subsonic-connector library?
    if [[ -n "${SUBSONIC_FORCE_CONNECTOR_VERSION}" ]]; then
        echo "Installing subsonic-connector version [${SUBSONIC_FORCE_CONNECTOR_VERSION}]"
        break_needed=`cat /app/conf/pip-install-break-needed`
        pip_switch=""
        if [[ "${break_needed}" == "yes" ]]; then
            pip_switch="--break-system-packages"
        fi
        pip_cmd="pip install ${pip_switch} subsonic-connector==${SUBSONIC_FORCE_CONNECTOR_VERSION}"
        echo "pip_cmd: [${pip_cmd}]"
        eval $pip_cmd
    fi
    echo "SUBSONIC_AUTOSTART=[$SUBSONIC_AUTOSTART]"
    if [[ -z "${SUBSONIC_AUTOSTART^^}" || "${SUBSONIC_AUTOSTART}" == "1" || "${SUBSONIC_AUTOSTART^^}" == "YES" ]]; then
        SUBSONIC_AUTOSTART=1
        echo "subsonicautostart = $SUBSONIC_AUTOSTART" >> $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_TITLE}" ]]; then
        echo "SUBSONIC_TITLE=[$SUBSONIC_TITLE]"
        echo "subsonictitle = ${SUBSONIC_TITLE}" >> $CONFIG_FILE
    fi
    echo "Setting subsonic base_url [$SUBSONIC_BASE_URL]"
    echo "subsonicbaseurl = ${SUBSONIC_BASE_URL}" >> $CONFIG_FILE
    echo "Setting subsonic port [$SUBSONIC_PORT]"
    echo "subsonicport = $SUBSONIC_PORT" >> $CONFIG_FILE
    echo "Setting subsonic username [$SUBSONIC_USER]"
    echo "subsonicuser = $SUBSONIC_USER" >> $CONFIG_FILE
    echo "Setting subsonic password [$SUBSONIC_PASSWORD]"
    echo "subsonicpassword = ${SUBSONIC_PASSWORD}" >> $CONFIG_FILE
    if [[ -n "${SUBSONIC_LEGACYAUTH}" ]]; then
        legacy_auth_value=0
        if [[ "${SUBSONIC_LEGACYAUTH^^}" == "YES" || "${SUBSONIC_LEGACYAUTH^^}" == "Y" || "${SUBSONIC_LEGACYAUTH^^}" == "TRUE" ]]; then
            legacy_auth_value=1
        elif [[ ! ("${SUBSONIC_LEGACYAUTH^^}" == "NO" || "${SUBSONIC_LEGACYAUTH^^}" == "N" || "${SUBSONIC_LEGACYAUTH^^}" == "FALSE") ]]; then
            echo "Invalid SUBSONIC_LEGACYAUTH [${SUBSONIC_LEGACYAUTH}]"
            exit 2
        fi
        echo "subsoniclegacyauth = $legacy_auth_value" >> $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_SERVER_PATH}" ]]; then
        echo "subsonicserverpath = ${SUBSONIC_SERVER_PATH}" >> $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_SERVER_SIDE_SCROBBLING}" ]]; then
        server_side_scrobbling=0
        if [[ "${SUBSONIC_SERVER_SIDE_SCROBBLING^^}" == "YES" || "${SUBSONIC_SERVER_SIDE_SCROBBLING^^}" == "Y" ]]; then
            server_side_scrobbling=1
        elif [[ ! ("${SUBSONIC_SERVER_SIDE_SCROBBLING^^}" == "NO" || "${SUBSONIC_SERVER_SIDE_SCROBBLING^^}" == "N") ]]; then
            echo "Invalid SUBSONIC_SERVER_SIDE_SCROBBLING [${SUBSONIC_SERVER_SIDE_SCROBBLING}]"
            exit 2
        fi
        echo "subsonicserversidescrobbling = $server_side_scrobbling" >> $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_ITEMS_PER_PAGE}" ]]; then
        echo "subsonicitemsperpage = $SUBSONIC_ITEMS_PER_PAGE" >> $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_APPEND_YEAR_TO_ALBUM_CONTAINER}" ]]; then
        append_year=1
        if [[ "${SUBSONIC_APPEND_YEAR_TO_ALBUM_CONTAINER^^}" == "NO" ]]; then
            append_year=0
        elif [[ ! "${SUBSONIC_APPEND_YEAR_TO_ALBUM_CONTAINER^^}" == "YES" ]]; then
            echo "Invalid SUBSONIC_APPEND_YEAR_TO_ALBUM_CONTAINER [${SUBSONIC_APPEND_YEAR_TO_ALBUM_CONTAINER}]"
            exit 2
        fi
        echo "subsonicappendyeartoalbumcontainer = $append_year" >> $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_APPEND_CODECS_TO_ALBUM}" ]]; then
        append_codecs=1
        if [[ "${SUBSONIC_APPEND_CODECS_TO_ALBUM^^}" == "NO" ]]; then
            append_codecs=0
        elif [[ ! "${SUBSONIC_APPEND_CODECS_TO_ALBUM^^}" == "YES" ]]; then
            echo "Invalid SUBSONIC_APPEND_CODECS_TO_ALBUM [${SUBSONIC_APPEND_CODECS_TO_ALBUM}]"
            exit 2
        fi
        echo "subsonicappendcodecstoalbum = $append_codecs" >> $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_PREPEND_NUMBER_IN_ALBUM_LIST}" ]]; then
        prepend_number=1
        if [[ "${SUBSONIC_PREPEND_NUMBER_IN_ALBUM_LIST^^}" == "NO" ]]; then
            prepend_number=0
        elif [[ ! "${SUBSONIC_PREPEND_NUMBER_IN_ALBUM_LIST^^}" == "YES" ]]; then
            echo "Invalid SUBSONIC_PREPEND_NUMBER_IN_ALBUM_LIST [${SUBSONIC_PREPEND_NUMBER_IN_ALBUM_LIST}]"
            exit 2
        fi
        echo "subsonicprependnumberinalbumlist = $prepend_number" >> $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_WHITELIST_CODECS}" ]]; then
        echo "subsonicwhitelistcodecs = ${$SUBSONIC_WHITELIST_CODECS}" >> $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_TRANSCODE_CODEC}" ]]; then
        echo "subsonictranscodecodec = $SUBSONIC_TRANSCODE_CODEC" >> $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_TRANSCODE_MAX_BITRATE}" ]]; then
        echo "subsonictranscodemaxbitrate = $SUBSONIC_TRANSCODE_MAX_BITRATE" >> $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_ENABLE_INTERNET_RADIOS}" ]]; then
        enable_ir=1
        if [[ "${SUBSONIC_ENABLE_INTERNET_RADIOS^^}" == "NO" ]]; then
            enable_ir=0
        elif [[ ! "${SUBSONIC_ENABLE_INTERNET_RADIOS^^}" == "YES" ]]; then
            echo "Invalid SUBSONIC_ENABLE_INTERNET_RADIOS [${SUBSONIC_ENABLE_INTERNET_RADIOS}]"
            exit 2
        fi
        echo "subsonictaginitialpageenabledir = $enable_ir" >> $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_ENABLE_IMAGE_CACHING}" ]]; then
        enable_ic=1
        if [[ "${SUBSONIC_ENABLE_IMAGE_CACHING^^}" == "NO" ]]; then
            enable_ic=0
        elif [[ ! "${SUBSONIC_ENABLE_IMAGE_CACHING^^}" == "YES" ]]; then
            echo "Invalid SUBSONIC_ENABLE_IMAGE_CACHING [${SUBSONIC_ENABLE_IMAGE_CACHING}]"
            exit 2
        fi
        echo "subsonicenableimagecaching = $enable_ic" >> $CONFIG_FILE
    fi
fi

echo "RADIO_PARADISE_ENABLE=[$RADIO_PARADISE_ENABLE]"
if [[ "${RADIO_PARADISE_ENABLE^^}" == "YES" ]]; then
    echo "Enabling Radio Paradise, processing settings";
    RADIO_PARADISE_ENABLE=YES
    echo "radio-paradiseuser = radioparadise" >> $CONFIG_FILE
    echo "radio-paradisetitle = Radio Paradise" >> $CONFIG_FILE
fi

echo "MOTHER_EARTH_RADIO_ENABLE=[$MOTHER_EARTH_RADIO_ENABLE]"
if [[ "${MOTHER_EARTH_RADIO_ENABLE^^}" == "YES" ]]; then
    echo "Enabling Mother Earth Radio, processing settings";
    MOTHER_EARTH_RADIO_ENABLE=YES
    # sed -i 's/\#mother-earth-radiouser/mother-earth-radiouser/g' $CONFIG_FILE
    # sed -i 's/\#mother-earth-radiotitle/mother-earth-radiotitle/g' $CONFIG_FILE
    echo "mother-earth-radiouser = motherearthradio" >> $CONFIG_FILE
    echo "mother-earth-radiotitle = Mother Earth Radio" >> $CONFIG_FILE
fi

echo "TIDAL_ENABLE=[$TIDAL_ENABLE]"
if [[ "${TIDAL_ENABLE^^}" == "YES" ]]; then
    echo "Enabling new Tidal, processing settings";
    TIDAL_ENABLE=YES

    # do we need to download a newer tidal-api library?
    if [[ -n "${TIDAL_FORCE_TIDALAPI_VERSION}" ]]; then
        echo "Installing tidalapi version [${TIDAL_FORCE_TIDALAPI_VERSION}]"
        break_needed=`cat /app/conf/pip-install-break-needed`
        pip_switch=""
        if [[ "${break_needed}" == "yes" ]]; then
            pip_switch="--break-system-packages"
        fi
        pip_cmd="pip install ${pip_switch} tidalapi==${TIDAL_FORCE_TIDALAPI_VERSION}"
        echo "pip_cmd: [${pip_cmd}]"
        eval $pip_cmd
    fi

    echo "tidaluser = tidaluser" >> $CONFIG_FILE
    if [[ -n "${TIDAL_TITLE}" ]]; then
        echo "tidaltitle = ${TIDAL_TITLE}" >> $CONFIG_FILE
    fi
    echo "TIDAL_AUTOSTART=[$TIDAL_AUTOSTART]"
    if [[ -z "${TIDAL_AUTOSTART^^}" || "${TIDAL_AUTOSTART}" == "1" || "${SUBSONIC_AUTOSTART^^}" == "YES" ]]; then
        TIDAL_AUTOSTART=1
        echo "tidalautostart = $TIDAL_AUTOSTART" >> $CONFIG_FILE
    fi
    if [[ -z "$TIDAL_AUDIO_QUALITY" ]]; then
        TIDAL_AUDIO_QUALITY="LOSSLESS"   
    fi
    echo "Setting Audio Quality [$TIDAL_AUDIO_QUALITY]"
    echo "tidalaudioquality = $TIDAL_AUDIO_QUALITY" >> $CONFIG_FILE
    if [[ -n "${TIDAL_PREPEND_NUMBER_IN_ITEM_LIST}" ]]; then
        echo "TIDAL_PREPEND_NUMBER_IN_ITEM_LIST=[${TIDAL_PREPEND_NUMBER_IN_ITEM_LIST}]"
        if [[ "${TIDAL_PREPEND_NUMBER_IN_ITEM_LIST^^}" == "YES" || "${TIDAL_PREPEND_NUMBER_IN_ITEM_LIST^^}" == "Y" ]]; then
            #set prependnumberinitemlist
            echo "tidalprependnumberinitemlist = 1" >> $CONFIG_FILE
        elif [[ "${TIDAL_PREPEND_NUMBER_IN_ITEM_LIST^^}" != "NO" && "${TIDAL_PREPEND_NUMBER_IN_ITEM_LIST^^}" == "N" ]]; then
            echo "Invalid TIDAL_PREPEND_NUMBER_IN_ITEM_LIST=[${TIDAL_PREPEND_NUMBER_IN_ITEM_LIST}]"
            exit 3
        fi
    fi
    # image caching
    if [[ -n "${TIDAL_ENABLE_IMAGE_CACHING}" ]]; then
        if [[ "${TIDAL_ENABLE_IMAGE_CACHING^^}" == "YES" || "${TIDAL_ENABLE_IMAGE_CACHING^^}" == "Y" ]]; then
            echo "tidalenableimagecaching = 1" >> $CONFIG_FILE
        elif [[ "${TIDAL_ENABLE_IMAGE_CACHING^^}" != "NO" && "${TIDAL_ENABLE_IMAGE_CACHING^^}" == "N" ]]; then
            echo "Invalid TIDAL_ENABLE_IMAGE_CACHING=[${TIDAL_ENABLE_IMAGE_CACHING}]"
            exit 3
        fi
    fi
    # favorite actions
    if [[ -n "${TIDAL_ALLOW_FAVORITE_ACTIONS}" ]]; then
        if [[ "${TIDAL_ALLOW_FAVORITE_ACTIONS^^}" == "YES" || "${TIDAL_ALLOW_FAVORITE_ACTIONS^^}" == "Y" ]]; then
            echo "tidalallowfavoriteactions = 1" >> $CONFIG_FILE
        elif [[ "${TIDAL_ALLOW_FAVORITE_ACTIONS^^}" != "NO" && "${TIDAL_ALLOW_FAVORITE_ACTIONS^^}" == "N" ]]; then
            echo "Invalid TIDAL_ALLOW_FAVORITE_ACTIONS=[${TIDAL_ALLOW_FAVORITE_ACTIONS}]"
            exit 3
        fi
    fi
    # booknark actions
    if [[ -n "${TIDAL_ALLOW_BOOKMARK_ACTIONS}" ]]; then
        if [[ "${TIDAL_ALLOW_BOOKMARK_ACTIONS^^}" == "YES" || "${TIDAL_ALLOW_BOOKMARK_ACTIONS^^}" == "Y" ]]; then
            echo "tidalallowbookmarkactions = 1" >> $CONFIG_FILE
        elif [[ "${TIDAL_ALLOW_BOOKMARK_ACTIONS^^}" != "NO" && "${TIDAL_ALLOW_BOOKMARK_ACTIONS^^}" == "N" ]]; then
            echo "Invalid TIDAL_ALLOW_BOOKMARK_ACTIONS=[${TIDAL_ALLOW_BOOKMARK_ACTIONS}]"
            exit 3
        fi
    fi
    # favorite actions
    if [[ -n "${TIDAL_ALLOW_STATISTICS_ACTIONS}" ]]; then
        if [[ "${TIDAL_ALLOW_STATISTICS_ACTIONS^^}" == "YES" || "${TIDAL_ALLOW_STATISTICS_ACTIONS^^}" == "Y" ]]; then
            echo "tidalallowstatisticsactions = 1" >> $CONFIG_FILE
        elif [[ "${TIDAL_ALLOW_STATISTICS_ACTIONS^^}" != "NO" && "${TIDAL_ALLOW_STATISTICS_ACTIONS^^}" == "N" ]]; then
            echo "Invalid TIDAL_ALLOW_STATISTICS_ACTIONS=[${TIDAL_ALLOW_STATISTICS_ACTIONS}]"
            exit 3
        fi
    fi
    # agent whitelist TIDAL_ENABLE_USER_AGENT_WHITELIST
    if [[ -n "${TIDAL_ENABLE_USER_AGENT_WHITELIST}" ]]; then
        if [[ "${TIDAL_ENABLE_USER_AGENT_WHITELIST^^}" == "YES" || "${TIDAL_ENABLE_USER_AGENT_WHITELIST^^}" == "Y" ]]; then
            echo "tidalenableuseragentwhitelist = 1" >> $CONFIG_FILE
        elif [[ "${TIDAL_ENABLE_USER_AGENT_WHITELIST^^}" == "NO" || "${TIDAL_ENABLE_USER_AGENT_WHITELIST^^}" == "N" ]]; then
            echo "tidalenableuseragentwhitelist = 0" >> $CONFIG_FILE
        else
            echo "Invalid TIDAL_ENABLE_USER_AGENT_WHITELIST=[${TIDAL_ENABLE_USER_AGENT_WHITELIST}]"
            exit 3
        fi
    fi
fi

echo "Qobuz Enable [$QOBUZ_ENABLE]"
if [[ "${QOBUZ_ENABLE^^}" == "YES" ]]; then
    echo "Processing Qobuz settings";
    if [[ -n "${QOBUZ_TITLE}" ]]; then
        echo "qobuztitle = ${QOBUZ_TITLE}" >> $CONFIG_FILE
    fi
    echo "qobuzuser = $QOBUZ_USERNAME" >> $CONFIG_FILE
    echo "qobuzpass = $QOBUZ_PASSWORD" >> $CONFIG_FILE
    if [[ -n "${QOBUZ_FORMAT_ID}" ]]; then
        echo "qobuzformatid = $QOBUZ_FORMAT_ID" >> $CONFIG_FILE
    fi
    if [[ -n "${QOBUZ_RENUM_TRACKS}" ]]; then
        qobuz_v=${QOBUZ_RENUM_TRACKS}
        if [[ "${qobuz_v}" == "0" || "${qobuz_v}" == "1" ]]; then
            echo "qobuzrenumtracks = $QOBUZ_RENUM_TRACKS" >> $CONFIG_FILE
        else
            echo "Invalid QOBUZ_RENUM_TRACKS=[${QOBUZ_RENUM_TRACKS}]"
            exit 3
        fi
    fi
    if [[ -n "${QOBUZ_EXPLICIT_ITEM_NUMBERS}" ]]; then
        qobuz_v=${QOBUZ_EXPLICIT_ITEM_NUMBERS}
        if [[ "${qobuz_v}" == "0" || "${qobuz_v}" == "1" ]]; then
            echo "qobuzexplicititemnumbers = $QOBUZ_EXPLICIT_ITEM_NUMBERS" >> $CONFIG_FILE
        else
            echo "Invalid QOBUZ_EXPLICIT_ITEM_NUMBERS=[${QOBUZ_EXPLICIT_ITEM_NUMBERS}]"
            exit 3
        fi
    fi
    if [[ -n "${QOBUZ_PREPEND_ARTIST_TO_ALBUM}" ]]; then
        qobuz_v=${QOBUZ_PREPEND_ARTIST_TO_ALBUM}
        if [[ "${qobuz_v}" == "0" || "${qobuz_v}" == "1" ]]; then
            echo "qobuzprependartisttoalbum = $QOBUZ_PREPEND_ARTIST_TO_ALBUM" >> $CONFIG_FILE
        else
            echo "Invalid QOBUZ_PREPEND_ARTIST_TO_ALBUM=[${QOBUZ_PREPEND_ARTIST_TO_ALBUM}]"
            exit 3
        fi
    fi
fi

echo "HRA Enable [$HRA_ENABLE]"
if [[ "${HRA_ENABLE^^}" == "YES" ]]; then
    echo "Processing HRA settings";
    echo "hrauser = $HRA_USERNAME" >> $CONFIG_FILE
    echo "hrapass = $HRA_PASSWORD" >> $CONFIG_FILE
    if [[ -n "${HRA_LANG}" ]]; then 
        echo "hralang = $HRA_LANG" >> $CONFIG_FILE
    fi
fi

echo "UPRCL_ENABLE [$UPRCL_ENABLE]"
if [[ "${UPRCL_ENABLE^^}" == "YES" ]]; then
    echo "enabling uprclconfdir"
    echo "uprclconfdir = /uprcl/confdir" >> $CONFIG_FILE
    echo "enabling uprclmediadirs"
    echo "uprclmediadirs = /uprcl/mediadirs" >> $CONFIG_FILE
    echo "UPRCL_TITLE [$UPRCL_TITLE]"
    if [[ -n "${UPRCL_TITLE}" ]]; then
        echo "Setting uprcltitle $UPRCL_TITLE"
        echo "uprcltitle = $UPRCL_TITLE" >> $CONFIG_FILE
    fi
    # set UPRCL_USER if not empty
    echo "UPRCL_USER [$UPRCL_USER]"
    if [[ -n "${UPRCL_USER}" ]]; then
        echo "Setting uprcluser $UPRCL_USER"
        echo "uprcluser = $UPRCL_USER" >> $CONFIG_FILE
    fi
    echo "UPRCL_HOSTPORT [$UPRCL_HOSTPORT]"
    if [[ -n "${UPRCL_HOSTPORT}" ]]; then
        echo "Setting uprclhostport $UPRCL_HOSTPORT"
        echo "uprclhostport = $UPRCL_HOSTPORT" >> $CONFIG_FILE
    fi
    echo "UPRCL_AUTOSTART [$UPRCL_AUTOSTART]"
    if [[ -z "${UPRCL_AUTOSTART}" || "${UPRCL_AUTOSTART}" == "1" || "${UPRCL_AUTOSTART^^}" == "YES" ]]; then
        UPRCL_AUTOSTART=1
        echo "Setting uprclautostart $UPRCL_AUTOSTART"
        echo "uprclautostart = $UPRCL_AUTOSTART" >> $CONFIG_FILE
    fi
    UPRCL_USER_CONFIG_FILE="/user/config/recoll.conf.user"
    if [[ -f "$UPRCL_USER_CONFIG_FILE" ]]; then
        echo "uprclconfrecolluser = /user/config/recoll.conf.user" >> $CONFIG_FILE
    fi
fi

cache_directory=/cache
if [[ ! -w "$cache_directory" ]]; then
    echo "Cache directory [${cache_directory}] is not writable"
    cache_directory="/tmp/cache"
    mkdir -p /tmp/cache
else
    echo "Cache directory [${cache_directory}] is writable"
fi
echo "cachedir = $cache_directory" >> $CONFIG_FILE

log_directory=/log
if [[ ! -w "$log_directory" ]]; then
    echo "Log directory [${log_directory}] is not writable"
    mkdir -p /tmp/log
    log_directory="/tmp/log"
else
    echo "Log directory [${log_directory}] is writable"
fi

# log file support
if [[ "${LOG_ENABLE^^}" == "YES" ]]; then
    echo "logfilename = $log_directory/upmpdcli.log"
fi

# log level
if [[ -n "${LOG_LEVEL}" ]]; then
    echo "loglevel = $LOG_LEVEL" >> $CONFIG_FILE
fi

# upnp log file support
if [[ "${UPNP_LOG_ENABLE^^}" == "YES" ]]; then
    echo "upnplogfilename = $log_directory/upnp.log" >> $CONFIG_FILE
fi

# upnp log level
if [[ -n "${UPNP_LOG_LEVEL}" ]]; then
    echo "upnploglevel = $UPNP_LOG_LEVEL" >> $CONFIG_FILE
fi

if [[ -f $UPMPDCLI_ADDITIONAL_FILE ]]; then
    echo "File [$UPMPDCLI_ADDITIONAL_FILE] is available, appending to [$CONFIG_FILE] ..."
    cat $UPMPDCLI_ADDITIONAL_FILE >> $CONFIG_FILE
    sed -i -e '$a\' $CONFIG_FILE
    echo "Done."
fi

cat $CONFIG_FILE

if [[ $current_user_id == 0 ]]; then

    # create directory as we are root
    if [[ -n "${WEBSERVER_DOCUMENT_ROOT}" ]]; then
        echo "Creating directory [${WEBSERVER_DOCUMENT_ROOT}] ..."
        mkdir -p $WEBSERVER_DOCUMENT_ROOT
        echo "Created directory [${WEBSERVER_DOCUMENT_ROOT}]."
    fi

    DEFAULT_UID=1000
    DEFAULT_GID=1000

    if [[ -z "${PUID}" ]]; then
        PUID=$DEFAULT_UID
    fi
    if [[ -z "${PGID}" ]]; then
        PGID=$DEFAULT_GID
    fi

    DEFAULT_USER_NAME=upmpd-user
    DEFAULT_GROUP_NAME=upmpd-user
    DEFAULT_HOME_DIR=/home/$DEFAULT_USER_NAME

    USER_NAME=$DEFAULT_USER_NAME
    GROUP_NAME=$DEFAULT_GROUP_NAME
    HOME_DIR=$DEFAULT_HOME_DIR

    if [[ -z "${PUID}" ]]; then
        PUID=$DEFAULT_UID;
        echo "Setting default value for PUID: ["$PUID"]"
    fi

    if [[ -z "${PGID}" ]]; then
        PGID=$DEFAULT_GID;
        echo "Setting default value for PGID: ["$PGID"]"
    fi

    echo "Ensuring user with uid:[$PUID] gid:[$PGID] exists ...";

    ### create group if it does not exist
    if [[ ! $(getent group $PGID) ]]; then
        echo "Group with gid [$PGID] does not exist, creating..."
        groupadd -g $PGID $GROUP_NAME
        echo "Group [$GROUP_NAME] with gid [$PGID] created."
    else
        GROUP_NAME=$(getent group $PGID | cut -d: -f1)
        echo "Group with gid [$PGID] name [$GROUP_NAME] already exists."
    fi

    ### create user if it does not exist
    if [[ ! $(getent passwd $PUID) ]]; then
        echo "User with uid [$PUID] does not exist, creating..."
        useradd -g $PGID -u $PUID -M $USER_NAME
        echo "User [$USER_NAME] with uid [$PUID] created."
    else
        USER_NAME=$(getent passwd $PUID | cut -d: -f1)
        echo "user with uid [$PUID] name [$USER_NAME] already exists."
        HOME_DIR="/home/$USER_NAME"
    fi

    ### create home directory
    if [[ ! -d "$HOME_DIR" ]]; then
        echo "Home directory [$HOME_DIR] not found, creating."
        mkdir -p $HOME_DIR
        echo ". done."
    fi

    # set home to user
    echo "Setting home directory to [$HOME_DIR] for user [$USER_NAME] ..."
    usermod -d $HOME_DIR $USER_NAME
    echo ". done."

    # set shell
    echo "Setting shell to [/bin/bash] for user [$USER_NAME] ..."
    usermod -s /bin/bash $USER_NAME
    echo ". done."

    # set permission for home directory
    echo "Setting home directory permissions ..."
    chown -R $USER_NAME:$GROUP_NAME $HOME_DIR
    echo ". done."

    # Permissions of writable volumes
    echo "Setting permissions for writable volumes ..."
    skip_cache_chown=0
    if [[ "${SKIP_CHOWN_CACHE^^}" == "YES" ]] || [[ "${SKIP_CHOWN_CACHE^^}" == "Y" ]]; then
        skip_cache_chown=1
    else
        if [[ -n "${SKIP_CHOWN_CACHE}" ]]; then
            # must be NO now
            if [[ "${SKIP_CHOWN_CACHE^^}" != "NO" ]] && [[ "${SKIP_CHOWN_CACHE^^}" != "N" ]]; then
                echo "Invalid SKIP_CHOWN_CACHE=[${SKIP_CHOWN_CACHE}]"
                exit 1
            fi
        fi
    fi
    if [[ $skip_cache_chown -eq 0 ]]; then
        chown -R $USER_NAME:$GROUP_NAME /cache
        # Fix permission errors on existing files
        find /cache -type d -exec chmod 755 {} \;
        find /cache -type f -exec chmod 644 {} \;
    else
        echo "Not executing ownership changes to /cache because SKIP_CHOWN_CACHE=[${SKIP_CHOWN_CACHE}]"
    fi
    # uprcl and under
    chown -R $USER_NAME:$GROUP_NAME /uprcl/confdir
    chown -R $USER_NAME:$GROUP_NAME /user/config
    chown -R $USER_NAME:$GROUP_NAME /log
    echo ". done."

    # Correct permissions for WEBSERVER_DOCUMENT_ROOT if set
    if [[ -n "${WEBSERVER_DOCUMENT_ROOT}" ]]; then
        echo "Setting permissions for directory [${WEBSERVER_DOCUMENT_ROOT}] ..."
        chown -R $USER_NAME:$GROUP_NAME $WEBSERVER_DOCUMENT_ROOT
        echo ". done."
    fi
fi

build_mode=`cat /app/conf/build_mode.txt`

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC
echo "Ready to start."

CMD_LINE="/usr/bin/upmpdcli -c $CONFIG_FILE"
echo "CMD_LINE=[${CMD_LINE}]"

if [[ $current_user_id -eq 0 ]]; then
    echo "USER MODE [$USER_NAME]"
    exec su - $USER_NAME -c "$CMD_LINE"
else
    echo "Running as current uid [$current_user_id] ..."
    eval "exec $CMD_LINE"
fi
