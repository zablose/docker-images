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
dir_web=${ZDI_DIR_WEB}
version_kanboard=${ZDI_VERSION_KANBOARD}
version_allog=${ZDI_VERSION_ALLOG}

user_home=/home/${user}
user_bin=${user_home}/bin
composer=${user_bin}/composer
file=https://github.com/kanboard/kanboard/archive/refs/tags/v${version_kanboard}.tar.gz
log=/var/log/zdi-post-setup-php-fpm.log

{
    show_info 'Php-fpm post setup.'

    bash "${user_bin}/r-web"

    cd ~
    wget "${file}" --output-document=kanboard.tgz && \
    tar xzf kanboard.tgz -C "${dir_web}" --strip-components=1 && \
    rm kanboard.tgz

    bash "${user_bin}/r-web"

    reas "${dir_web}/data" 770 660
    reas "${dir_web}/plugins" 770 660

    cd "${dir_web}"
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

    sed -i -e "/vendor\/autoload.php/a (new \\\Zablose\\\Allog\\\Client((new \\\Zablose\\\Allog\\\Config\\\Client())->read(__DIR__.'/../.env')))->send();" app/common.php

    wget "https://raw.githubusercontent.com/kanboard/kanboard/refs/tags/v${version_kanboard}/composer.json"
    wget "https://raw.githubusercontent.com/kanboard/kanboard/refs/tags/v${version_kanboard}/composer.lock"

    ${composer} require "zablose/allog:${version_allog}" --update-no-dev
    ${composer} dump-autoload

    show_success "Php-fpm post setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
