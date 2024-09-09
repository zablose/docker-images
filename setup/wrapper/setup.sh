#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/exit-if-locked"
. "${bin}/source-env-file"
. "${bin}/functions.sh"

user_name=${ZDI_USER_NAME}

home=/home/${user_name}
file=${home}/post-setup.sh
lock=${home}/.setup.lock

if [ -e "${file}" ]; then
    show_info 'Sourcing custom post setup script.'

    # shellcheck source=./post-setup.example.sh
    . "${file}"

    show_success 'Sourcing complete.'
else
    show_warning "Custom post setup script '${file}' not found. Skipping."
fi

r-web

true > "${lock}"
chmod 400 "${lock}"
