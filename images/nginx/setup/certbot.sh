#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/functions.sh"

log=/var/log/zdi-certbot.log

{
    show_info 'Installing Certbot for Nginx.'

    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        certbot \
        python3-certbot-nginx

    show_success "Certbot installed. Log file '${log}'."

} 2>&1 | tee ${log}
