#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-root"
. "${bin}/exit-if-locked"
. "${bin}/source-env-file"
. "${bin}/functions.sh"

domain=${ZDI_WEB_DOMAIN}
user_name=${ZDI_USER_NAME}

home=/home/${user_name}

sudo tee -a /root/.bashrc <<EOF

# Set a fancy prompt
if [ "\`id -u\`" -eq 0 ]; then
    PS1='\[\033[0;90m\][\[\033[2;91m\]\u\[\033[0;90m\]@\[\033[2;92m\]${domain}\[\033[0;90m\]][\[\033[0;94m\]\W\[\033[0;90m\]]\[\033[2;91m\]\\$\[\033[00m\] '
fi

EOF

sudo tee -a "${home}/.bashrc" <<EOF

# Set a fancy prompt
if [ "\`id -u\`" -ne 0 ]; then
    PS1='\[\033[0;90m\][\[\033[2;93m\]\u\[\033[0;90m\]@\[\033[2;92m\]${domain}\[\033[0;90m\]][\[\033[0;94m\]\W\[\033[0;90m\]]\[\033[2;93m\]\\$\[\033[00m\] '
fi

EOF
