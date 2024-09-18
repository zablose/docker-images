#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/functions.sh"

user_id=${ARG_USER_ID}
user_name=${ARG_USER_NAME}
group_id=${ARG_USER_GROUP_ID}
group_name=${ARG_USER_GROUP_NAME}
cmd_user=${ARG_CMD_USER}

dir_home=/home/${user_name}
bashrc=${dir_home}/.bashrc
log=/var/log/zdi-user.log

{
    show_info 'Setting up User.'

    groupadd -r -g "${group_id}" "${group_name}"
    useradd -s /bin/bash -u "${user_id}" -g "${group_name}" "${user_name}"
    adduser "${cmd_user}" "${group_name}"
    echo "${user_name}:$(< /dev/urandom tr -dc '_A-Za-z0-9#!%' | head -c32)" | chpasswd

    file=/etc/sudoers.d/${user_name}
    echo "${user_name} ALL=(ALL) NOPASSWD: ALL" > "${file}"
    chmod 0440 "${file}"

    cp /etc/skel/.bashrc "${bashrc}"

    tee -a "${bashrc}" <<EOF

    PATH=\$PATH:${dir_home}/bin

EOF

    chown -R "${user_id}":"${group_id}" "${dir_home}"
    reas "${dir_home}" 700 600
    reas "${dir_home}/bin" 700 500

    show_success "User setup complete. Log file '${log}'."

} 2>&1 | tee ${log}
