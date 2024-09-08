#!/usr/bin/env sh

set -e

. "${BIN}/functions.sh"

log=/var/log/zdi-root.log

{
    show_info 'Setting up root.'

    echo "root:$(< /dev/urandom tr -dc '_A-Za-z0-9#!%' | head -c32)" | chpasswd

    show_success "Root setup complete. Log file '${log}'."

} 2>&1 | tee ${log}
