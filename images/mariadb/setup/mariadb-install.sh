#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/functions.sh"

log=/var/log/zdi-mariadb-install.log

{
    show_info 'Install MariaDB server.'

    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        mariadb-server

    show_success "MariaDB server installation complete. Log file '${log}'."

} 2>&1 | tee ${log}
