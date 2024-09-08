#!/usr/bin/env bash

set -e

. "${BIN}/functions.sh"

log=/var/log/zdi-apt-cleanup.log

{
    show_info 'Do Apt cleanup.'

    apt clean
    rm -rf /var/lib/apt/lists

    show_success "Apt cleanup complete. Log file '${log}'."

} 2>&1 | tee ${log}
