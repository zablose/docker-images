#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/functions.sh"

cmd=${ZDI_CMD_FULL_PATH}

file=$HOME/post-start.sh

if [ -n "${cmd}" ]; then
    show_info 'Executing start command.'
    sudo "${cmd}" start
    show_success 'Executing complete.'
else
    show_warning "Start command is not set by 'ZDI_CMD_FULL_PATH' env variable. Skipping."
fi

if [ -e "${file}" ]; then
    show_info 'Sourcing custom start script.'

    # shellcheck source=./post-start.example.sh
    . "${file}"

    show_success 'Sourcing complete.'
else
    show_warning "Custom start script '${file}' not found. Skipping."
fi
