#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/functions.sh"

cmd=${ZDI_CMD_FULL_PATH}

file=$HOME/post-start.sh

if [ -n "${cmd}" ]; then
    show_info 'Executing start command.'
    ${cmd} start
    show_success 'Execution complete.'
else
    show_warning "Start command is not set by 'ZDI_CMD_FULL_PATH' env variable. Skipping."
fi

if [ -e "${file}" ]; then
    show_info 'Sourcing custom start script.'

    # shellcheck source=./post-start.sh
    . "${file}"

    show_success 'Sourcing complete.'
else
    show_warning "Custom start script '${file}' not found. Skipping."
fi
