#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/source-env-file"
. "${bin}/functions.sh"

user_name=${ZDI_USER_NAME}
cmd=${ZDI_CMD_FULL_PATH}

home=/home/${user_name}
file=${home}/post-stop.sh

if [ -n "${cmd}" ]; then
    show_info 'Executing stop command.'
    sudo "${cmd}" stop
    show_success 'Executing complete.'
else
    show_warning "Stop command is not set by 'ZDI_CMD_FULL_PATH' env variable. Skipping."
fi

if [ -e "${file}" ]; then
    show_info 'Sourcing custom stop script.'

    # shellcheck source=./post-stop.example.sh
    . "${file}"

    show_success 'Sourcing complete.'
else
    show_warning "Custom stop script '${file}' not found. Skipping."
fi
