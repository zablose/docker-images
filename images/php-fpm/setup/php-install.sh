#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/functions.sh"

version=${ARG_VERSION_PHP}
log=/var/log/zdi-php-install.log

{
    show_info 'Install PHP.'

    echo 'deb https://packages.sury.org/php/ bookworm main' > /etc/apt/sources.list.d/php.list
    curl -sS https://packages.sury.org/php/apt.gpg > /etc/apt/trusted.gpg.d/php.gpg
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        "php${version}-fpm"

    show_success "PHP installation complete. Log file '${log}'."

} 2>&1 | tee ${log}
