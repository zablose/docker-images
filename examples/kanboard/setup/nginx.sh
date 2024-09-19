#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/exit-if-locked"
. "${bin}/source-env-file"
. "${bin}/functions.sh"

env=${ZDI_ENV}
user=${ZDI_USER_NAME}
web_root_dir=${ZDI_WEB_ROOT_DIR}
domain=${ZDI_WEB_DOMAIN}
php_host=${ZDI_PHP_FPM_HOST}

user_bin=/home/${user}/bin
log=/var/log/zdi-post-setup-nginx.log

. "${user_bin}/functions.sh"

{
    show_info 'Nginx post setup.'

    nginx_set_user_and_log "${env}"
    nginx_generate_certs "${domain}"
    nginx_update_main_conf "${domain}" "${web_root_dir}" "${php_host}"

    show_success "Nginx post setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
