#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/functions.sh"

env=${ARG_ENV}
version=${ARG_VERSION_PHP}
timezone=${ARG_TIMEZONE}
user_bin=/home/${ARG_USER_NAME}/bin

dir_php=/etc/php/${version}
log=/var/log/zdi-php.log

update()
{
    report=$(if [ "${env}" == 'dev' ]; then echo 'E_ALL'; else echo 'E_ALL \& ~E_DEPRECATED \& ~E_STRICT'; fi)
    display=$(if [ "${env}" == 'dev' ]; then echo 'On'; else echo 'Off'; fi)

    sudo sed -i -e "s/^error_reporting\s.*$/error_reporting = ${report}/" "$1"
    sudo sed -i -e "s/^display_errors\s.*$/display_errors = ${display}/" "$1"
    sudo sed -i -e "s/^display_startup_errors\s.*$/display_startup_errors = ${display}/" "$1"

    # '~' is used as the delimiter, because timezone has '/' inside.
    sudo sed -i -e "s~^;date.timezone\s.*$~date.timezone = \"${timezone}\"~" "$1"
}

update_xdebug()
{
    xdebug=$(if [ "${env}" == 'dev' ]; then echo 'yes'; else echo 'no'; fi)

    sudo tee -a "${dir_php}/mods-available/xdebug.ini" <<EOF

xdebug.start_with_request=${xdebug}
xdebug.mode=coverage,debug,develop
xdebug.client_host=$(route | awk '/^default/ { print $2 }')

EOF
}

{
    show_info 'Setting up PHP.'

    update "${dir_php}/fpm/php.ini"
    update "${dir_php}/cli/php.ini"

    update_xdebug
    bash "${user_bin}/xdebug-off"

    show_success "PHP setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
