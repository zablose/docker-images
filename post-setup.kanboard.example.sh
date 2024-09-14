#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/exit-if-locked"
. "${bin}/source-env-file"
. "${bin}/functions.sh"

web_root_dir=${ZDI_WEB_ROOT_DIR}
version=${ARG_VERSION_PHP}

dir_php=/etc/php/${version}
file=https://github.com/kanboard/kanboard/archive/refs/tags/v1.2.39.tar.gz
env_conf=https://github.com/kanboard/kanboard/blob/main/docker/etc/php83/php-fpm.d/env.conf
log=/var/log/zdi-post-setup-php-fpm.log

{
    show_info 'Php-fpm post setup.'

    cd ~
    wget ${file} --output-document=kanboard.tgz && \
    tar xzf kanboard.tgz -C "${web_root_dir}" --strip-components=1 && \
    rm kanboard.tgz

    sudo bash -c "wget ${env_conf} -O ->> ${dir_php}/fpm/pool.d/www.conf"

    r-web "${ZDI_WEB_ROOT_DIR}"

    show_success "Php-fpm post setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
