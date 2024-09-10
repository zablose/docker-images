#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/functions.sh"

version=${ARG_VERSION_PHP}
log=/var/log/zdi-php-install.log

{
    show_info 'Install PHP extensions.'

    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        "php${version}-apcu" \
        "php${version}-curl" \
        "php${version}-gd" \
        "php${version}-mbstring" \
        "php${version}-mysql" \
        "php${version}-sqlite3" \
        "php${version}-xdebug" \
        "php${version}-xml" \
        "php${version}-xsl" \
        "php${version}-zip"

    show_success "PHP extensions installation complete. Log file '${log}'."

} 2>&1 | tee ${log}
