#!/usr/bin/env bash

set -e

. "${BIN}/functions.sh"

log=/var/log/zdi-timezone.log

{
    show_info 'Setting up Timezone.'

    echo "${ARG_TIMEZONE}" | tee /etc/timezone
    rm /etc/localtime
    dpkg-reconfigure -f noninteractive tzdata

    show_success "Timezone setup complete. Log file '${log}'."

} 2>&1 | tee ${log}
