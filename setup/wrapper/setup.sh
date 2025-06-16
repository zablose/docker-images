#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-locked"
. "${bin}/functions.sh"
. "${bin}/source-env-file"

env=${ZDI_ENV}
envs="${envs} ZDI_CONTAINER_NAME=${ZDI_CONTAINER_NAME}"
envs="${envs} ZDI_DB_HOSTNAME=${ZDI_DB_HOSTNAME}"
envs="${envs} ZDI_PHP_FPM_HOST=${ZDI_PHP_FPM_HOST}"
user=${ZDI_USER_NAME}

home=/home/${user}
file=${home}/post-setup.sh
lock=/home/.setup.lock

if [ -e "${file}" ]; then
    show_info 'Sourcing custom post setup script.'

    runuser -l "${user}" -c "${envs}; source ${file}"

    show_success 'Sourcing complete.'
else
    show_warning "Custom post setup script '${file}' not found. Skipping."
fi

if [ "${env}" == 'production' ] && command -v sudo >/dev/null 2>&1; then
    show_info 'Production environment - uninstalling sudo.'

    DEBIAN_FRONTEND=noninteractive apt-get remove -y sudo

    show_success 'Uninstall complete.'
fi

true > "${lock}"
chmod 400 "${lock}"
