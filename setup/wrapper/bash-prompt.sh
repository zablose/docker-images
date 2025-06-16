#!/usr/bin/env bash

set -e

bin=/usr/local/bin

. "${bin}/exit-if-locked"
. "${bin}/functions.sh"
. "${bin}/source-env-file"

container=${ZDI_CONTAINER_NAME}
home=/home/${ZDI_USER_NAME}

tee -a /root/.bashrc <<EOF

# Set a fancy prompt
if [ "\`id -u\`" -eq 0 ]; then
    PS1='\[\033[0;90m\][\[\033[2;91m\]\u\[\033[0;90m\]@\[\033[2;92m\]${container}\[\033[0;90m\]][\[\033[0;94m\]\W\[\033[0;90m\]]\[\033[2;91m\]\\$\[\033[00m\] '
fi

EOF

tee -a "${home}/.bashrc" <<EOF

# Set a fancy prompt
if [ "\`id -u\`" -ne 0 ]; then
    PS1='\[\033[0;90m\][\[\033[2;93m\]\u\[\033[0;90m\]@\[\033[2;92m\]${container}\[\033[0;90m\]][\[\033[0;94m\]\W\[\033[0;90m\]]\[\033[2;93m\]\\$\[\033[00m\] '
fi

EOF
