#!/usr/bin/env bash

set -e

. "${BIN}/functions.sh"

timezone=${ARG_TIMEZONE}
log=/var/log/zdi-timezone.log

{
    show_info 'Setting up Timezone.'

    echo "${timezone}" | tee /etc/timezone
    rm /etc/localtime
    dpkg-reconfigure -f noninteractive tzdata

    show_success "Timezone '${timezone}' setup complete. Log file '${log}'."

} 2>&1 | tee ${log}
