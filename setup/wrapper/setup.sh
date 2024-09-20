#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/exit-if-locked"
. "${bin}/functions.sh"

file=$HOME/post-setup.sh
lock=$HOME/.setup.lock

if [ -e "${file}" ]; then
    show_info 'Sourcing custom post setup script.'

    # shellcheck source=./post-setup.example.sh
    . "${file}"

    show_success 'Sourcing complete.'
else
    show_warning "Custom post setup script '${file}' not found. Skipping."
fi

true > "${lock}"
chmod 400 "${lock}"
