#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/exit-if-locked"
. "${bin}/source-env-file"
. "${bin}/functions.sh"

web_root_dir=${ZDI_WEB_ROOT_DIR}
user=${ZDI_USER_NAME}

user_bin=/home/${user}/bin
file=https://github.com/kanboard/kanboard/archive/refs/tags/v1.2.39.tar.gz
log=/var/log/zdi-post-setup-php-fpm.log

{
    show_info 'Php-fpm post setup.'

    bash "${user_bin}/r-web"

    cd ~
    wget ${file} --output-document=kanboard.tgz && \
    tar xzf kanboard.tgz -C "${web_root_dir}" --strip-components=1 && \
    rm kanboard.tgz

    bash "${user_bin}/r-web"

    reas "${web_root_dir}/data" 770 660
    reas "${web_root_dir}/plugins" 770 660

    show_success "Php-fpm post setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
