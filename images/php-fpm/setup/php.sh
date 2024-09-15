#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/functions.sh"

env=${ARG_ENV}
version=${ARG_VERSION_PHP}
timezone=${ARG_TIMEZONE}
user=${ARG_USER_NAME}
group=${ARG_USER_GROUP_NAME}

user_bin=/home/${user}/bin
dir_php=/etc/php/${version}
fpm_conf=${dir_php}/fpm/php-fpm.conf
www_conf=${dir_php}/fpm/pool.d/www.conf
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

update_fpm()
{
    log_level=$(if [ "${env}" == 'dev' ]; then echo 'notice'; else echo 'error'; fi)

    sudo sed -i -e "s~^error_log\s.*$~error_log = /proc/self/fd/2~" "${fpm_conf}"
    sudo sed -i -e "s~^;log_level\s.*$~log_level = ${log_level}~" "${fpm_conf}"

    #sudo sed -i -e "s/^user\s.*$/user = ${user}/" "${www_conf}"
    #sudo sed -i -e "s/^group\s.*$/group = ${group}/" "${www_conf}"
    #sudo sed -i -e "s/^listen\.owner\s.*$/listen\.owner = ${user}/" "${www_conf}"
    #sudo sed -i -e "s/^listen\.group\s.*$/listen\.group = ${group}/" "${www_conf}"
    sudo sed -i -e "s/^listen\s.*$/listen = 9000/" "${www_conf}"
    sudo sed -i -e "s/^;catch_workers_output\s.*$/catch_workers_output = yes/" "${www_conf}"
}

update_xdebug()
{
    sudo tee -a "${dir_php}/mods-available/xdebug.ini" <<EOF

xdebug.start_with_request=no
xdebug.mode=coverage,debug,develop
xdebug.client_host=$(route | awk '/^default/ { print $2 }')

EOF
}

{
    show_info 'Setting up PHP.'

    update "${dir_php}/fpm/php.ini"
    update "${dir_php}/cli/php.ini"

    update_fpm

    update_xdebug
    bash "${user_bin}/xdebug-off"

    show_success "PHP setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
