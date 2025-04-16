#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/functions.sh"

add_nvm=${ARG_ADD_NVM}
version_nvm=${ARG_VERSION_NVM}
version_nodejs=${ARG_VERSION_NODEJS}
user_name=${ARG_USER_NAME}

dir_home=/home/${user_name}
log=/var/log/zdi-nvm.log

{
    if [[ "$add_nvm" != "true" ]]
    then
        show_warning 'Skipping NVM installation.'
        exit 0
    fi

    show_info 'Setting up NVM.'

    # Load NVM
    export NVM_DIR="${dir_home}/.nvm"
    git clone -b "v${version_nvm}" --depth=1 --single-branch https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    nvm install "${version_nodejs}"

    tee -a "${dir_home}/.bashrc" <<EOF

export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"

EOF

    show_info "NVM setup complete. Log file '${log}'."

} 2>&1 | sudo tee ${log}
