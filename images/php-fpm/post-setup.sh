#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/exit-if-locked"
. "${bin}/source-env-file"
. "${bin}/functions.sh"

log=/var/log/zdi-post-setup.log

{
    show_info 'Some custom post setup actions.'

    # bash ~/wrapper/php.sh

    show_success "Post setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
