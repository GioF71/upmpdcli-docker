#!/bin/bash

get_value() {
    ARG_NAME=$1
    PRIO=$2
    RESULT=""
    if [ -z "${PRIO}" ]; then
        PRIO="file"
    fi
    #echo "Searching value for [$ARG_NAME] Prio set to [$PRIO]"
    #echo "Trying file first"
    if [[ -v file_dict[${ARG_NAME}] ]]; then
        FROM_DICT=${file_dict[${ARG_NAME}]};
        #echo "FROM_DICT=[$FROM_DICT]"
    fi
    #echo "Look in variables"
    FROM_ENV=${!ARG_NAME}
    #echo "$ARG_NAME available as variable -> [${FROM_ENV}]"    
    if [[ "${PRIO}" == "file" ]]; then
        if [[ -n "${FROM_DICT}" ]]; then
            RESULT=$FROM_DICT
        else
            RESULT=$FROM_ENV
        fi
    else
        if [[ -n "${FROM_ENV}" ]]; then
            RESULT=$FROM_ENV
        else
            RESULT=$FROM_DICT
        fi
    fi
    #echo "RESULT=[$RESULT]"
    echo ${RESULT}
}
