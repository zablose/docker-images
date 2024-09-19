#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/exit-if-locked"
. "${bin}/functions.sh"

db_host=${ZDI_DB_HOSTNAME}
db_name=${ZDI_DB_NAME}
db_password=${ZDI_DB_PASSWORD}
db_user=${ZDI_DB_USERNAME}
user=${ZDI_USER_NAME}
web_root_dir=${ZDI_WEB_ROOT_DIR}

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

    cd "${web_root_dir}"
    tee ./config.php <<EOF
<?php

define('DEBUG', true);
define('LOG_DRIVER', 'file');

define('DB_DRIVER', 'mysql');
define('DB_USERNAME', '${db_user}');
define('DB_PASSWORD', '${db_password}');
define('DB_HOSTNAME', '${db_host}');
define('DB_NAME', '${db_name}');

EOF

    show_success "Php-fpm post setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
