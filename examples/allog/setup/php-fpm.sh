#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/exit-if-locked"
. "${bin}/functions.sh"

user=${ZDI_USER_NAME}
web_app_dir=${ZDI_DIR_WEB_APP}

user_bin=/home/${user}/bin
log=/var/log/zdi-post-setup-php-fpm.log

{
    show_info 'Php-fpm post setup.'

    bash "${user_bin}/r-web"

    cd "${web_app_dir}"
    php "${user_bin}/composer" install

    show_success "Php-fpm post setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
