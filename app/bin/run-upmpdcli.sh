#!/bin/bash

## error codes
# 1 Generic error
# 2 Invalid RENDERER_MODE value
# 3 Invalid argument

current_user_id=$(id -u)
echo "Current user id is [$current_user_id]"

if [[ "${current_user_id}" != "0" ]]; then
    echo "Not running as root, will not be able to:"
    echo "- create users" 
    echo "- update plugins" 
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
        cp upmpdcli/src/mediaserver/cdplugins/mother-earth-radio/* /usr/share/upmpdcli/cdplugins/mother-earth-radio/
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
        cp upmpdcli/src/mediaserver/cdplugins/radio-paradise/* /usr/share/upmpdcli/cdplugins/radio-paradise/
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
        cp upmpdcli/src/mediaserver/cdplugins/subsonic/* /usr/share/upmpdcli/cdplugins/subsonic/
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
        cp upmpdcli/src/mediaserver/cdplugins/tidal/* /usr/share/upmpdcli/cdplugins/tidal/
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
if [[ -z "${ENABLE_AUTO_UPNP}" || "$ENABLE_AUTO_UPNPIP" == "1" || "${ENABLE_AUTO_UPNPIP^^}" == "YES" || "${ENABLE_AUTO_UPNPIP^^}" == "Y" ]]; then
    if [[ -z "${UPNPIP}" ]]; then
        set_upnp_ip=1
    else
        echo "Cannot set UPNPIP with ENABLE_AUTO_UPNPIP enabled"
        exit 1
    fi
fi

#if [[ -z "$ENABLE_AUTO_UPNPIFACE" || "$ENABLE_AUTO_UPNPIFACE" == "1" || "${ENABLE_AUTO_UPNPIFACE^^}" == "YES" || "${ENABLE_AUTO_UPNPIFACE^^}" == "Y" ]]; then
if [[ set_upnp_iface -eq 1 && set_upnp_ip -eq 1 ]]; then
    echo "Cannot enable both ENABLE_AUTO_UPNPIFACE and ENABLE_AUTO_UPNPIP"
    exit 1
fi

if [[ set_upnp_iface -eq 1 || set_upnp_ip -eq 1 ]]; then
    if [[ -z "${AUTO_UPNPIFACE_URL}" ]]; then
        AUTO_UPNPIFACE_URL=1.1.1.1
    fi
    iface=$(ip route get $AUTO_UPNPIFACE_URL | grep -oP 'dev\s+\K[^ ]+')
    select_ip=$(ifconfig $iface | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
    if [[ set_upnp_iface -eq 1 ]]; then
        echo "Automatically setting UPNPIFACE to ["$iface"]"
        sed -i 's/\#upnpiface/upnpiface/g' $CONFIG_FILE
        sed -i 's/UPNPIFACE/'"$iface"'/g' $CONFIG_FILE
    fi
    if [[ set_upnp_ip -eq 1 ]]; then
        echo "Automatically setting UPNPIP to ["$select_ip"]"
        sed -i 's/\#upnpip/upnpip/g' $CONFIG_FILE
        sed -i 's/UPNPIP/'"$select_ip"'/g' $CONFIG_FILE
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

echo "UPNPIP=["$UPNPIP"]"
if [ -z "${UPNPIP}" ]; then
    echo "UPNPIP not set"
else 
    echo "Setting UPNPIP to ["$UPNPIP"]"
    sed -i 's/\#upnpip/upnpip/g' $CONFIG_FILE
    sed -i 's/UPNPIP/'"$UPNPIP"'/g' $CONFIG_FILE
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
    if [[ -z "${OH_PRODUCT_ROOM}" ]]; then
        OH_PRODUCT_ROOM="${AV_FRIENDLY_NAME}"
    fi
    echo "AV_FRIENDLY_NAME=[${AV_FRIENDLY_NAME}]"
    echo "OH_PRODUCT_ROOM=[${OH_PRODUCT_ROOM}]"
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
    set_parameter $CONFIG_FILE OH_PRODUCT_ROOM "$OH_PRODUCT_ROOM" ohproductroom
fi
set_parameter $CONFIG_FILE MPD_HOST "$MPD_HOST" mpdhost
set_parameter $CONFIG_FILE MPD_PORT "$MPD_PORT" mpdport
set_parameter $CONFIG_FILE PLG_MICRO_HTTP_HOST "$PLG_MICRO_HTTP_HOST" plgmicrohttphost
set_parameter $CONFIG_FILE PLG_MICRO_HTTP_PORT "$PLG_MICRO_HTTP_PORT" plgmicrohttpport
set_parameter $CONFIG_FILE PLG_PROXY_METHOD "$PLG_PROXY_METHOD" plgproxymethod

set_parameter $CONFIG_FILE OWN_QUEUE "$OWN_QUEUE" ownqueue

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
    set_parameter $CONFIG_FILE CHECK_CONTENT_FORMAT "$check_content_format_value" "checkcontentformat"
fi

echo "WEBSERVER_DOCUMENT_ROOT=[${WEBSERVER_DOCUMENT_ROOT}]"
if [[ -n "${WEBSERVER_DOCUMENT_ROOT}" ]]; then
    echo "Setting webserverdocumentroot to [$WEBSERVER_DOCUMENT_ROOT]"
    sed -i 's/\#webserverdocumentroot/webserverdocumentroot/g' $CONFIG_FILE;
    sed -i 's+WEBSERVER_DOCUMENT_ROOT+'"$WEBSERVER_DOCUMENT_ROOT"'+g' $CONFIG_FILE
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
if [ "${MEDIA_SERVER_ENABLED}" -eq 1 ]; then
    echo "Setting msfriendlyname to [${MEDIA_SERVER_FRIENDLY_NAME}]"
    set_parameter $CONFIG_FILE MEDIA_SERVER_FRIENDLY_NAME "$MEDIA_SERVER_FRIENDLY_NAME" msfriendlyname
fi

echo "RADIOS_ENABLE=[$RADIOS_ENABLE]"
if [ "${RADIOS_ENABLE^^}" == "YES" ]; then
    echo "Enabling Radios";
    RADIOS_ENABLE=YES
    sed -i 's/\#upradiosuser/upradiosuser/g' $CONFIG_FILE;
    if [[ -z "${RADIOS_AUTOSTART}" || "${RADIOS_AUTOSTART}" == "1" || "${RADIOS_AUTOSTART^^}" == "YES" ]]; then
        RADIOS_AUTOSTART=1
        sed -i 's/\#upradiosautostart/upradiosautostart/g' $CONFIG_FILE;
        set_parameter $CONFIG_FILE RADIOS_AUTOSTART "$RADIOS_AUTOSTART" upradiosautostart
    fi
fi

echo "BBC_ENABLE=[$BBC_ENABLE]"
if [ "${BBC_ENABLE^^}" == "YES" ]; then
    echo "Enabling BBC";
    BBC_ENABLE=YES
    sed -i 's/\#bbcuser/bbcuser/g' $CONFIG_FILE;
    if [[ -n "${BBC_PROGRAMME_DAYS}" ]]; then
        if ! [[ $BBC_PROGRAMME_DAYS =~ '^[0-9]+$' ]]; then
            echo "BBC_PROGRAMME_DAYS [$BBC_PROGRAMME_DAYS] is not a number, ignored."
        fi
        sed -i 's/\#bbcprogrammedays/bbcprogrammedays/g' $CONFIG_FILE;
        sed -i 's/BBC_PROGRAMME_DAYS/'"$BBC_PROGRAMME_DAYS"'/g' $CONFIG_FILE
    fi
fi

echo "RADIO_BROWSER_ENABLE=[$RADIO_BROWSER_ENABLE]"
if [ "${RADIO_BROWSER_ENABLE^^}" == "YES" ]; then
    echo "Enabling Radio Browser";
    RADIO_BROWSER_ENABLE=YES
    sed -i 's/\#radio-browseruser/radio-browseruser/g' $CONFIG_FILE;
fi

echo "SUBSONIC_ENABLE=[$SUBSONIC_ENABLE]"
if [ "${SUBSONIC_ENABLE^^}" == "YES" ]; then
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
    sed -i 's/\#subsonicuser/subsonicuser/g' $CONFIG_FILE
    echo "SUBSONIC_AUTOSTART=[$SUBSONIC_AUTOSTART]"
    if [[ -z "${SUBSONIC_AUTOSTART^^}" || "${SUBSONIC_AUTOSTART}" == "1" || "${SUBSONIC_AUTOSTART^^}" == "YES" ]]; then
        SUBSONIC_AUTOSTART=1
        sed -i 's/\#subsonicautostart/subsonicautostart/g' $CONFIG_FILE;
        set_parameter $CONFIG_FILE SUBSONIC_AUTOSTART "$SUBSONIC_AUTOSTART" subsonicautostart
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
    if [[ -n "${SUBSONIC_LEGACYAUTH}" ]]; then
        legacy_auth_value=0
        if [[ "${SUBSONIC_LEGACYAUTH^^}" == "YES" || "${SUBSONIC_LEGACYAUTH^^}" == "Y" || "${SUBSONIC_LEGACYAUTH^^}" == "TRUE" ]]; then
            legacy_auth_value=1
        elif [[ ! ("${SUBSONIC_LEGACYAUTH^^}" == "NO" || "${SUBSONIC_LEGACYAUTH^^}" == "N" || "${SUBSONIC_LEGACYAUTH^^}" == "FALSE") ]]; then
            echo "Invalid SUBSONIC_LEGACYAUTH [${SUBSONIC_LEGACYAUTH}]"
            exit 2
        fi
        sed -i 's/\#subsoniclegacyauth/subsoniclegacyauth/g' $CONFIG_FILE
        sed -i 's/SUBSONIC_LEGACYAUTH/'"$legacy_auth_value"'/g' $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_SERVER_SIDE_SCROBBLING}" ]]; then
        server_side_scrobbling=0
        if [[ "${SUBSONIC_SERVER_SIDE_SCROBBLING^^}" == "YES" || "${SUBSONIC_SERVER_SIDE_SCROBBLING^^}" == "Y" ]]; then
            server_side_scrobbling=1
        elif [[ ! ("${SUBSONIC_SERVER_SIDE_SCROBBLING^^}" == "NO" || "${SUBSONIC_SERVER_SIDE_SCROBBLING^^}" == "N") ]]; then
            echo "Invalid SUBSONIC_SERVER_SIDE_SCROBBLING [${SUBSONIC_SERVER_SIDE_SCROBBLING}]"
            exit 2
        fi
        sed -i 's/\#subsonicserversidescrobbling/subsonicserversidescrobbling/g' $CONFIG_FILE
        sed -i 's/SUBSONIC_SERVER_SIDE_SCROBBLING/'"$server_side_scrobbling"'/g' $CONFIG_FILE
    fi
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
    if [[ -n "${SUBSONIC_TRANSCODE_CODEC}" ]]; then
        sed -i 's/\#subsonictranscodecodec/subsonictranscodecodec/g' $CONFIG_FILE
        sed -i 's/SUBSONIC_TRANSCODE_CODEC/'"$SUBSONIC_TRANSCODE_CODEC"'/g' $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_TRANSCODE_MAX_BITRATE}" ]]; then
        sed -i 's/\#subsonictranscodemaxbitrate/subsonictranscodemaxbitrate/g' $CONFIG_FILE
        sed -i 's/SUBSONIC_TRANSCODE_MAX_BITRATE/'"$SUBSONIC_TRANSCODE_MAX_BITRATE"'/g' $CONFIG_FILE
    fi
    if [[ -n "${SUBSONIC_ENABLE_INTERNET_RADIOS}" ]]; then
        sed -i 's/\#subsonictaginitialpageenabledir/subsonictaginitialpageenabledir/g' $CONFIG_FILE
        enable_ir=1
        if [[ "${SUBSONIC_ENABLE_INTERNET_RADIOS^^}" == "NO" ]]; then
            enable_ir=0
        elif [[ ! "${SUBSONIC_ENABLE_INTERNET_RADIOS^^}" == "YES" ]]; then
            echo "Invalid SUBSONIC_ENABLE_INTERNET_RADIOS [${SUBSONIC_ENABLE_INTERNET_RADIOS}]"
            exit 2
        fi
        sed -i 's/SUBSONIC_ENABLE_INTERNET_RADIOS/'"$enable_ir"'/g' $CONFIG_FILE
    fi
fi

echo "RADIO_PARADISE_ENABLE=[$RADIO_PARADISE_ENABLE]"
if [ "${RADIO_PARADISE_ENABLE^^}" == "YES" ]; then
    echo "Enabling Radio Paradise, processing settings";
    RADIO_PARADISE_ENABLE=YES
    sed -i 's/\#radio-paradiseuser/radio-paradiseuser/g' $CONFIG_FILE
fi

echo "MOTHER_EARTH_RADIO_ENABLE=[$MOTHER_EARTH_RADIO_ENABLE]"
if [ "${MOTHER_EARTH_RADIO_ENABLE^^}" == "YES" ]; then
    echo "Enabling Mother Earth Radio, processing settings";
    MOTHER_EARTH_RADIO_ENABLE=YES
    sed -i 's/\#mother-earth-radiouser/mother-earth-radiouser/g' $CONFIG_FILE
fi

echo "TIDAL_ENABLE=[$TIDAL_ENABLE]"
if [ "${TIDAL_ENABLE^^}" == "YES" ]; then
    echo "Enabling new Tidal, processing settings";
    TIDAL_ENABLE=YES
    sed -i 's/\#tidaluser/tidaluser/g' $CONFIG_FILE
    echo "TIDAL_AUTOSTART=[$TIDAL_AUTOSTART]"
    if [[ -z "${TIDAL_AUTOSTART^^}" || "${TIDAL_AUTOSTART}" == "1" || "${SUBSONIC_AUTOSTART^^}" == "YES" ]]; then
        TIDAL_AUTOSTART=1
        sed -i 's/\#tidalautostart/tidalautostart/g' $CONFIG_FILE;
        set_parameter $CONFIG_FILE TIDAL_AUTOSTART "$TIDAL_AUTOSTART" tidalautostart
    fi
    echo "Setting Token Type [$TIDAL_TOKEN_TYPE]"
    sed -i 's/\#tidaltokentype/tidaltokentype/g' $CONFIG_FILE
    sed -i 's,TIDAL_TOKEN_TYPE,'"$TIDAL_TOKEN_TYPE"',g' $CONFIG_FILE
    echo "Setting Access Token [$TIDAL_ACCESS_TOKEN]"
    sed -i 's/\#tidalaccesstoken/tidalaccesstoken/g' $CONFIG_FILE
    sed -i 's,TIDAL_ACCESS_TOKEN,'"$TIDAL_ACCESS_TOKEN"',g' $CONFIG_FILE
    echo "Setting Access Token [$TIDAL_REFRESH_TOKEN]"
    sed -i 's/\#tidalrefreshtoken/tidalrefreshtoken/g' $CONFIG_FILE
    sed -i 's,TIDAL_REFRESH_TOKEN,'"$TIDAL_REFRESH_TOKEN"',g' $CONFIG_FILE
    echo "Setting Token Expiry Time [$TIDAL_EXPIRY_TIME]"
    sed -i 's/\#tidalexpirytime/tidalexpirytime/g' $CONFIG_FILE
    sed -i 's,TIDAL_EXPIRY_TIME,'"$TIDAL_EXPIRY_TIME"',g' $CONFIG_FILE
    if [[ -z "$TIDAL_AUDIO_QUALITY" ]]; then
        TIDAL_AUDIO_QUALITY="LOSSLESS"   
    fi
    echo "Setting Audio Quality [$TIDAL_AUDIO_QUALITY]"
    sed -i 's/\#tidalaudioquality/tidalaudioquality/g' $CONFIG_FILE
    sed -i 's,TIDAL_AUDIO_QUALITY,'"$TIDAL_AUDIO_QUALITY"',g' $CONFIG_FILE
    if [[ -n "${TIDAL_PREPEND_NUMBER_IN_ITEM_LIST}" ]]; then
        echo "TIDAL_PREPEND_NUMBER_IN_ITEM_LIST=[${TIDAL_PREPEND_NUMBER_IN_ITEM_LIST}]"
        if [[ "${TIDAL_PREPEND_NUMBER_IN_ITEM_LIST^^}" == "YES" || "${TIDAL_PREPEND_NUMBER_IN_ITEM_LIST^^}" == "Y" ]]; then
            #set prependnumberinitemlist
            sed -i 's/\#tidalprependnumberinitemlist/tidalprependnumberinitemlist/g' $CONFIG_FILE
            sed -i 's,TIDAL_PREPEND_NUMBER_IN_ITEM_LIST,'"1"',g' $CONFIG_FILE
        elif [[ "${TIDAL_PREPEND_NUMBER_IN_ITEM_LIST^^}" != "NO" && "${TIDAL_PREPEND_NUMBER_IN_ITEM_LIST^^}" == "N" ]]; then
            echo "Invalid TIDAL_PREPEND_NUMBER_IN_ITEM_LIST=[${TIDAL_PREPEND_NUMBER_IN_ITEM_LIST}]"
            exit 3
        fi
    fi
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
    if [[ -n "${QOBUZ_RENUM_TRACKS}" ]]; then
        qobuz_v=${QOBUZ_RENUM_TRACKS}
        if [[ "${qobuz_v}" == "0" || "${qobuz_v}" == "1" ]]; then
            sed -i 's/\#qobuzrenumtracks/qobuzrenumtracks/g' $CONFIG_FILE;
            sed -i 's/QOBUZ_RENUM_TRACKS/'"$QOBUZ_RENUM_TRACKS"'/g' $CONFIG_FILE;
        else
            echo "Invalid QOBUZ_RENUM_TRACKS=[${QOBUZ_RENUM_TRACKS}]"
            exit 3
        fi
    fi
    if [[ -n "${QOBUZ_EXPLICIT_ITEM_NUMBERS}" ]]; then
        qobuz_v=${QOBUZ_EXPLICIT_ITEM_NUMBERS}
        if [[ "${qobuz_v}" == "0" || "${qobuz_v}" == "1" ]]; then
            sed -i 's/\#qobuzexplicititemnumbers/qobuzexplicititemnumbers/g' $CONFIG_FILE;
            sed -i 's/QOBUZ_EXPLICIT_ITEM_NUMBERS/'"$QOBUZ_EXPLICIT_ITEM_NUMBERS"'/g' $CONFIG_FILE;
        else
            echo "Invalid QOBUZ_EXPLICIT_ITEM_NUMBERS=[${QOBUZ_EXPLICIT_ITEM_NUMBERS}]"
            exit 3
        fi
    fi
    if [[ -n "${QOBUZ_PREPEND_ARTIST_TO_ALBUM}" ]]; then
        qobuz_v=${QOBUZ_PREPEND_ARTIST_TO_ALBUM}
        if [[ "${qobuz_v}" == "0" || "${qobuz_v}" == "1" ]]; then
            sed -i 's/\#qobuzprependartisttoalbum/qobuzprependartisttoalbum/g' $CONFIG_FILE;
            sed -i 's/QOBUZ_PREPEND_ARTIST_TO_ALBUM/'"$QOBUZ_PREPEND_ARTIST_TO_ALBUM"'/g' $CONFIG_FILE;
        else
            echo "Invalid QOBUZ_PREPEND_ARTIST_TO_ALBUM=[${QOBUZ_PREPEND_ARTIST_TO_ALBUM}]"
            exit 3
        fi
    fi
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
    if [[ -z "${UPRCL_AUTOSTART}" || "${UPRCL_AUTOSTART}" == "1" || "${UPRCL_AUTOSTART^^}" == "YES" ]]; then
        UPRCL_AUTOSTART=1
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

RADIO_LIST=/tmp/radiolist.conf

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

cache_directory=/cache
if [ ! -w "$cache_directory" ]; then
    echo "Cache directory [${cache_directory}] is not writable"
    mkdir -p /tmp/cache
    cache_directory="/tmp/cache"
else
    echo "Cache directory [${cache_directory}] is writable"
fi
sed -i 's\CACHE_DIRECTORY\'"$cache_directory"'\g' $CONFIG_FILE

log_directory=/log
if [ ! -w "$log_directory" ]; then
    echo "Log directory [${log_directory}] is not writable"
    mkdir -p /tmp/log
    log_directory="/tmp/log"
else
    echo "Log directory [${log_directory}] is writable"
fi
sed -i 's\LOG_DIRECTORY\'"$log_directory"'\g' $CONFIG_FILE


cat $CONFIG_FILE

if [[ $current_user_id == 0 ]]; then
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

    if [ -z "${PUID}" ]; then
        PUID=$DEFAULT_UID;
        echo "Setting default value for PUID: ["$PUID"]"
    fi

    if [ -z "${PGID}" ]; then
        PGID=$DEFAULT_GID;
        echo "Setting default value for PGID: ["$PGID"]"
    fi

    echo "Ensuring user with uid:[$PUID] gid:[$PGID] exists ...";

    ### create group if it does not exist
    if [ ! $(getent group $PGID) ]; then
        echo "Group with gid [$PGID] does not exist, creating..."
        groupadd -g $PGID $GROUP_NAME
        echo "Group [$GROUP_NAME] with gid [$PGID] created."
    else
        GROUP_NAME=$(getent group $PGID | cut -d: -f1)
        echo "Group with gid [$PGID] name [$GROUP_NAME] already exists."
    fi

    ### create user if it does not exist
    if [ ! $(getent passwd $PUID) ]; then
        echo "User with uid [$PUID] does not exist, creating..."
        useradd -g $PGID -u $PUID -M $USER_NAME
        echo "User [$USER_NAME] with uid [$PUID] created."
    else
        USER_NAME=$(getent passwd $PUID | cut -d: -f1)
        echo "user with uid [$PUID] name [$USER_NAME] already exists."
        HOME_DIR="/home/$USER_NAME"
    fi

    ### create home directory
    if [ ! -d "$HOME_DIR" ]; then
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
    chown -R $USER_NAME:$GROUP_NAME /cache
    # Fix permission errors on existing files
    find /cache -type d -exec chmod 755 {} \;
    find /cache -type f -exec chmod 644 {} \;
    chown -R $USER_NAME:$GROUP_NAME /uprcl/confdir
    chown -R $USER_NAME:$GROUP_NAME /user/config
    chown -R $USER_NAME:$GROUP_NAME /log
    echo ". done."
fi

build_mode=`cat /app/conf/build_mode.txt`

echo "About to sleep for $STARTUP_DELAY_SEC second(s)"
sleep $STARTUP_DELAY_SEC
echo "Ready to start."

CMD_LINE="/usr/bin/upmpdcli -c $CONFIG_FILE"
echo "CMD_LINE=[${CMD_LINE}]"

if [[ $current_user_id -eq 0 ]]; then
    echo "USER MODE [$USER_NAME]"
    su - $USER_NAME -c "$CMD_LINE"
else
    echo "Running as current uid [$current_user_id] ..."
    eval "$CMD_LINE"
fi