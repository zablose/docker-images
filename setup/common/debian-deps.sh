#!/usr/bin/env bash

set -e

. "${BIN}/functions.sh"

log=/var/log/zdi-deps.log

{
    show_info 'Installing dependencies.'

    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apt-transport-https \
        bzip2 \
        ca-certificates \
        curl \
        default-mysql-client \
        dkms \
        git \
        gnupg2 \
        htop \
        less \
        libpng-dev \
        libzip-dev \
        linux-headers-"$(dpkg --print-architecture)" \
        make \
        mariadb-client \
        net-tools \
        sudo \
        unzip \
        vim

    show_success "Dependencies installed. Log file '${log}'."

} 2>&1 | tee ${log}
