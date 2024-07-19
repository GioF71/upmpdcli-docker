#!/bin/bash

set_parameter() {
    CFG_FILE=$1
    PARAM_NAME=$2
    PARAM_VALUE=$3
    PARAM_KEY=$4
    echo "$PARAM_NAME=["$PARAM_VALUE"] for key [$PARAM_KEY] on file $CFG_FILE"
    if [ -z "${PARAM_VALUE}" ]; then
        echo "$PARAM_NAME not set"
    else 
        echo "Setting value for key [${PARAM_KEY}] to [${PARAM_VALUE}]"
        echo "$PARAM_KEY = ${PARAM_VALUE}" >> $CONFIG_FILE
    fi
}
