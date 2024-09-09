#!/usr/bin/env bash

set -e

. "${BIN}/functions.sh"

log=/var/log/zdi-apt.log

{
    show_info 'Installing Apt dependencies.'

    apt-get update
    apt-get install -y --no-install-recommends \
        apt-utils

    show_success "Apt dependencies installed. Log file '${log}'."

} 2>&1 | tee ${log}
