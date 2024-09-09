#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/functions.sh"

dir_php=/usr/local/etc/php
dir_conf=${dir_php}/conf.d
dir_disabled=${dir_php}/disabled
log=/var/log/zdi-php.log

{
    show_info 'Setting up PHP.'



    show_success "PHP setup complete. Log file '${log}'."

} 2>&1 | tee ${log}
