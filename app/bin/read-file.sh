#!/bin/bash

declare -A file_dict

read_file() {
    SELECT_FILE=$1
    echo "Reading file $SELECT_FILE"
    while read line; do
        #echo "line: [$line]"
        [[ $line = *=* ]] && file_dict[${line%%=*}]=${line#*=}
    done < $SELECT_FILE
}
